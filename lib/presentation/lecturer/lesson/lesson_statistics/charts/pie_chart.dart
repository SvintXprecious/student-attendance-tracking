import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/state/sessions/model/session.dart';
import 'package:student_attendance/state/sessions/providers/fetch_session_provider.dart';
import 'package:student_attendance/widgets/widgets.dart';

class PieChartUI extends ConsumerStatefulWidget {
  static const String routeName='/barchart';

  static Route route({required Session session}){
    return MaterialPageRoute(
      settings:const RouteSettings(name: routeName),
      builder: (_) => PieChartUI(session: session,),);
  }

  const PieChartUI({Key? key, required this.session}) : super(key: key);
  final Session session;

  @override
  ConsumerState<PieChartUI> createState() => _PieChartUIState();
}

class _PieChartUIState extends ConsumerState<PieChartUI> {
  int touchedIndex = -1;
  var enrolled=0;
  var present=0;

  @override
  Widget build(BuildContext context) {
    var dimension = Dimensions(context: context);
    var attendance = ref.watch(fetchSessionProvider(widget.session.sessionID));

    return RefreshIndicator(
      onRefresh: (){
        ref.refresh(fetchSessionProvider(widget.session.sessionID));
        return Future.delayed(const Duration(seconds: 1));
      },

      child: InkWell(
        onTap: (){Navigator.pushNamed(context, '/sessionAttendanceRate',arguments: widget.session);},
        child: Container(
          padding: EdgeInsets.only(
              top: dimension.verticalPadding10,
              left: dimension.horizontalPadding10,
              right: dimension.horizontalPadding10),
          decoration: BoxDecoration(
              color: StudlyColors.backgroundColorLightGray,
              borderRadius: BorderRadius.circular(30)),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      child: StudlyTypography(text: "Attendance Rate",
                        fontSize:dimension.font13,
                        maxLines: null,
                        textOverflow: TextOverflow.visible,)),
                  Container(
                    height: 40,width: 40,
                    decoration: BoxDecoration(
                        color: StudlyColors.backgroundColorSlate,
                        borderRadius: BorderRadius.circular(30)),
                    child: const Icon(Iconsax.graph,color: StudlyColors.iconColorWhite,),)




              ],),
              SizedBox(height: dimension.verticalPadding30,),
              attendance.when(data: (attendees){
                enrolled=attendees.attendees.length;
                present=Session.checkPresent(attendees.attendees);
                if(attendees.attendees.isEmpty){
                  return Container();
                }
                else{
                  return AspectRatio(
                  aspectRatio: 1.3,
                  child: Flex(
                    direction: Axis.vertical,
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
                            centerSpaceRadius: 30,
                            sections: showingSections(
                              dimension: dimension,
                                present: Session.generateSessionPercentage(enrolled: enrolled, statistic: present),
                                absent: Session.generateSessionPercentage(enrolled: enrolled, statistic:enrolled-present)),
                          ),
                        ),
                      ),
                    ),]
                  ),
                );}

              }, error: (error,stack) => Container(), loading: () => Container())

            ],
          ),


          ),
      ),
      );
  }

  List<PieChartSectionData> showingSections({required double present,required double absent,required Dimensions dimension}) {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? dimension.font16 : dimension.font13;
      final radius = isTouched ? 40.0 : 30.0;
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
