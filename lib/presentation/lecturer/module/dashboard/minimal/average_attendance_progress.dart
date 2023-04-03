import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/state/module/model/module.dart';
import 'package:student_attendance/state/module/providers/fetch_all_sessions_provider.dart';
import 'package:student_attendance/state/sessions/model/session.dart';
import 'package:student_attendance/widgets/widgets.dart';

class AverageAttendanceProgressMinimal extends ConsumerStatefulWidget {
  const AverageAttendanceProgressMinimal(
      {Key? key, required this.module, required this.totalSessions,required this.totalEnrolled})
      : super(key: key);
  final Module module;
  final int totalSessions;
  final int totalEnrolled;

  @override
  ConsumerState<AverageAttendanceProgressMinimal> createState() =>
      _AverageAttendanceProgressMinimalState();
}

class _AverageAttendanceProgressMinimalState
    extends ConsumerState<AverageAttendanceProgressMinimal> {
  double percent = 0.0;

  @override
  void initState() {
    super.initState();
    Timer? timer;
    timer = Timer.periodic(const Duration(milliseconds: 1000), (_) {
      setState(() {
        percent += 10;
        if (percent >= 100) {
          timer!.cancel();
          // percent=0;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var dimension = Dimensions(context: context);
    var sessions = ref.watch(fetchAllSessionsProvider(widget.module.code));
    return RefreshIndicator(
      onRefresh: () {
        ref.refresh(fetchAllSessionsProvider(widget.module.code));
        return Future.delayed(const Duration(seconds: 1));
      },
      child: Container(
        padding: EdgeInsets.only(
            top: dimension.verticalPadding10,
            left: dimension.horizontalPadding10,
            right: dimension.horizontalPadding10),
        decoration: BoxDecoration(
            color: StudlyColors.backgroundColorLightGray,
            borderRadius: BorderRadius.circular(30)),
        child: sessions.when(
            data: (sessions) {
              var totalAttendance = getAttendancePerSession(sessions)
                  .reduce((value, element) => value + element);
              var averageAttendance = (totalAttendance / widget.totalSessions) * 100;
              return Column(
                children: [
                  SizedBox(
                    height: dimension.verticalPadding10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          child: StudlyTypography(
                        text: "Average Attendance Rate",
                        fontSize: dimension.font13,
                        maxLines: null,
                        textOverflow: TextOverflow.visible,
                      )),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, '/averageAttendanceProgress',
                              arguments: AttendancePayload(attendance:getAttendancePerSession(sessions),session:widget.totalSessions,module: widget.module,enrolled: widget.totalEnrolled));
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              color: StudlyColors.backgroundColorSlate,
                              borderRadius: BorderRadius.circular(30)),
                          child: const Icon(
                            Iconsax.graph,
                            color: StudlyColors.iconColorWhite,
                          ),
                        ),
                      ),
                    ],
                  ),
                  CircularPercentIndicator(
                    radius: 120.0,
                    lineWidth: 10.0,
                    animation: true,
                    percent: totalAttendance / widget.totalSessions,
                    center: StudlyTypography(
                      text: "${averageAttendance.round()}%",
                    ),
                    backgroundColor: StudlyColors.backgroundColor,
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: StudlyColors.statsCardBackgroundGreen,
                  ),
                ],
              );
            },
            error: (error, stack) => Container(),
            loading: () => Container()),
      ),
    );
  }

  List<int> getAttendancePerSession(Iterable<Session> sessions) {
    List<int> attendance = [];

    var presence = 0;
    for (var attendees in sessions.where((element) =>
        DateTime.now().difference(DateTime.parse(element.date)).inDays >= 0)) {
      for (var attendance in attendees.attendees) {
        if (attendance['clock_in'].toString().isNotEmpty &&
            attendance['clock_out'].toString().isNotEmpty) {
          presence += 1;
        }
      }
      attendance.add(presence);
      presence = 0;
    }

    return attendance;
  }
}

class AttendancePayload{
  AttendancePayload({required this.attendance,required this.session,required this.module ,required this.enrolled});
  final List<int> attendance;
  final int session;
  final Module module;
  final int enrolled;



}
