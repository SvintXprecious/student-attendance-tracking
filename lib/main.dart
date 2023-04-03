import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/presentation/home/home.dart';
import 'package:student_attendance/presentation/lecturer/home/studly+_home.dart';
import 'package:student_attendance/presentation/loading_screen.dart';
import 'package:student_attendance/presentation/login/login.dart';
import 'package:student_attendance/state/auth/providers/auth_state_provider.dart';
import 'package:student_attendance/state/auth/providers/is_logged_in_provider.dart';
import 'package:student_attendance/state/providers/is_loading_provider.dart';
import 'package:student_attendance/state/users/logic/user_info.dart';
import 'package:student_attendance/state/users/providers/user_info_model_provider.dart';

import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]);
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

class App extends ConsumerWidget {
  const App({
    Key? key,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Studly',
      home: Consumer(
        builder: (context, ref, child) {
          // install the loading screen
          ref.listen<bool>(
            isLoadingProvider,
            (_, isLoading) {
              if (isLoading) {
                LoadingScreen.instance().show(
                  context: context,
                );
              } else {
                LoadingScreen.instance().hide();
              }
            },
          );
          final isLoggedIn = ref.watch(isLoggedInProvider);

          if (isLoggedIn) {
            var email = '';
            var student = ref
                .watch(userInfoModelProvider(authStateProvider))
                .when(
                    data: (student) => email = student.email,
                    error: (err, stack) => Container(),
                    loading: () => Container());
            if (UserInformation.studentEmailValidation(email)) {
              return const Home();
            }

            /**else if (UserInformation.lecturerEmailValidation(email)){
                return Container(
                color: Colors.white,
                child: StudlyTypography(
                text: "Welcome sir!"),
                );
                }**/

            else {
              return StudlyPlusHomeUI();
            }
          } else {
            return const LoginView();
          }
        },
      ),
      onGenerateRoute: AppRouter.onGenerateRoute,
      //initialRoute: Home.routeName,
    );
  }
}
