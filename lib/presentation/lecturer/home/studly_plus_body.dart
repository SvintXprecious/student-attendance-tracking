import 'package:flutter/material.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/presentation/lecturer/home/components/gridview_carousel.dart';

class StudlyPlusBody extends StatelessWidget {
  const StudlyPlusBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dimension=Dimensions(context: context);
    return Container(
      margin: EdgeInsets.only(top: dimension.verticalPadding40,
          left: dimension.horizontalPadding20,
          right: dimension.horizontalPadding20),
      child:const GridViewCarousel(),
      
    );
  }
}
