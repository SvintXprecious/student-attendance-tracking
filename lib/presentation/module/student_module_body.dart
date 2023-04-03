import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/presentation/module/components/student_module_card_builder.dart';
import 'package:student_attendance/state/auth/providers/auth_state_provider.dart';
import 'package:student_attendance/state/module/providers/fetch_student_modules_provider.dart';
import 'package:student_attendance/state/users/providers/user_info_model_provider.dart';


class StudentModuleBody extends ConsumerWidget {
  const StudentModuleBody({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context,WidgetRef ref) {
    var dimension=Dimensions(context: context);
    final modules=ref.watch(fetchStudentModulesProvider(userInfoModelProvider(authStateProvider)));
    return RefreshIndicator(
      onRefresh: () {
        ref.refresh(fetchStudentModulesProvider(userInfoModelProvider(authStateProvider)));
        return Future.delayed(const Duration(seconds: 1));},
      child: Container(
        margin: EdgeInsets.only(
            left: dimension.horizontalPadding20,
            right: dimension.horizontalPadding20,
            top: dimension.verticalPadding20),
        child:modules.when(
          data: (modules) => StudentModuleCardBuilder(modules: modules),
          error: (error, stackTrace) => Container(),
          loading: () => Container(),
        ),
      ),
    );

  }
}
