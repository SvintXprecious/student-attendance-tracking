import 'package:flutter/material.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/presentation/lecturer/lesson/lesson_statistics/charts/pie_chart.dart';
import 'package:student_attendance/state/sessions/model/session.dart';

class ChartCarousel extends StatelessWidget {
  const ChartCarousel({Key? key,required this.session}) : super(key: key);
  final Session session;

  @override
  Widget build(BuildContext context) {
    var dimension=Dimensions(context: context);
    return Container(
      margin: EdgeInsets.only(
          left: dimension.horizontalPadding20,right: dimension.horizontalPadding20),
      child: GridView.count(childAspectRatio: 400/600,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        crossAxisCount: 2,
        children: [
          PieChartUI(session: session,),
        ],
      ),
    );
  }
}
