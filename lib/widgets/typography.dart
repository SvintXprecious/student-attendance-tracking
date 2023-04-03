import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_attendance/config/config.dart';

class StudlyTypography extends StatelessWidget {
  StudlyTypography(
      {Key? key,
      required this.text,
      this.maxLines = 1,
      this.textOverflow = TextOverflow.ellipsis,
      this.color = StudlyColors.typographyDefaultColor,
      this.fontSize = 16,
      this.fontWeight = FontWeight.w500,
      this.height = 1.5})
      : super(key: key);

  final String text;
  int? maxLines;
  TextOverflow textOverflow;
  Color color;
  double fontSize;
  FontWeight fontWeight;
  double height;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: textOverflow,
      style: GoogleFonts.poppins(
        textStyle: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
          height: height,
        ),
      ),
    );
  }
}
