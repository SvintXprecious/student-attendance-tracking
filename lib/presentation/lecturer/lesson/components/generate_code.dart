import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/widgets/widgets.dart';

class QRCodeUI extends StatelessWidget {
  static const String routeName='/qrcode';

  static Route route({required String flag}){
    return MaterialPageRoute(
      settings:const RouteSettings(name: routeName),
      builder: (_) => QRCodeUI(flag: flag,),);
  }
  const QRCodeUI({Key? key,required this.flag}) : super(key: key);
  final String flag;

  @override
  Widget build(BuildContext context) {
    var dimension=Dimensions(context: context);
    return Scaffold(
      appBar: StudlyAppBar(
        title: 'QR code',
        icon: Iconsax.arrow_left_1,
        onPressed: (){Navigator.pop(context);},),
      body: Center(
        child: PrettyQr(
          data: flag,
          size: dimension.widthMaxInfinite,
          errorCorrectLevel: QrErrorCorrectLevel.M,
          typeNumber: null,
          roundEdges: true,
          elementColor: StudlyColors.backgroundColorBlueAccent,

        ),
      ),
    );
  }
}
