import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:student_attendance/api/pdf_api.dart';
import 'package:student_attendance/api/registrants.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/config/utils.dart';
import 'package:student_attendance/state/registrations/model/registration.dart';
import 'package:student_attendance/state/registrations/providers/fetch_assessment.dart';
import 'package:student_attendance/state/registrations/providers/fetch_student_info.dart';
import 'package:student_attendance/widgets/widgets.dart';

class RegistrationTable extends ConsumerWidget {
  static const String routeName = '/attendancetable';

  static Route route({required Registration assessment}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => RegistrationTable(
        assessment: assessment,
      ),
    );
  }

  const RegistrationTable({Key? key, required this.assessment})
      : super(key: key);
  final Registration assessment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var dimension = Dimensions(context: context);
    var columns = ['#', 'Student', 'Program'];
    List<List<String>> reg = [];
    var currentAssessment =
        ref.watch(fetchAssessmentProvider(assessment.assessmentID));
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: dimension.verticalPadding10),
              child: StudlyTypography(
                text: "Registrants",
              ),
            ),
            IconButton(
              onPressed: () async {
                final pdfFile = await RegistrantsAPI.generate(
                    registration: assessment, attendees: reg);
                PdfAPI.openFile(pdfFile);
              },
              icon: Icon(Iconsax.document_download),
              color: StudlyColors.backgroundColorBlack,
            )
          ],
        ),
        Container(
          child: currentAssessment.when(
              data: (assessment) {
                return DataTable(
                  columnSpacing: 100,
                  columns: getColumns(columns),
                  rows: getRows(
                      students: assessment.attendees, ref: ref, reg: reg),
                  dividerThickness: 2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: StudlyColors.backgroundColorLightGray,
                  ),
                );
              },
              error: (error, stack) => null,
              loading: () => null),
        ),
      ],
    );
  }

  List<DataColumn> getColumns(List<String> columns) {
    return columns.map((String column) {
      final isRank = column == columns[0];

      return DataColumn(
        label: Text(column),
      );
    }).toList();
  }

  List<DataRow> getRows(
          {required List<dynamic> students,
          required WidgetRef ref,
          required List<List<String>> reg}) =>
      students.map((student) {
        var name = '';
        var code = '';
        String id = student.replaceAll('/', '-');
        var user = ref.watch(fetchStudentAssessmentInfoProvider(id.trim()));
        user.when(
            data: (user) {
              name = user.name;
              code = user.code;
            },
            error: (error, stack) => null,
            loading: () => null);

        final cells = [(students.indexOf(student) + 1).toString(), name, code];
        reg.add(cells);

        return DataRow(
          cells: Utils.modelBuilder(cells, (index, cell) {
            return DataCell(
              Text('$cell'),
            );
          }),
        );
      }).toList();
}
