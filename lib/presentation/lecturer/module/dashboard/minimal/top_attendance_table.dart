import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:student_attendance/config/colors.dart';
import 'package:student_attendance/config/utils.dart';
import 'package:student_attendance/state/module/model/module.dart';
import 'package:student_attendance/state/module/providers/fetch_all_sessions_provider.dart';
import 'package:student_attendance/state/sessions/model/session.dart';
import 'package:student_attendance/state/users/providers/fetch_students_info.dart';
import 'package:student_attendance/widgets/widgets.dart';

class AttendanceTableMinimal extends ConsumerWidget {
  const AttendanceTableMinimal({Key? key, required this.module})
      : super(key: key);
  final Module module;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var sessions = ref.watch(fetchAllSessionsProvider(module.code));
    var columns = ['Ranking', 'Name', 'Score'];
    List<List<String>> attendance=[];
    return SizedBox(
      width: double.maxFinite,
      child: sessions.when(
          data: (sessions) {
            var attendance = getTopAttendance(sessions);
            if(attendance.isEmpty){
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 10,right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StudlyTypography(
                          text: "Top Attendance",
                        ),
                        InkWell(
                          onTap: (){},
                          child: Container(
                            height: 40,width: 40,
                            decoration: BoxDecoration(
                                color: StudlyColors.backgroundColorSlate,
                                borderRadius: BorderRadius.circular(30)),
                            child: Icon(Iconsax.hashtag_1,color: StudlyColors.iconColorWhite,),),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  DataTable(
                    columnSpacing: 70,
                    columns: getColumns(columns),
                    rows: getRows(
                        attendees: [],
                        ref: ref,
                        overallAttendanceCount: 0),
                    dividerThickness: 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: StudlyColors.backgroundColorLightGray,
                    ),
                  ),
                ],
              );

            }
            else{
              int total = attendance
                .map((attendee) => attendee.value)
                .reduce((value1, value2) => value1 + value2);

              return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 10,right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StudlyTypography(
                        text: "Top Attendance",
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.pushNamed(context, '/attendancetable',
                            arguments: ModuleAttendanceDetails(module: module, attendance: attendance));},
                        child: Container(
                          height: 40,width: 40,
                          decoration: BoxDecoration(
                              color: StudlyColors.backgroundColorSlate,
                              borderRadius: BorderRadius.circular(30)),
                          child: Icon(Iconsax.hashtag_1,color: StudlyColors.iconColorWhite,),),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                DataTable(
                  columnSpacing: 20,
                  columns: getColumns(columns),
                  rows: getRows(
                      attendees: attendance.sublist(0, 1),
                      ref: ref,
                      overallAttendanceCount: total),
                  dividerThickness: 2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: StudlyColors.backgroundColorLightGray,
                  ),
                ),
              ],
            );}
          },
          error: (error, stack) => Container(),
          loading: () => Container()),
    );
  }

  List<DataColumn> getColumns(List<String> columns) {
    return columns.map((String column) {
      final isRank = column == columns[0];

      return DataColumn(
        label: Text(column),
      );
    }).toList();
  }

  List<DataRow> getRows({required List<MapEntry<String, int>> attendees,
          required WidgetRef ref,
          required int overallAttendanceCount}) =>
      attendees.map((attendee) {
        var name = '';
        var reg='';
        var student = ref.watch(fetchStudentInfoProvider(attendee.key));
        student.when(
            data: (user) { name = user.name;reg=user.studentId;},
            error: (error, stack) => null,
            loading: () => null);
        final cells = [
          (attendees.indexOf(attendee) + 1).toString(),
          name.toString(),
          '${getScore(attendanceCount: attendee.value, overallAttendanceCount: overallAttendanceCount).round()}%'
        ];

        return DataRow(
          cells: Utils.modelBuilder(cells, (index, cell) {
            return DataCell(
              Text('$cell'),
            );
          }),
        );
      }).toList();

  List<MapEntry<String, int>> getTopAttendance(Iterable<Session> sessions) {
    var overallAttendance = <String, int>{};
    for (var session in sessions) {
      var sessionAttendance = session.attendees;
      for (var attendee in sessionAttendance) {
        if (attendee['clock_in'].toString().isNotEmpty &&
            attendee['clock_out'].toString().isNotEmpty) {
          overallAttendance[attendee['uid']] =
              overallAttendance[attendee['uid']] == null
                  ? 1
                  : overallAttendance[attendee['uid']]! + 1;
        }
      }
    }

    var sortedAttendance = overallAttendance.entries.toList();
    sortedAttendance.sort((a, b) => b.value.compareTo(a.value));
    return sortedAttendance;
  }

  double getScore(
          {required int attendanceCount,
          required int overallAttendanceCount}) =>
      (attendanceCount / overallAttendanceCount) * 100;
}

class ModuleAttendanceDetails{
  ModuleAttendanceDetails({required this.module,required this.attendance});
  final Module module;
  final List<MapEntry<String,int>> attendance;
}
