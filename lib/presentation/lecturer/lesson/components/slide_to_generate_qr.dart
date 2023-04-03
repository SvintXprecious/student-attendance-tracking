import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:student_attendance/config/config.dart';

class SlideToGenerateQRCode extends StatelessWidget {
  const SlideToGenerateQRCode({
    Key? key, required this.label,required this.flag}) : super(key: key);
  final String label;
  final String flag;


  @override
  Widget build(BuildContext context) {
    var dimension=Dimensions(context: context);


    return  SlideAction(
      onSubmit:(){Navigator.pushNamed(context, '/qrcode',arguments: flag);
      },
      borderRadius: 30,
      elevation: 0,
      animationDuration: const Duration(milliseconds: 100),
      height: dimension.containerHeight55,
      sliderButtonIcon: const Icon(Iconsax.barcode),
      sliderButtonIconSize: dimension.containerHeight18,
      sliderButtonIconPadding: dimension.containerHeight12,
      outerColor: StudlyColors.backgroundColorBlueAccent,
      text:label,textStyle: GoogleFonts.poppins(
      textStyle: TextStyle(
        color: StudlyColors.typographyWhite,
        fontSize:dimension.font14,
        fontWeight:FontWeight.w500 ,
        height:1.5,
      ),
    ),);

  }

}
