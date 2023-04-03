import 'dart:io';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:student_attendance/api/pdf_api.dart';
import 'package:student_attendance/state/sessions/model/session.dart';

class SessionReportAPI {
  static Future<File> generate({
    required Session session,
    required List<List<String>> attendees,
    required int enrolled,
    required int present}) async {
    final pdf = pw.Document();

    pdf.addPage(pw.MultiPage(
      build: (context) => [
        buildHeader(session,enrolled,present),
        pw.SizedBox(height: 2 * PdfPageFormat.cm),
        buildInvoice(attendees),
        pw.Divider()
      ],
      footer: (context) => buildFooter(),
    ));

    return PdfAPI.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  static pw.Widget buildHeader(Session session,int enrolled,int present) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(height: 1 * PdfPageFormat.cm),

          pw.SizedBox(height: 1 * PdfPageFormat.cm),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              buildSessionInfo(session),
              pw.SizedBox(height: 2 * PdfPageFormat.cm),
              buildSessionStats(enrolled,present),
            ],
          ),
        ],
      );



  static pw.Widget buildSessionInfo(Session session) {

    final Map<String,dynamic> data= {
      'Session:': session.title,
      'Session ID:': session.sessionID,
      'Date:': DateFormat.yMMMMd().format(DateTime.parse(session.date)),
      'Session time:': '${session.start} - ${session.end}',
      'Module:': session.module['name'],
      'Module Code:': session.module['code'],
      'Lecturer:': session.lecturer['name'],
    };

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,

      children:[
        for(var entry in data.entries)
          buildText(title: entry.key, value: entry.value, width: 300),

      ]
    );
  }

  static pw.Widget buildSessionStats(int enrolled,int present) {

    final Map<String,dynamic> data= {
      'Students Enrolled:': enrolled,
      'Present:': '$present (${Session.generateSessionPercentage(enrolled: enrolled, statistic: present).round()}%)',
      'Absent:': '${enrolled-present} (${Session.generateSessionPercentage(enrolled: enrolled, statistic: enrolled-present).round()}%)',

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
            'Session Attendance',
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 0.8 * PdfPageFormat.cm),
          pw.SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static pw.Widget buildInvoice(List<List<String>> attendees) {
    final headers = [
      'Name',
      'Reg',
      'Clock in',
      'Clock out',
      'Attendance'
    ];
    List<List<String>> students=[];
    for(var student in attendees){
      var clockIn= student[2].toString()=="--:--"? "--:--" :  DateFormat.Hm().format(DateTime.parse(student[2]));
      var clockOut=student[3].toString()=="--:--"? "--:--" :  DateFormat.Hm().format(DateTime.parse(student[3]));
      var data=[
        student[0],student[1],clockIn,clockOut,student[4]];
      students.add(data);
    }

    return pw.Table.fromTextArray(
      headers: List<String>.generate(
        headers.length,
          (col) => headers[col],),
      data: List<List<String>>.generate(students.length,
            (row) => List<String>.generate(headers.length,
              (col) => students[row][col],
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
        3: pw.Alignment.centerLeft,
        4: pw.Alignment.centerLeft,
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


