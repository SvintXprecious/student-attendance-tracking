import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/presentation/lecturer/lesson/components/slide_to_generate_qr.dart';
import 'package:student_attendance/widgets/widgets.dart';

@immutable
class LecturerModalBottomSheet extends StatelessWidget {
  const LecturerModalBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dimension = Dimensions(context: context);
    return Container(
      padding: EdgeInsets.only(
          left: dimension.horizontalPadding20,
          right: dimension.horizontalPadding20),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30))),
      height: 700,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: dimension.verticalPadding20),
            child: StudlyTypography(
              text: "Generate QR code",
              fontSize: dimension.font16,
            ),
          ),
          SizedBox(
            height: dimension.sizedBox10,
          ),
          StudlyTypography(
            text: 'Generate QR code for your lesson',
            maxLines: null,
            height: 2,
            color: StudlyColors.typographyGrey,
            textOverflow: TextOverflow.visible,
            fontSize: dimension.font13,
          ),
          Padding(
            padding: EdgeInsets.only(
                left: dimension.horizontalPadding10,
                top: dimension.verticalPadding10),
            child: Center(
              child: Lottie.asset('assets/lottie/QRcode.json',
                  height: 250, width: 250, fit: BoxFit.fill),
            ),
          ),
          SizedBox(
            height: dimension.verticalPadding20,
          ),
          const SlideToGenerateQRCode(
            label: 'Slide to generate clock in QR',
            flag: 'Clock in',
          ),
          SizedBox(
            height: dimension.verticalPadding20,
          ),
          const SlideToGenerateQRCode(
            label: 'Slide to generate clock out QR',
            flag: 'Clock out',
          ),
        ],
      ),
    );
  }
}
