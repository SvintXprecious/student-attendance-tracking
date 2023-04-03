import 'package:flutter/material.dart';
import 'package:student_attendance/presentation/Pofile/profile_information.dart';
import 'package:student_attendance/presentation/Pofile/profile_ui.dart';
import 'package:student_attendance/presentation/class/class_main.dart';
import 'package:student_attendance/presentation/class/classes.dart';
import 'package:student_attendance/presentation/home/home.dart';
import 'package:student_attendance/presentation/lecturer/home/studly+_home.dart';
import 'package:student_attendance/presentation/lecturer/lesson/components/generate_code.dart';
import 'package:student_attendance/presentation/lecturer/lesson/lesson_planner.dart';
import 'package:student_attendance/presentation/lecturer/lesson/lesson_statistics/charts/pie_chart.dart';
import 'package:student_attendance/presentation/lecturer/lesson/lesson_statistics/pie_chart_attendance_ui.dart';
import 'package:student_attendance/presentation/lecturer/lesson/session_attendance_ui.dart';
import 'package:student_attendance/presentation/lecturer/lesson/session_details.dart';
import 'package:student_attendance/presentation/lecturer/lesson/timetable_ui.dart';
import 'package:student_attendance/presentation/lecturer/module/dashboard/charts/attendance_table.dart';
import 'package:student_attendance/presentation/lecturer/module/dashboard/charts/average_attendance_barprogress.dart';
import 'package:student_attendance/presentation/lecturer/module/dashboard/minimal/average_attendance_progress.dart';
import 'package:student_attendance/presentation/lecturer/module/dashboard/minimal/top_attendance_table.dart';
import 'package:student_attendance/presentation/lecturer/module/edit_module.dart';
import 'package:student_attendance/presentation/lecturer/module/module_attendance_ui.dart';
import 'package:student_attendance/presentation/lecturer/module/module_home.dart';
import 'package:student_attendance/presentation/lecturer/module/module_planner.dart';
import 'package:student_attendance/presentation/lecturer/registration/components/assessment_formfields.dart';
import 'package:student_attendance/presentation/lecturer/registration/components/student_card_scanner.dart';
import 'package:student_attendance/presentation/lecturer/registration/dashboard.dart';
import 'package:student_attendance/presentation/lecturer/registration/registration.dart';
import 'package:student_attendance/presentation/module/student_module_ui.dart';
import 'package:student_attendance/state/module/model/module.dart';
import 'package:student_attendance/state/registrations/model/registration.dart';
import 'package:student_attendance/state/sessions/model/session.dart';
import 'package:student_attendance/state/users/models/user.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return Home.route();

      case Home.routeName:
        return Home.route();

      case ProfileUI.routeName:
        return ProfileUI.route();

      case ProfileInformation.routeName:
        return ProfileInformation.route(user: settings.arguments as User);

      case LessonsUI.routeName:
        return LessonsUI.route();

      case ClassUI.routeName:
        return ClassUI.route(session: settings.arguments as Session);

      case ModuleUI.routeName:
        return ModuleUI.route();

      case ModuleHome.routeName:
        return ModuleHome.route();

      case ModulePlannerUI.routeName:
        return ModulePlannerUI.route();

      case ModulePlannerEditor.routeName:
        return ModulePlannerEditor.route(module: settings.arguments as Module);

      case LessonPlannerUI.routeName:
        return LessonPlannerUI.route();

      case TimetableUI.routeName:
        return TimetableUI.route();

      case QRCodeUI.routeName:
        return QRCodeUI.route(flag: settings.arguments as String);

      case SessionDetails.routeName:
        return SessionDetails.route(session: settings.arguments as Session);

      case SessionAttendanceUI.routeName:
        return SessionAttendanceUI.route(
            session: settings.arguments as Session);

      case PieChartAttendanceRateUI.routeName:
        return PieChartAttendanceRateUI.route(
            session: settings.arguments as Session);

      case ModuleAttendanceUI.routeName:
        return ModuleAttendanceUI.route(module: settings.arguments as Module);

      case StudlyPlusHomeUI.routeName:
        return StudlyPlusHomeUI.route();

      case PieChartUI.routeName:
        return PieChartUI.route(session: settings.arguments as Session);

      case AttendanceTable.routeName:
        return AttendanceTable.route(
            details: settings.arguments as ModuleAttendanceDetails);

      case AverageAttendanceProgress.routeName:
        return AverageAttendanceProgress.route(
            attendance: settings.arguments as AttendancePayload);

      case StudentCardScanner.routeName:
        return StudentCardScanner.route(
            assessment: settings.arguments as Registration);


      case RegistrationUI.routeName:
        return RegistrationUI.route();

      case AssessmentFormFields.routeName:
        return AssessmentFormFields.route();

      case DashboardUI.routeName:
        return DashboardUI.route(
            assessment: settings.arguments as Registration);

      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/error'),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text("error"),
        ),
        body: const Center(child: Text("something went wrong")),
      ),
    );
  }
}
