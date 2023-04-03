import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/presentation/class/components/lesson_card_builder.dart';
import 'package:student_attendance/state/auth/providers/auth_state_provider.dart';
import 'package:student_attendance/state/sessions/providers/fetch_Student_Sessions_Provider.dart';
import 'package:student_attendance/state/users/providers/user_info_model_provider.dart';

class LessonsView extends ConsumerWidget {
  const LessonsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    var dimension=Dimensions(context: context);
    final sessions=ref.watch(fetchStudentSessionsProvider(userInfoModelProvider(authStateProvider)));
    return RefreshIndicator(
      onRefresh: () {
        ref.refresh(fetchStudentSessionsProvider(userInfoModelProvider(authStateProvider)));
        return Future.delayed(const Duration(seconds: 1));
      },
      child: Container(
        margin: EdgeInsets.only(
            left: dimension.horizontalPadding20,
            right: dimension.horizontalPadding20,
            top: dimension.verticalPadding20),
        child:sessions.when(
            data: (sessions) => LessonCardBuilder(sessions: sessions
                .where((session) =>DateFormat.yMMMMd().format(DateTime.parse(session.date)) == DateFormat.yMMMMd().format(DateTime.now()))),
            error: (error, stackTrace) => Container(),
            loading: () => Container(),
        ),
        ),
    );

  }
}
