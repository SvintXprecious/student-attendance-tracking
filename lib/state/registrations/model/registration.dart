import 'package:student_attendance/state/registrations/model/registration_key.dart';

class Registration {
  const Registration(
      {required this.assessmentID,
      required this.type,
      required this.module,
      required this.programCodes,
      required this.attendees,
      required this.date,
      required this.lecturer,
      required this.title});

  final String assessmentID;
  final String title;
  final Map<String, dynamic> lecturer;
  final String date;
  final List<dynamic> programCodes;
  final Map<String, dynamic> module;
  final List<dynamic> attendees;
  final String type;

  factory Registration.fromJson(Map<String, dynamic> json) {
    final assessmentID = json[RegistrationKey.assessmentID];
    final title = json[RegistrationKey.title];
    final lecturer = json[RegistrationKey.lecturer];
    final date = json[RegistrationKey.date];
    final module = json[RegistrationKey.module];
    final type = json[RegistrationKey.type];
    final attendees = json[RegistrationKey.attendees];
    final programCodes = json[RegistrationKey.programCode];

    return Registration(
        assessmentID: assessmentID,
        title: title,
        lecturer: lecturer,
        date: date,
        module: module,
        type: type,
        attendees: attendees,
        programCodes: programCodes);
  }
}
