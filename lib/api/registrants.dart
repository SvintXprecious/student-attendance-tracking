import 'dart:io';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:student_attendance/api/pdf_api.dart';
import 'package:student_attendance/state/registrations/model/registration.dart';

class RegistrantsAPI {
  static Future<File> generate({
    required Registration registration,
    required List<List<String>>  attendees,}) async {
    final pdf = pw.Document();

    pdf.addPage(pw.MultiPage(
      build: (context) => [
        buildHeader(registration),
        pw.SizedBox(height: 2 * PdfPageFormat.cm),
        buildInvoice(attendees),
        pw.Divider()
      ],
      footer: (context) => buildFooter(),
    ));

    return PdfAPI.saveDocument(name: '${registration.title} report.pdf', pdf: pdf);
  }

  static pw.Widget buildHeader(Registration registration) => pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.SizedBox(height: 1 * PdfPageFormat.cm),

      pw.SizedBox(height: 1 * PdfPageFormat.cm),
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        mainAxisAlignment: pw.MainAxisAlignment.start,
        children: [
          buildAssessmentInfo(registration),
          pw.SizedBox(height: 2 * PdfPageFormat.cm),
          buildAssessmentStats(registration),
        ],
      ),
    ],
  );



  static pw.Widget buildAssessmentInfo(Registration registration) {

    final Map<String,dynamic> data= {
      'Assessment ID:':registration.assessmentID,
      'Title:': registration.title,
      'Type:':registration.type,
      'module:':registration.module['name'].toString(),
      'lecturer:':registration.lecturer['name'].toString(),
      'Date:': DateFormat.yMMMMd().format(DateTime.parse(registration.date)).toString(),

    };

    return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,

        children:[
          for(var entry in data.entries)
            buildText(title: entry.key, value: entry.value, width: 300),

        ]
    );
  }

  static pw.Widget buildAssessmentStats(Registration registration) {

    final Map<String,dynamic> data= {
      'Students Registered:':registration.attendees.length.toString(),
      'Programs:': registration.programCodes.length.toString(),

    };

    return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,

        children:[
          for(var entry in data.entries)
            buildText(title: entry.key, value: entry.value.toString(), width: 300),

        ]
    );
  }




  static pw.Widget buildTitle() => pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [pw.Text(
      'Module Attendance',
      style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
    ),
      pw.SizedBox(height: 0.8 * PdfPageFormat.cm),
      pw.SizedBox(height: 0.8 * PdfPageFormat.cm),
    ],
  );

  static pw.Widget buildInvoice(List<List<String>> attendance ) {
    var headers = ['#', 'Student', 'Program'];



    return pw.Table.fromTextArray(
      headers: List<String>.generate(
        headers.length,
            (col) => headers[col],),
      data: List<List<String>>.generate(attendance.length,
            (row) => List<String>.generate(headers.length,
              (col) => attendance[row][col],
        ),
      ),
      border: null,
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft,

      },
    );
  }



  static pw.Widget buildFooter() => pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.center,
    children: [
      pw.Divider(),
      pw.SizedBox(height: 2 * PdfPageFormat.mm),
      buildSimpleText(title: 'Address', value: "P.O Box 5196, Limbe, Malawi."),
    ],
  );

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = pw.TextStyle(fontWeight: pw.FontWeight.bold);

    return pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Text(title, style: style),
        pw.SizedBox(width: 2 * PdfPageFormat.mm),
        pw.Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    pw.TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 16);

    return pw.Container(
      width: width,
      child: pw.Row(
        children: [
          pw.Expanded(child: pw.Text(title, style: style)),
          pw.Text(value, style: unite ? style :const pw.TextStyle(fontSize: 14),),
        ],
      ),
    );
  }
}


