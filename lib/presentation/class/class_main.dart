import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/presentation/class/class_details.dart';
import 'package:student_attendance/presentation/class/components/bottom_sheet.dart';
import 'package:student_attendance/state/auth/providers/auth_state_provider.dart';
import 'package:student_attendance/state/sessions/model/session.dart';
import 'package:student_attendance/state/sessions/providers/fetch_session_by_id_provider.dart';
import 'package:student_attendance/state/users/providers/user_info_model_provider.dart';
import 'package:student_attendance/widgets/widgets.dart';

class ClassUI extends ConsumerStatefulWidget {
  static const String routeName = '/Class';

  static Route route({required Session session}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => ClassUI(
        session: session,
      ),
    );
  }

  const ClassUI({Key? key, required this.session}) : super(key: key);
  final Session session;

  @override
  ConsumerState<ClassUI> createState() => _ClassUIRState();
}

class _ClassUIRState extends ConsumerState<ClassUI> {
  var current = TimeOfDay.now();
  List<Map<String, dynamic>> attendees = [];
  var index = 1;
  var checkedIn = false;
  var checkedOut = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final start = extractTime(widget.session.start);
    final end = extractTime(widget.session.end);
    var now = extractTime(
        localizations.formatTimeOfDay(current, alwaysUse24HourFormat: true));
    final user = ref.watch(userInfoModelProvider(authStateProvider));
    final attendance =
        ref.watch(fetchSessionByIDProvider(widget.session.sessionID));
    final uid = ref.watch(authStateProvider);

    return Scaffold(
        body: ClassDetails(
            session: widget.session, index: index, checkedIn: checkedIn),
        bottomNavigationBar: RefreshIndicator(
          onRefresh: () {
            ref.refresh(userInfoModelProvider(authStateProvider));
            ref.refresh(fetchSessionByIDProvider(widget.session.sessionID));
            return Future.delayed(const Duration(seconds: 1));
          },
          child: Container(
            child: user.when(
                data: (student) {
                  return Container(
                    child: attendance.when(
                        data: (attendance) {
                          for (var i = 0;
                              i < attendance.attendees.length;
                              i++) {
                            if (attendance.attendees[i]
                                .containsValue(uid.userId)) {
                              attendance.attendees[i]['clock_in']
                                      .toString()
                                      .isEmpty
                                  ? checkedIn = checkedIn
                                  : checkedIn = !checkedIn;
                              attendance.attendees[i]['clock_out']
                                      .toString()
                                      .isEmpty
                                  ? checkedOut = checkedOut
                                  : checkedOut = !checkedOut;
                              index = i;
                              break;
                            }
                          }
                          return StudlyButton(
                            label: checkedIn == true ? "Clock out" : "Clock in",
                            onPressed: start <= now &&
                                    now <= end &&
                                    checkedOut == false
                                ? () {
                                    showModalBottomSheet(
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(40))),
                                        backgroundColor:
                                            StudlyColors.backgroundColor,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ModalBottomSheet(
                                            session: widget.session,
                                            index: index,
                                            checkedIn: checkedIn,
                                          );
                                        });
                                  }
                                : null,
                          );
                        },
                        error: (error, stack) => Container(),
                        loading: () => Container()),
                  );
                },
                error: (error, stack) => Container(),
                loading: () => Container()),
          ),
        ));
  }

  int extractTime(String time) {
    int colonIndex = time.indexOf(":");
    int hour = int.parse(time.substring(0, colonIndex));
    int minute = int.parse(time.substring(colonIndex + 1));
    return hour * 60 + minute;
  }
}
