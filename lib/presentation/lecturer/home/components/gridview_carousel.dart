import 'package:flutter/material.dart';
import 'package:student_attendance/presentation/lecturer/home/components/menu_card.dart';

class GridViewCarousel extends StatelessWidget {

  const GridViewCarousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> homeOptions=['Modules','Timetable'];

    return GridView.builder(
      itemCount: homeOptions.length,
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 5,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (BuildContext context,int index) => MenuCard(option: homeOptions.elementAt(index),),);
  }
}
