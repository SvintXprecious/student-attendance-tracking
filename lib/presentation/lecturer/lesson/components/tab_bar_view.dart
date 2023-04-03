import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/presentation/lecturer/lesson/components/listview_carousel.dart';
import 'package:student_attendance/state/auth/providers/auth_state_provider.dart';
import 'package:student_attendance/state/module/model/module.dart';
import 'package:student_attendance/state/module/providers/fetch_lecturer_modules_provider.dart';
import 'package:student_attendance/state/sessions/providers/fetch_lecturer_sessions_provider.dart';


class TabBarViewBody extends ConsumerStatefulWidget {
  const TabBarViewBody({Key? key,required this.dateTime }):super(key: key);
  final DateTime dateTime;


  @override
  ConsumerState<TabBarViewBody> createState() => _TabBarViewBodyState();
}

class _TabBarViewBodyState extends ConsumerState<TabBarViewBody> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final modules=ref.watch(fetchLecturerModulesProvider(authStateProvider));
    final sessions=ref.watch(fetchLecturerSessionsProvider(authStateProvider));

    var dimensions=Dimensions(context: context);
    return RefreshIndicator(
      onRefresh: () {
        ref.refresh(fetchLecturerModulesProvider(authStateProvider));
        ref.refresh(fetchLecturerSessionsProvider(authStateProvider));
        return Future.delayed(const Duration(seconds: 1));
      },
      child: modules.when(
          data: (modules){
            final programCodes=Module.extractProgramCodes(modules);
            final int capacity=programCodes.length;
            TabController tabController=TabController(length: programCodes.length, vsync: this);
            if(capacity>1){
              return Column(
            children:[
              Container(
                padding: EdgeInsets.only(top:dimensions.verticalPadding20),
                child:Align(
                  alignment: Alignment.centerLeft,
                  child: FadeInUp(
                    delay: const Duration(milliseconds: 400),
                    duration: const Duration(milliseconds: 1000),
                    child: TabBar(
                      labelPadding: EdgeInsets.only(left: dimensions.horizontalPadding20,right: dimensions.horizontalPadding20),
                      labelStyle:GoogleFonts.poppins(textStyle: const TextStyle(fontWeight: FontWeight.bold,fontSize: 14,),) ,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: StudlyColors.backgroundColorBlueAccent,
                      isScrollable: true,
                      controller: tabController,
                      labelColor: StudlyColors.typographyDefaultColor,
                      unselectedLabelColor: StudlyColors.typographyGrey,
                      tabs:  [
                        for(var programCode in programCodes)
                          Tab(text: programCode,)
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: dimensions.horizontalPadding10,top: dimensions.verticalPadding20),
                  child: FadeInLeft(
                    duration: const Duration(milliseconds: 1000),
                    delay: const Duration(milliseconds: 400),
                      child:sessions.when(
                        data: (sessions){
                          return TabBarView(
                            physics: const BouncingScrollPhysics(),
                            controller: tabController,
                            children:  [
                              for(var i=0; i<capacity; i++)
                                ListViewSessionCarousel(
                                  sessions:sessions
                                      .where((session) => DateFormat.yMMMMd()
                                      .format(DateTime
                                      .parse(session.date))== DateFormat.yMMMMd().format(widget.dateTime).toString())
                                      .where((session) => session.programCode.contains(programCodes.elementAt(i)),)

                                ),
                            ],
                          );
                        },
                        error: (error,stack) => Container(),
                        loading: () => Container())
                  ),
                ),
              )


            ],
          );
        }

        else{
          return sessions.when(
              data: (sessions) => ListViewSessionCarousel(sessions: sessions.where((session) => DateFormat
                  .yMMMMd()
                  .format(DateTime
                  .parse(session.date))== DateFormat.yMMMMd().format(widget.dateTime).toString())),
              error: (error,stack) => Container(),
              loading: () => Container()
          );

        }
        },
          error: (error,stack) => Container(),
          loading: () => Container())


    );
  }
}
