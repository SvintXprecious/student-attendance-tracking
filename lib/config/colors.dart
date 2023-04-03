import 'package:flutter/material.dart';

abstract class ColorTheme{
  static const Color _black=Color(0xFF000000);
  static const Color _white=Color(0xFFFFFFFF);
  static const Color _aqua=Color(0xFF00FFFF);
  static const Color _blue=Color(0xFF0000FF);
  static const Color _magenta=Color(0xFFFF00FF);
  static const Color _grey=Color(0xFF9E9E9E);
  static const Color _lightGray=Color(0xFFE6E8F0);
  static const Color _green=Color(0xFF9BC53D);
  static const Color _red=Color(0xFFC3423F);
  static const Color _slate=Color(0xFF697089);
  static const Color _yellow=Color(0xFFFFFF00);

  //211A1E

}

class StudlyColors extends ColorTheme{


  static const backgroundColor= ColorTheme._white;
  static const backgroundColorBlack= ColorTheme._black;
  static const backgroundColorLightGray= ColorTheme._lightGray;
  static const backgroundColorGrey= ColorTheme._grey;
  static const backgroundColorBlueAccent= ColorTheme._blue;
  //static const backgroundColorLightBlueAccent= ColorTheme._lightBlueAccent;
  static const backgroundColorMagenta= ColorTheme._magenta;
  static const backgroundColorAqua=ColorTheme._aqua;
  static const backgroundColorYellow=ColorTheme._yellow;
  static const backgroundColorSlate= ColorTheme._slate;

  static const typographyDefaultColor=ColorTheme._black;
  static const typographyRed=ColorTheme._red;
  static const typographyWhite=ColorTheme._white;
  static const typographyGrey=ColorTheme._grey;
  static const typographyGreen=ColorTheme._green;


  static const iconColorGrey= ColorTheme._grey;
  static const iconColorBlack= ColorTheme._black;
  static const iconColorWhite= ColorTheme._white;


  static const  borderColorBlack = ColorTheme._black;
  static const  borderColorGrey = ColorTheme._grey;
  static const  borderColorRed = ColorTheme._red;
  static const  borderColorBlueAccent = ColorTheme._blue;

  static const classCardBackgroundGreen=ColorTheme._green;



  static const statsCardBackgroundGreen=ColorTheme._green;
  static const statsCardBackgroundRed=ColorTheme._red;

}