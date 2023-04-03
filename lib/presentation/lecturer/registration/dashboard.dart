import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/presentation/lecturer/registration/components/overview_section.dart';
import 'package:student_attendance/presentation/lecturer/registration/components/registration_table.dart';
import 'package:student_attendance/state/notifiers/registrants.dart';
import 'package:student_attendance/state/registrations/model/registration.dart';
import 'package:student_attendance/state/registrations/providers/fetch_assessment.dart';
import 'package:student_attendance/widgets/widgets.dart';



class DashboardUI extends ConsumerWidget {
  static const String routeName = '/dashboard';

  static Route route({required Registration assessment}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => DashboardUI(
        assessment: assessment,
      ),
    );
  }

  const DashboardUI({Key? key, required this.assessment}) : super(key: key);
  final Registration assessment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var dimension = Dimensions(context: context);
    var assessmentProvider = ref.watch(fetchAssessmentProvider(assessment.assessmentID));
    var registrants=ref.watch(registrantsProvider);
    return Scaffold(
      appBar: StudlyAppBar(
        title: 'Dashboard',
        icon: Iconsax.arrow_left_1,
        onPressed: () {
          Navigator.pop(context);
        },
        actions: [
          Padding(
            padding: EdgeInsets.only(
                right: dimension.horizontalPadding10,
                top: dimension.verticalPadding10),
            child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/cardscanner',
                      arguments: assessment);
                },
                icon: const Icon(
                  Iconsax.check,
                  color: StudlyColors.backgroundColorBlack,
                )),
          )
        ],
      ),
      body: assessmentProvider.when(
          data: (assessment) {
            return Container(
              margin: EdgeInsets.only(
                  left: dimension.horizontalPadding20,
                  right: dimension.horizontalPadding20,
                  top: dimension.verticalPadding20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //Text(registrants.toString()),
                    OverViewSection(
                      registered: assessment.attendees.length,
                      programs: assessment.programCodes.length,
                    ),
                    SizedBox(
                      height: dimension.verticalPadding20,
                    ),
                    RegistrationTable(
                      assessment: assessment,
                    )
                  ],
                ),
              ),
            );
          },
          error: (error, stack) => Container(),
          loading: () => Container()),
    );
  }


}
