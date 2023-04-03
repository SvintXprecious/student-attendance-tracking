import 'package:flutter/material.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/widgets/widgets.dart';

class PictureLabel extends StatelessWidget {
  const PictureLabel({
    Key? key,
    required this.imageUrl,
    required this.imageHeight,
    required this.imageWidth,
    required this.label,
    this.fontWeight=FontWeight.bold,
    this.labelColor=StudlyColors.typographyGrey,}) : super(key: key);


  final String imageUrl;
  final double imageHeight;
  final double imageWidth;
  final String label;
  final Color labelColor;
  final FontWeight fontWeight;



  @override
  Widget build(BuildContext context) {
    var dimension=Dimensions(context: context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              height: imageHeight,width: imageWidth,
              decoration: BoxDecoration(

                borderRadius: BorderRadius.circular(90),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                      image:NetworkImage(imageUrl),

                  )
              ),

            ),
            SizedBox(width: dimension.sizedBoxWidth10,),
            StudlyTypography(text: label,fontSize: dimension.font13,fontWeight: fontWeight,color: labelColor,),

          ],
        ),
        StudlyTypography(text: 'Lecturer',color: StudlyColors.typographyGrey,fontSize: dimension.font13,)
      ],
    );
  }
}
