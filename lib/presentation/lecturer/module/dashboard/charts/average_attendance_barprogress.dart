import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:student_attendance/api/average_attendance_api.dart';
import 'package:student_attendance/api/pdf_api.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/config/utils.dart';
import 'package:student_attendance/presentation/lecturer/module/dashboard/minimal/average_attendance_progress.dart';
import 'package:student_attendance/widgets/widgets.dart';

class AverageAttendanceProgress extends ConsumerStatefulWidget {
  static const String routeName = '/averageAttendanceProgress';

  static Route route({required AttendancePayload attendance}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => AverageAttendanceProgress(
        attendance: attendance,
      ),
    );
  }

  const AverageAttendanceProgress({Key? key, required this.attendance})
      : super(key: key);
  final AttendancePayload attendance;

  @override
  ConsumerState<AverageAttendanceProgress> createState() =>
      _AverageAttendanceProgressMinimalState();
}

class _AverageAttendanceProgressMinimalState
    extends ConsumerState<AverageAttendanceProgress> {
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
    var columns = ['Session', 'Attendance', 'Rate/session'];
    var totalAttendance = widget.attendance.attendance
        .reduce((value, element) => value + element);
    var averageAttendance = (totalAttendance / widget.attendance.session) * 100;

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
              List<List<String>> rows = [];

              for (var attendees in widget.attendance.attendance) {
                final index = widget.attendance.attendance.indexOf(attendees);
                final cells = [
                  (index + 1).toString(),
                  attendees.toString(),
                  '${((attendees / widget.attendance.enrolled) * 100).round().toString()}%',
                ];
                rows.add(cells);
              }

              final pdfFile = await ModuleAverageAttendanceAPI.generate(
                module: widget.attendance.module,
                attendees: rows,
                sessions: widget.attendance.session,
                attendance: totalAttendance,
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
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: dimension.verticalPadding20),
            width: double.maxFinite,
            height: 400,
            padding: EdgeInsets.only(
                top: dimension.verticalPadding10,
                left: dimension.horizontalPadding10,
                right: dimension.horizontalPadding10),
            decoration: BoxDecoration(
                color: StudlyColors.backgroundColorLightGray,
                borderRadius: BorderRadius.circular(30)),
            child: Column(
              children: [
                Flexible(
                    child: StudlyTypography(
                  text: "Average Attendance Rate",
                  fontSize: dimension.font13,
                  maxLines: null,
                  textOverflow: TextOverflow.visible,
                )),
                SizedBox(
                  height: dimension.sizedBox40,
                ),
                CircularPercentIndicator(
                  radius: 120.0,
                  lineWidth: 10.0,
                  animation: true,
                  percent: totalAttendance / widget.attendance.session,
                  center: StudlyTypography(
                    text: "${averageAttendance.round()}%",
                  ),
                  backgroundColor: StudlyColors.backgroundColor,
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: StudlyColors.statsCardBackgroundGreen,
                ),
              ],
            ),
          ),
          SizedBox(
            height: dimension.verticalPadding20,
          ),
          DataTable(
            columnSpacing: 70,
            columns: getColumns(columns),
            rows: getRows(attendance: widget.attendance.attendance),
            dividerThickness: 2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: StudlyColors.backgroundColorLightGray,
            ),
          ),
        ],
      ),
    );
  }

  List<DataColumn> getColumns(List<String> columns) {
    return columns.map((String column) {
      return DataColumn(
        label: Text(column),
      );
    }).toList();
  }

  List<DataRow> getRows({required List<int> attendance}) =>
      attendance.map((attendees) {
        final cells = [(attendance.indexOf(attendees)+1).toString(), attendees.toString(),  '${((attendees / widget.attendance.enrolled) * 100).round().toString()}%',
        ];

        return DataRow(
          cells: Utils.modelBuilder(cells, (index, cell) {
            return DataCell(
              Text('$cell'),
            );
          }),
        );
      }).toList();
}
