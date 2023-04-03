import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:student_attendance/api/pdf_api.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/config/utils.dart';
import 'package:student_attendance/presentation/lecturer/module/dashboard/minimal/top_attendance_table.dart';
import 'package:student_attendance/state/users/providers/fetch_students_info.dart';
import 'package:student_attendance/widgets/widgets.dart';

import '../../../../../api/module_attendance_api.dart';

class AttendanceTable extends ConsumerWidget {
  static const String routeName = '/attendancetable';

  static Route route({required ModuleAttendanceDetails details}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => AttendanceTable(
        details: details,
      ),
    );
  }

  const AttendanceTable({Key? key,required this.details}) : super(key: key);

  final ModuleAttendanceDetails details;



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var dimension = Dimensions(context: context);
    var columns = ['Ranking', 'Name', 'Score'];
    int total = details.attendance
        .map((attendee) => attendee.value)
        .reduce((value1, value2) => value1 + value2);
    List<List<String>> attendees=[];
    var rank=0;
    for(var i=0; i<details.attendance.length; i++){
      var student = ref.watch(fetchStudentInfoProvider(details.attendance[i].key));
      var name='';
      var reg='';
      student.when(
          data: (user) { name = user.name;reg=user.studentId;},
          error: (error, stack) => null,
          loading: () => null);
      final cells = [(i+1).toString(), name.toString(),reg,'${getScore(attendanceCount: details.attendance[i].value, overallAttendanceCount: total).round()}%'];
      attendees.add(cells);

    }
    return Scaffold(
      appBar: StudlyAppBar(
        title: 'Activity',
        icon: Iconsax.arrow_left_1,
        onPressed: () {
          Navigator.pop(context);
        },
        actions: [

          InkWell(
            onTap: () async {
              final pdfFile = await ModuleReportAPI.generate(
                  module:details.module,
                  attendees:attendees,
                  );
              PdfAPI.openFile(pdfFile);
            },
            child: Padding(
              padding: EdgeInsets.only(
                  right: dimension.horizontalPadding20,
                  left: dimension.horizontalPadding10,
                  top: dimension.verticalPadding10),
              child: Icon(
                Iconsax.export_1,
                color: StudlyColors.backgroundColorBlack,
                size: dimension.font24,
              ),
            ),
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(
            top: dimension.verticalPadding20,
            left: dimension.horizontalPadding20,
            right: dimension.horizontalPadding20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: StudlyTypography(
                  text: "Top Attendance",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              DataTable(
                columnSpacing: 60,
                columns: getColumns(columns),
                rows: getRows(
                    attendees: details.attendance,
                    ref: ref,
                    overallAttendanceCount: total),
                dividerThickness: 2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: StudlyColors.backgroundColorLightGray,
                ),
              ),
            ],
          ),
        ),
      ),
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

  List<DataRow> getRows(
          {required List<MapEntry<String, int>> attendees,
          required WidgetRef ref,
          required int overallAttendanceCount}) =>
      attendees.map((attendee) {
        var name = '';
        var student = ref.watch(fetchStudentInfoProvider(attendee.key));
        student.when(
            data: (user) => name = user.name,
            error: (error, stack) => null,
            loading: () => null);
        final cells = [
          (attendees.indexOf(attendee) + 1),
          name,
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



  double getScore(
          {required int attendanceCount,
          required int overallAttendanceCount}) =>
      (attendanceCount / overallAttendanceCount) * 100;
}
