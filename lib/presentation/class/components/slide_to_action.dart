import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/state/sessions/model/session.dart';
import 'package:student_attendance/state/sessions/notifier/sessions.dart';

class SlideToScanQR extends ConsumerStatefulWidget {
  const SlideToScanQR({Key? key, required this.session, required this.index})
      : super(key: key);
  final Session session;
  final int index;

  @override
  ConsumerState<SlideToScanQR> createState() => _SlideToScanQRState();
}

class _SlideToScanQRState extends ConsumerState<SlideToScanQR> {
  String _scanBarcode = 'Unknown';

  @override
  void initState() {
    super.initState();
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#0000FF', 'Cancel', true, ScanMode.QR);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    setState(() {
      _scanBarcode = barcodeScanRes;
    });

    var isCheckedIn =
        widget.session.attendees[widget.index]['clock_in'].toString().isEmpty;
    var isCheckedOut =
        widget.session.attendees[widget.index]['clock_out'].toString().isEmpty;

    if (_scanBarcode == 'clock in' && isCheckedIn) {
      await ref.read(sessionsProvider.notifier).addClockIn(
          sessionID: widget.session.sessionID,
          studentIndex: widget.index,
          attendees: widget.session.attendees);
    } else if (_scanBarcode == 'clock out' && isCheckedOut) {
      await ref.read(sessionsProvider.notifier).addClockOut(
          sessionID: widget.session.sessionID,
          studentIndex: widget.index,
          attendees: widget.session.attendees);
    }
  }

  @override
  Widget build(BuildContext context) {
    var dimension = Dimensions(context: context);

    return SlideAction(
      onSubmit: () {
        scanQR();
      },
      borderRadius: 30,
      elevation: 0,
      animationDuration: const Duration(milliseconds: 100),
      height: dimension.containerHeight55,
      sliderButtonIcon: const Icon(Iconsax.scan),
      sliderButtonIconSize: dimension.containerHeight18,
      sliderButtonIconPadding: dimension.containerHeight12,
      outerColor: StudlyColors.backgroundColorBlueAccent,
      text: 'Slide to scan',
      textStyle: GoogleFonts.poppins(
        textStyle: TextStyle(
          color: StudlyColors.typographyWhite,
          fontSize: dimension.font17,
          fontWeight: FontWeight.w500,
          height: 1.5,
        ),
      ),
    );
  }
}
