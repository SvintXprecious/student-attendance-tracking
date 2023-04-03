import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/widgets/typography.dart';

class StudlyInputField extends StatelessWidget {
  StudlyInputField({
    Key? key,
    required this.title,
    required this.controller,
    this.cursorColor=StudlyColors.typographyDefaultColor,
    this.textInputAction=TextInputAction.next,
    this.textCapitalization=TextCapitalization.sentences,
    this.maxLines=1,
    this.fillColor=StudlyColors.backgroundColorLightGray,
    this.borderRadius=20,
    this.focusedBorderRadius=50,
    this.hintText,
    this.lineHeight=1.5,
    this.readOnly=false,
    this.contentPadding=const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
    this.focusedBorderSide=StudlyColors.backgroundColorBlueAccent,
    this.widget,
    this.expands=false,}) : super(key: key);

  final TextEditingController controller;
  final String title;
  final Color cursorColor;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final int? maxLines;
  final double lineHeight;
  final bool expands;
  final Color fillColor;
  final double borderRadius;
  final double focusedBorderRadius;
  final Color focusedBorderSide;
  final String? hintText;
  final EdgeInsetsGeometry contentPadding;
  final bool readOnly;
  Widget? widget;


  @override
  Widget build(BuildContext context) {
    var dimension=Dimensions(context: context);
    return Container(
      padding: EdgeInsets.only(top: dimension.verticalPadding30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: dimension.horizontalPadding6),
            child: StudlyTypography(text: title,fontSize: dimension.font14,),
          ),
          SizedBox(height:dimension.sizedBox10),
          TextFormField(
            controller: controller,
            readOnly: readOnly,
            autofocus: false,
            expands:expands ,
            cursorColor:  cursorColor,
            textInputAction:textInputAction,
            textCapitalization:textCapitalization,
            maxLines: maxLines,
            decoration: InputDecoration(
              filled: true,
              fillColor: fillColor,
              suffixIcon: widget,
              suffixIconColor: StudlyColors.iconColorGrey,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide.none,),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: focusedBorderSide),
              ),
              hintText: hintText,
              hintStyle: GoogleFonts.poppins(
                textStyle: TextStyle(
                  height: lineHeight,
                  color: StudlyColors.typographyGrey,
                  fontSize: dimension.font10,
                ),
              ),
              contentPadding: contentPadding,
            ),
          ),
        ],
      ),
    );
  }
}
