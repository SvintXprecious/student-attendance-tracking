import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/presentation/lecturer/registration/components/assessment_carousel.dart';
import 'package:student_attendance/state/auth/providers/auth_state_provider.dart';
import 'package:student_attendance/state/registrations/providers/fetch_assessments.dart';

class RegistrationTabBar extends ConsumerStatefulWidget {
  const RegistrationTabBar({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<RegistrationTabBar> createState() => _RegistrationTabBarState();
}

class _RegistrationTabBarState extends ConsumerState<RegistrationTabBar>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var dimensions = Dimensions(context: context);
    TabController tabController = TabController(length: 2, vsync: this);
    var uid=ref.watch(authStateProvider).userId!;
    var assessments = ref.watch(fetchAssessmentsProvider(uid));


    
    var programCodes = ['Exam', 'Test'];
    return RefreshIndicator(
      onRefresh: () {
       // ref.refresh(fetchAssessmentsProvider(authStateProvider));
        return Future.delayed(const Duration(seconds: 1));
      },
      child: assessments.when(
          data: (assessments) {
            print("Assessments ${assessments.length}");
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: dimensions.verticalPadding20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FadeInUp(
                      delay: const Duration(milliseconds: 400),
                      duration: const Duration(milliseconds: 1000),
                      child: TabBar(
                        labelPadding: EdgeInsets.only(
                            left: dimensions.horizontalPadding20,
                            right: dimensions.horizontalPadding20),
                        labelStyle: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorColor: StudlyColors.backgroundColorBlueAccent,
                        isScrollable: true,
                        controller: tabController,
                        labelColor: StudlyColors.typographyDefaultColor,
                        unselectedLabelColor: StudlyColors.typographyGrey,
                        tabs: [
                          for (var programCode in programCodes)
                            Tab(
                              text: programCode,
                            )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                        left: dimensions.horizontalPadding10,
                        top: dimensions.verticalPadding20),
                    child: FadeInLeft(
                      duration: const Duration(milliseconds: 1000),
                      delay: const Duration(milliseconds: 400),
                      child: TabBarView(
                          physics: const BouncingScrollPhysics(),
                          controller: tabController,
                          children: [
                            for (var i = 0; i < programCodes.length; i++)
                              AssessmentCarousel(
                                assessments: assessments.where((assessment) =>
                                    assessment.type == programCodes[i]),
                              ),
                          ]),
                    ),
                  ),
                )
              ],
            );
          },
          error: (error, stack) => Container(),
          loading: () => Container()),
    );
  }
}
