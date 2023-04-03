import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/state/sessions/model/session.dart';
import 'package:student_attendance/state/sessions/notifier/sessions.dart';
import 'package:student_attendance/widgets/widgets.dart';


class SessionCard extends ConsumerWidget{
  const SessionCard({Key? key,required this.session}) : super(key: key);
  final Session session;

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    var dimension=Dimensions(context: context);
    return InkWell(
      onTap: (){Navigator.pushNamed(context, '/sessionDetails',arguments: session);

      },
      child:Container(
        margin: EdgeInsets.only(top: dimension.verticalPadding10,bottom: dimension.verticalPadding10),
        decoration: BoxDecoration(
            color: StudlyColors.backgroundColorLightGray,
            border: Border.all(color: StudlyColors.backgroundColorLightGray),
            borderRadius: BorderRadius.circular(20)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              selected: true,
              onTap: (){},
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
              ),
              title: StudlyTypography(
                text: session.title,
                fontSize: dimension.font18,
                color: StudlyColors.typographyDefaultColor,),
              trailing: StudlyPopUpMenu(
                menuList: [
                  PopupMenuItem(
                    child: ListTile(
                      onTap: (){Navigator.pushNamed(context, '/sessionAttendance',arguments: session);},
                      leading: const Icon(
                        Iconsax.chart,
                        color: StudlyColors.backgroundColorBlueAccent,
                      ),
                      title: StudlyTypography(text: "Attendance",fontSize: dimension.font13),
                    ),
                  ),
                  PopupMenuItem(
                    child: ListTile(
                      onTap: (){Navigator.pushNamed(context, '/sessionDetails',arguments: session);},
                      leading: const Icon(
                        Iconsax.mirror,
                        color: StudlyColors.backgroundColorBlueAccent,
                      ),
                      title: StudlyTypography(text: "View",fontSize: dimension.font13,),
                    ),
                  ),
                  PopupMenuItem(
                    child: ListTile(
                      onTap: (){Navigator.pushNamed(context, '/modulePlanner');},
                      leading: const Icon(
                        Iconsax.edit_2,
                        color: StudlyColors.backgroundColorBlueAccent,
                      ),
                      title: StudlyTypography(text: "Edit",fontSize: dimension.font13),
                    ),
                  ),
                  PopupMenuItem(
                    child: ListTile(
                      onTap: (){
                        ref.read(sessionsProvider.notifier).deleteSession(documentID: session.sessionID);
                      },
                      leading: const Icon(
                        Iconsax.trash,
                        color: StudlyColors.backgroundColorBlueAccent,
                      ),
                      title: StudlyTypography(text: "Delete",fontSize: dimension.font13),
                    ),
                  ),
                ],
                icon: Container(
                  width: dimension.containerWidth30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: StudlyColors.backgroundColorBlueAccent,

                  ),
                  child: const Icon(Iconsax.more),),

              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: dimension.horizontalPadding20),
              child: IconWithText(
                icon: Iconsax.verify5,
                label:session.module['name'],
                iconColor: StudlyColors.backgroundColorBlueAccent,
                labelColor: StudlyColors.typographyDefaultColor,),
            ),
            SizedBox(height: dimension.sizedBox10,),
            Padding(
              padding: EdgeInsets.only(left: dimension.horizontalPadding20),
              child: StudlyTypography(
                text: session.module['code'],
                color:StudlyColors.typographyDefaultColor,
                fontSize: dimension.font14,),
            ),
            SizedBox(height: dimension.sizedBox15,),
            Padding(
              padding: EdgeInsets.only(left: dimension.horizontalPadding20,right: dimension.horizontalPadding20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconWithText(
                    icon: Iconsax.clock,
                    label: '${session.start} - ${session.end}',
                    iconColor: StudlyColors.backgroundColorBlueAccent,
                    labelColor: StudlyColors.typographyDefaultColor,),
                  StudlyTypography(text: session.room,color:StudlyColors.typographyDefaultColor,)
                ],
              ),
            ),
            SizedBox(height: dimension.sizedBox15,),

          ],
        ),
      ),
    );
  }
}
