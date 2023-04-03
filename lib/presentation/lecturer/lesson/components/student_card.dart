import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/state/users/providers/fetch_students_info.dart';
import 'package:student_attendance/widgets/typography.dart';

class StudentCard extends ConsumerWidget {
  const StudentCard({Key? key,required this.attendee}) : super(key: key);
  final Map<String,dynamic> attendee;

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    var dimension=Dimensions(context: context);
    var student=ref.watch(fetchStudentInfoProvider(attendee['uid']));

    return RefreshIndicator(
      onRefresh: (){
        ref.refresh(fetchStudentInfoProvider(attendee['uid']));
        return Future.delayed(const Duration(seconds: 1));
      },
      child: Container(
        padding: EdgeInsets.only(
            top: dimension.verticalPadding10,
            bottom: dimension.verticalPadding10),

        child: student.when(
            data:(student) {
              return Column(
                children: [

                  SizedBox(height: dimension.sizedBox10,),
                  Row(
                   crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          image: DecorationImage(
                              fit:BoxFit.cover,
                              image: NetworkImage(student.photoUrl)),
                        ),
                      ),
                      SizedBox(width: dimension.horizontalPadding10,),
                      Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          StudlyTypography(text: student.name,fontSize: dimension.font14,),
                          StudlyTypography(text: student.studentId,fontWeight: FontWeight.normal,fontSize: dimension.font13,)
                        ],
                      )),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                        const Icon(Iconsax.receive_square_24,color: StudlyColors.backgroundColorBlueAccent,),
                        SizedBox(width: dimension.sizedBoxWidth5,),
                        StudlyTypography(
                          text: attendee['clock_in'].toString().isEmpty? "--:--" :  DateFormat.Hm().format(DateTime.parse(attendee['clock_in'])),
                          color:attendee['clock_in'].toString().isEmpty? StudlyColors.typographyRed:  StudlyColors.typographyGreen,
                          fontWeight: FontWeight.normal,
                          fontSize: dimension.font13,)

                      ],),

                      SizedBox(width: dimension.sizedBoxWidth10,),
                      Row(children: [
                        const Icon(Iconsax.send_sqaure_24,color: StudlyColors.backgroundColorBlueAccent,),
                        SizedBox(width: dimension.sizedBoxWidth5,),
                        StudlyTypography(
                          text: attendee['clock_out'].toString().isEmpty? "--:--" : DateFormat.Hm().format(DateTime.parse(attendee['clock_out'])),
                          color: attendee['clock_out'].toString().isEmpty? StudlyColors.typographyRed:  StudlyColors.typographyGreen,
                          fontWeight: FontWeight.normal,
                          fontSize: dimension.font13,)
                      ],)

                    ],
                  ),
                  SizedBox(height: dimension.sizedBox15,),
                  const Divider(color: StudlyColors.backgroundColorGrey,),

                ],
              );
              },
            error: (error,stack) => Container(),
            loading: () => Container()
        )
      ),
    );
  }
}
