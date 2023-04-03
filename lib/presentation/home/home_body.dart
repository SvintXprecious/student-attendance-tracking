import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/presentation/home/components/attendance_chart.dart';
import 'package:student_attendance/presentation/home/components/course_carousel.dart';
import 'package:student_attendance/state/auth/providers/auth_state_provider.dart';
import 'package:student_attendance/state/module/providers/fetch_all_sessions_by_code_provider.dart';
import 'package:student_attendance/state/module/providers/fetch_student_modules_provider.dart';
import 'package:student_attendance/state/sessions/model/session.dart';
import 'package:student_attendance/state/sessions/providers/fetch_Student_Sessions_Provider.dart';
import 'package:student_attendance/state/users/providers/user_info_model_provider.dart';
import 'package:student_attendance/widgets/widgets.dart';

import 'components/sessions.dart';
import 'components/statistics_card.dart';

class HomeBody extends ConsumerWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var authState = authStateProvider;
    final userInfo = ref.read(userInfoModelProvider(authState));



    var studentName = '';
    var programCode = '';
    var userID = '';
    userInfo.when(
        data: (student) {
          studentName = student.name;
          programCode = student.code;
          userID = student.uid;
        },
        error: (error, stack) => null,
        loading: () => null);


    final modules = ref
        .watch(fetchStudentModulesProvider(userInfoModelProvider(authState)));
    final sessions = ref
        .watch(fetchStudentSessionsProvider(userInfoModelProvider(authState)));
    var allSessions = ref.watch(fetchAllSessionsByCodeProvider(programCode));

    var dimension = Dimensions(context: context);
    return RefreshIndicator(
        onRefresh: () {
          ref.refresh(
              fetchStudentSessionsProvider(userInfoModelProvider(authState)));
          ref.refresh(
              fetchStudentModulesProvider(userInfoModelProvider(authState)));
          ref.refresh(fetchAllSessionsByCodeProvider(programCode));

          return Future.delayed(const Duration(seconds: 1));
        },
        child: Container(
          child: modules.when(

              data: (modules) {
                if (modules.isEmpty) {
                  return Container();
                } else {
                  return Container(
                    padding: EdgeInsets.only(
                        left: dimension.horizontalPadding20,
                        right: dimension.horizontalPadding20,
                        top: dimension.verticalPadding20),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Greeting
                          StudlyTypography(
                            text: "Hello, $studentName",
                            fontSize: dimension.font18,
                            fontWeight: FontWeight.normal,
                          ),
                          SizedBox(
                            height: dimension.sizedBox20,
                          ),
                          //Course section
                          Section(
                            section: "Your Courses",
                            onTap: () {
                              Navigator.pushNamed(context, '/modules',
                                  arguments: modules);
                            },
                          ),
                          CourseCarousel(modules: modules),
                          SizedBox(height: dimension.sizedBox40),
                          //Attendance section
                          StudlyTypography(
                            text: "Attendance",
                            fontSize: dimension.font19,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(height: dimension.sizedBox30),
                          //Attendance statistics
                          allSessions.when(
                              data: (allSessions) {
                                Map<String, int> attendance =
                                    getStudentAttendance(
                                        sessions: allSessions.where((session) =>
                                            DateTime.now()
                                                .difference(DateTime.parse(
                                                    session.date))
                                                .inDays >=
                                            0),
                                        userID: userID);
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        StatisticsCard(
                                          label: 'Present',
                                          value:
                                              attendance['Present'].toString(),
                                          backgroundColor: StudlyColors
                                              .statsCardBackgroundGreen,
                                          width: dimension.containerWidth120,
                                          height: dimension.containerHeight150,
                                        ),
                                        SizedBox(height: dimension.sizedBox10),
                                        StatisticsCard(
                                          label: 'Absent',
                                          value:
                                              attendance['Absent'].toString(),
                                          backgroundColor: StudlyColors
                                              .statsCardBackgroundRed,
                                          width: dimension.containerWidth120,
                                          height: dimension.containerHeight150,
                                        )
                                      ],
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        height: dimension.containerHeight310,
                                        margin: EdgeInsets.only(
                                            left:
                                                dimension.horizontalPadding10),
                                        decoration: BoxDecoration(
                                          color: StudlyColors
                                              .backgroundColorBlueAccent,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: dimension
                                                      .verticalPadding20),
                                              child: StudlyTypography(
                                                text: "Weekly activity",
                                                fontSize: dimension.font16,
                                              ),
                                            ),
                                            const WeeklyActivity()
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              },
                              error: (error, stack) => Container(),
                              loading: () => Container()),

                          SizedBox(height: dimension.sizedBox40),
                          //Class section
                          Section(
                            section: "Today's Classes",
                            onTap: () {
                              Navigator.pushNamed(context, '/lessons');
                            },
                          ),
                          SizedBox(
                              height: dimension.sizedBox520,
                              child: sessions.when(
                                  data: (sessions) {
                                    return Sessions(
                                        sessions: sessions.where((session) =>
                                            DateFormat.yMMMMd().format(
                                                DateTime.parse(session.date)) ==
                                            DateFormat.yMMMMd()
                                                .format(DateTime.now())));
                                  },
                                  error: (error, stack) => Container(),
                                  loading: () => Container())),
                        ],
                      ),
                    ),
                  );
                }
              },
              error: (error, stack) => Container(),
              loading: () => Container()),
        ));
  }

  Map<String, int> getStudentAttendance(
      {required Iterable<Session> sessions, required String userID}) {
    var totalSessions = 0;
    var present = 0;

    for (var session in sessions) {
      var attendee = session.attendees.firstWhere(
        (attendee) => attendee.containsValue(userID),
        orElse: () => {},
      );
      if (attendee.isNotEmpty) {
        var checkedIn = attendee['clock_in'].toString().isNotEmpty;
        var checkedOut = attendee['clock_out'].toString().isNotEmpty;
        if (checkedIn && checkedOut) {
          present += 1;
        }
      }
      totalSessions += 1;
    }

    return {'Present': present, 'Absent': totalSessions - present};
  }
}
