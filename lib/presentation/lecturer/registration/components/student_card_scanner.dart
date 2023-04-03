import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/state/registrations/model/registration.dart';
import 'package:student_attendance/state/registrations/notifier/registrations.dart';

class StudentCardScanner extends ConsumerStatefulWidget {
  static const String routeName = '/cardscanner';

  static Route route({required Registration assessment}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => StudentCardScanner(assessment: assessment,),
    );
  }
  const StudentCardScanner({Key? key,required this.assessment})
      : super(key: key);

  final Registration assessment;

  @override
  ConsumerState<StudentCardScanner> createState() => _SlideToScanQRState();
}

class _SlideToScanQRState extends ConsumerState<StudentCardScanner> {
  String _scanBarcode = 'Unknown';
  var students=<String>[];


  @override
  void initState() {
    super.initState();
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#0000FF', 'Cancel', true, ScanMode.BARCODE);
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
    
    for(var student in widget.assessment.attendees){
      students.add(student.toString().trim());
    }

    if (!(students.contains(_scanBarcode.trim())) && _scanBarcode!='-1') {
      students.add(_scanBarcode.trim());
      await ref.read(registrationsProvider.notifier).addStudent(
          assessmentID: widget.assessment.assessmentID, attendees: students);
    }
    Navigator.pop(context);



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
      text: 'Slide to scan ',
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
