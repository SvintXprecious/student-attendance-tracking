import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:student_attendance/api/pdf_api.dart';
import 'package:student_attendance/api/pdf_invoice_api.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/config/utils.dart';
import 'package:student_attendance/presentation/lecturer/lesson/components/students_carousel.dart';
import 'package:student_attendance/state/providers/session_attendance_option_provider.dart';
import 'package:student_attendance/state/sessions/model/session.dart';
import 'package:student_attendance/state/sessions/providers/fetch_session_provider.dart';
import 'package:student_attendance/state/users/providers/fetch_students_info.dart';
import 'package:student_attendance/widgets/widgets.dart';

class PieChartAttendanceRateBody extends ConsumerStatefulWidget {
  const PieChartAttendanceRateBody({Key? key, required this.session})
      : super(key: key);
  final Session session;

  @override
  ConsumerState<PieChartAttendanceRateBody> createState() =>
      _PieChartAttendanceRateBodyState();
}

class _PieChartAttendanceRateBodyState extends ConsumerState<PieChartAttendanceRateBody> {
  int touchedIndex = -1;
  var enrolled=0;
  var present=0;
  List<List<String>> attendees=[];

  @override
  Widget build(BuildContext context) {
    var dimension = Dimensions(context: context);
    var option = ref.watch(sessionAttendanceOptionProvider);
    var columns=['Students','Clock in','Clock out'];
    //var modulesEnrollment=ref.watch(fetchModuleEnrollmentProvider(widget.session.programCode[0]));
    var attendance = ref.watch(fetchSessionProvider(widget.session.sessionID));
    attendance.whenData((attendees) {
      enrolled=attendees.attendees.length;
      present=Session.checkPresent(attendees.attendees);
    });


    //var sessionAttendance = ref.watch(fetchSessionAttendance(widget.session.module['code']));
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: (){
          ref.refresh(fetchSessionProvider(widget.session.module['code']));
          return Future.delayed(const Duration(seconds: 1));
        },

        child: Container(
          height: 800,
          child: Stack(
            children: [
              Positioned(
                  child: Container(
                      height: 400,
                      width: double.maxFinite,
                      color: StudlyColors.backgroundColorSlate)),
              Positioned(
                  top: 10,
                  left: 20,
                  right: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Iconsax.arrow_left_1,
                            color: StudlyColors.iconColorWhite,
                          )),
                      StudlyTypography(
                        text: "Session Attendance Rate",
                        color: StudlyColors.typographyWhite,
                      ),
                      IconButton(
                          onPressed: () async {
                            final pdfFile = await SessionReportAPI.generate(
                                session:widget.session,
                                attendees:attendees,
                                enrolled: enrolled,
                                present: present);
                            PdfAPI.openFile(pdfFile);
                          },
                          icon: const Icon(
                            Iconsax.export_1,
                            color: StudlyColors.iconColorWhite,
                          )),
                    ],
                  )),
              Positioned(
                left: 0,
                right: 0,
                top: 30,
                child: AspectRatio(
                  aspectRatio: 1.3,
                  child: Flex(
                    direction:Axis.horizontal,
                    children: [Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: PieChart(
                          PieChartData(
                            pieTouchData: PieTouchData(
                              touchCallback:
                                  (FlTouchEvent event, pieTouchResponse) {
                                setState(() {
                                  if (!event.isInterestedForInteractions ||
                                      pieTouchResponse == null ||
                                      pieTouchResponse.touchedSection == null) {
                                    touchedIndex = -1;
                                    return;
                                  }
                                  touchedIndex = pieTouchResponse
                                      .touchedSection!.touchedSectionIndex;
                                });
                              },
                            ),
                            borderData: FlBorderData(
                              show: false,
                            ),
                            sectionsSpace: 0,
                            centerSpaceRadius: 40,
                            sections: showingSections(
                                present: Session.generateSessionPercentage(enrolled: enrolled, statistic: present),
                                absent: Session.generateSessionPercentage(enrolled: enrolled, statistic:enrolled-present)),
                          ),
                        ),
                      ),
                    ),]
                  ),
                ),
              ),
              Positioned(
                top: 300,
                left: 120,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 14,width: 14,
                            decoration: BoxDecoration(
                              borderRadius:BorderRadius.circular(30),
                              color: StudlyColors.statsCardBackgroundGreen,),),
                          const SizedBox(width: 5,),
                          StudlyTypography(text: 'Present')
                        ],
                      ),
                      const SizedBox(width: 20,),
                      Row(
                        children: [
                          Container(
                            height: 14,width: 14,
                            decoration: BoxDecoration(
                              borderRadius:BorderRadius.circular(30),

                              color: StudlyColors.statsCardBackgroundRed,),),
                          const SizedBox(width: 5,),
                          StudlyTypography(text: 'Absent')
                        ],
                      ),
                    ]),
              ),
              Positioned(
                top: 360,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.only(left: 20,right: 20),
                  margin: const EdgeInsets.only(left: 20,right: 20),
                  height:80,
                  decoration: BoxDecoration(
                      color: StudlyColors.backgroundColorBlueAccent,
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          ref
                              .read(sessionAttendanceOptionProvider.notifier)
                              .onOptionSelected("Enrolled");
                        },
                        child: Container(
                          padding: const EdgeInsets.only(top: 10,bottom: 10),
                          child:  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(Iconsax.health,color: StudlyColors.typographyWhite,),
                                const SizedBox(width: 10,),
                                StudlyTypography(text: "Enrolled",fontSize: dimension.font13,color: StudlyColors.typographyWhite,),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            StudlyTypography(text: enrolled.toString(),color: StudlyColors.typographyWhite,)
                          ],
                        ),
                        ),
                      ),
                      const VerticalDivider(
                        color: StudlyColors.backgroundColorSlate,
                        thickness: 2,indent: 10,endIndent: 10,
                      ),
                      InkWell(
                        onTap: () {
                          ref
                              .read(sessionAttendanceOptionProvider.notifier)
                              .onOptionSelected("Present");
                        },
                        child: Container(
                          padding: const EdgeInsets.only(top: 10,bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Iconsax.trend_up,color: StudlyColors.typographyWhite,),
                                  const SizedBox(width: 10,),
                                  StudlyTypography(text: "Present",fontSize: dimension.font13,color: StudlyColors.typographyWhite,),
                                ],
                              ),
                              const SizedBox(height: 10,),
                              StudlyTypography(text: present.toString(),color: StudlyColors.typographyWhite,)
                            ],
                          ),
                        ),
                      ),
                      const VerticalDivider(
                        color: StudlyColors.backgroundColorSlate,
                        thickness: 2,indent: 10,endIndent: 10,
                      ),
                      InkWell(
                        onTap: () {
                          ref.read(sessionAttendanceOptionProvider.notifier)
                              .onOptionSelected("Absent");
                        },
                        child: Container(
                          padding: const EdgeInsets.only(top: 10,bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Iconsax.trend_down,color: StudlyColors.typographyWhite,),
                                  const SizedBox(width: 10,),
                                  StudlyTypography(text: "Absent",fontSize: dimension.font13,color: StudlyColors.typographyWhite,),
                                ],
                              ),
                              const SizedBox(height: 10,),
                              StudlyTypography(text: (enrolled-present).toString(),color: StudlyColors.typographyWhite,)
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                  bottom: 0,
                  top: 450,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.only(
                      top: dimension.verticalPadding20,

                    ),
                    child: Column(
                      children: [


                        const Divider(color: StudlyColors.iconColorGrey,),
                        Container(
                          child: attendance.when(
                              data: (attendance) {
                                attendees=generateAttendeeInfo(attendance.attendees, ref);
                                if(option=="Present"){
                                  return DataTable(
                                    columnSpacing: 50,
                                    columns: getColumns(columns),
                                    rows: getRows(
                                        attendees:attendance
                                            .attendees
                                            .where((attendee) => attendee['clock_in'].toString().isNotEmpty && attendee['clock_out'].toString().isNotEmpty)
                                            .toList(),
                                        ref: ref,
                                        overallAttendanceCount: 0),
                                    dividerThickness: 2,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: StudlyColors.backgroundColorLightGray,
                                    ),
                                  );


                                }
                                else if(option =="Absent"){
                                  return DataTable(
                                    columnSpacing: 50,
                                    columns: getColumns(columns),
                                    rows: getRows(
                                        attendees: attendance
                                            .attendees
                                            .where((attendee) => attendee['clock_in'].toString().isEmpty || attendee['clock_out'].toString().isEmpty)
                                            .toList(),
                                        ref: ref,
                                        overallAttendanceCount: 0),
                                    dividerThickness: 2,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: StudlyColors.backgroundColorLightGray,
                                    ),
                                  );

                                }

                                else if (option=="Enrolled"){
                                  return DataTable(
                                    columnSpacing: 50,
                                    columns: getColumns(columns),
                                    rows: getRows(
                                        attendees:  attendance.attendees,
                                        ref: ref,
                                        overallAttendanceCount: 0),
                                    dividerThickness: 2,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: StudlyColors.backgroundColorLightGray,
                                    ),
                                  );

                                }
                                else{
                                  return null;
                                }

                              },
                              error: (error, stack) => Container(),
                              loading: () => Container()),
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections({required double present,required double absent}) {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: StudlyColors.statsCardBackgroundGreen,
            value:present,
            title: '${present.round()}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
          );
        case 1:
          return PieChartSectionData(
            color: StudlyColors.statsCardBackgroundRed,
            value: absent,
            title: '${absent.round()}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
          );

        default:
          throw Error();
      }
    });
  }
}

List<List<String>> generateAttendeeInfo(List<Map<String,dynamic>> attendees,WidgetRef ref){
  List<List<String>> attendance=[];
  for(var attendee in attendees){
    var student=ref.watch(fetchStudentInfoProvider(attendee['uid']));
    student.when(data:
        (data) => attendance.add([
          data.name,
          data.studentId,

          attendee['clock_in'].toString().isEmpty? '--:--' : attendee['clock_in'].toString(),
          attendee['clock_out'].toString().isEmpty? '--:--' : attendee['clock_out'].toString(),
          attendee['clock_in'].toString().isNotEmpty && attendee['clock_out'].toString().isNotEmpty ? 'Present' : 'Absent'
        ]),
        error: (error,stack) => null,
        loading: () => null);



  }
  return attendance;




}

List<DataColumn> getColumns(List<String> columns) {
  return columns.map((String column) {
    final isRank = column == columns[0];

    return DataColumn(
      label: Text(column),
    );
  }).toList();
}

List<DataRow> getRows({required List<Map<String,dynamic>> attendees,
  required WidgetRef ref,
  required int overallAttendanceCount}) =>
    attendees.map((attendee) {
      var name = '';
      var reg='';
      var photo='';
      var student = ref.watch(fetchStudentInfoProvider(attendee['uid']));
      student.when(
          data: (user) { name = user.name;reg=user.studentId;},
          error: (error, stack) => null,
          loading: () => null);
      final cells = [
        '$name\n$reg',
        attendee['clock_in'].toString().isEmpty? "--:--" :  DateFormat.Hm().format(DateTime.parse(attendee['clock_in'])),
        attendee['clock_out'].toString().isEmpty? "--:--" : DateFormat.Hm().format(DateTime.parse(attendee['clock_out']))];

      return DataRow(
        cells: Utils.modelBuilder(cells, (index, cell) {
          return DataCell(
            Text('$cell'),
          );
        }),
      );
    }).toList();