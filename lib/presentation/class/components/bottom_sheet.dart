import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/presentation/class/components/slide_to_action.dart';
import 'package:student_attendance/state/sessions/model/session.dart';
import 'package:student_attendance/widgets/widgets.dart';

@immutable
class ModalBottomSheet extends StatelessWidget {
  const ModalBottomSheet({Key? key, required this.session,required this.index,required this.checkedIn}) : super(key: key);
  final Session session;
  final int index;
  final bool checkedIn;

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
              text: checkedIn==true? "Scan QR code to check out" : "Scan QR code to check in" ,
              fontSize: dimension.font19,
            ),
          ),
          SizedBox(
            height: dimension.sizedBox10,
          ),
          StudlyTypography(
            text:
                'Hold the code inside the frame to check in for your ${session.title} class. The code will be scanned automatically.',
            maxLines: null,
            height: 2,
            color: StudlyColors.typographyGrey,
            textOverflow: TextOverflow.visible,
            fontSize: dimension.font14,
          ),
          Padding(
            padding: EdgeInsets.only(left: dimension.horizontalPadding10),
            child: Lottie.asset('assets/lottie/qr_code.json',
                height: 290, width: 290, fit: BoxFit.fill),
          ),
          SlideToScanQR(
            session: session,
            index:index
          )
        ],
      ),
    );
  }
}
