import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/presentation/lecturer/lesson/components/tab_bar_view.dart';
import 'package:student_attendance/state/providers/datetime_provider.dart';
import 'package:student_attendance/widgets/typography.dart';

class TimetableBody extends ConsumerWidget {
  const TimetableBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    var dimension=Dimensions(context: context);
    var dateTime= ref.watch(dateTimeProvider);
    return RefreshIndicator(
      onRefresh: (){
        ref.refresh(dateTimeProvider);
        return Future.delayed(const Duration(seconds: 1));
      },
      child: Container(
        margin: EdgeInsets.only(
            left: dimension.horizontalPadding20,
            right: dimension.horizontalPadding20,
            top: dimension.verticalPadding20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            StudlyTypography(
              text:  DateFormat.yMMMMd().format(DateTime.now()),
              color: StudlyColors.typographyGrey,),
            StudlyTypography(text: 'Today',fontSize:dimension.font19),
            SizedBox(height: dimension.verticalPadding10,),
            DatePicker(
              //DateTime.parse( '${DateTime.now().year}-${DateTime.november}-30'),
              DateTime.now(),
              onDateChange: (date){ref.read(dateTimeProvider.notifier).onDateSelected(date);},
              initialSelectedDate:DateTime.now(),
              selectionColor: StudlyColors.backgroundColorBlueAccent,
              deactivatedColor: StudlyColors.backgroundColorGrey,
              height: dimension.containerHeight100,
              width: dimension.containerHeight100,
              dateTextStyle: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize:dimension.font17,
                  fontWeight:FontWeight.bold,
                ),

              ) ,
            ),
            Expanded(child: TabBarViewBody(dateTime:dateTime ,))
            //SessionCard(),



          ],
        ),
      ),
    );
  }
}
