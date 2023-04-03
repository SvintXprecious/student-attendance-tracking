import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/state/registrations/model/registration.dart';
import 'package:student_attendance/state/registrations/notifier/registrations.dart';
import 'package:student_attendance/state/registrations/providers/fetch_assessment.dart';
import 'package:student_attendance/widgets/widgets.dart';

class AssessmentCard extends ConsumerWidget {
  const AssessmentCard({Key? key,required this.assessment}) : super(key: key);
  final Registration assessment;


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var dimension = Dimensions(context: context);
    var assess=ref.watch(fetchAssessmentProvider(assessment.assessmentID.trim()));
    return Container(
      margin: EdgeInsets.only(
          top: dimension.verticalPadding10,
          bottom: dimension.verticalPadding10),
      padding: EdgeInsets.all(dimension.verticalPadding20),
      decoration: BoxDecoration(
          color: StudlyColors.backgroundColorBlueAccent,
          borderRadius: BorderRadius.circular(30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            selected: true,
            onTap: () {},
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(30),
              ),
            ),
            title: IconWithTextFlexed(
              icon: Iconsax.verify5,
              label: assessment.title,
              labelFontSize: dimension.font18,
              iconColor: StudlyColors.backgroundColorAqua,
              labelColor: StudlyColors.typographyWhite,
            ),
            trailing: StudlyPopUpMenu(
              menuList: [
                PopupMenuItem(
                  child: ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, '/dashboard',arguments: assessment);
                    },
                    leading: const Icon(
                      Iconsax.mirror,
                      color: StudlyColors.backgroundColorBlueAccent,
                    ),
                    title: StudlyTypography(
                      text: "View",
                      fontSize: dimension.font14,
                    ),
                  ),
                ),

                PopupMenuItem(
                  child: ListTile(
                    onTap: () {ref.read(registrationsProvider.notifier).deleteAssessment(documentID: assessment.assessmentID);},
                    leading: const Icon(
                      Iconsax.trash,
                      color: StudlyColors.backgroundColorBlueAccent,
                    ),
                    title: StudlyTypography(
                        text: "Delete", fontSize: dimension.font14),
                  ),
                ),
              ],
              icon: Container(
                width: dimension.containerWidth30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: StudlyColors.backgroundColorAqua,
                ),
                child: const Icon(Iconsax.more),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: dimension.horizontalPadding50),
            child: StudlyTypography(
              text: assessment.module['code'],
              fontSize: dimension.font13,
              color: StudlyColors.typographyWhite,
            ),
          ),
          SizedBox(
            height: dimension.sizedBox10,
          ),
          Padding(
            padding: EdgeInsets.only(left: dimension.horizontalPadding50),
            child: StudlyTypography(
              text: 'by ${assessment.lecturer["name"]}',
              textOverflow: TextOverflow.visible,
              maxLines: null,
              fontSize: dimension.font13,
              color: StudlyColors.typographyGrey,
            ),
          ),
          SizedBox(
            height: dimension.sizedBox10,
          ),

          Padding(
            padding: EdgeInsets.only(left: dimension.horizontalPadding50),
            child: StudlyTypography(
              text: DateFormat.yMMMMd().format(DateTime.parse(assessment.date)).toString(),
              color: StudlyColors.typographyWhite,
              fontSize: dimension.font14,
            ),
          ),
          SizedBox(
            height: dimension.sizedBox10,
          ),

          Container(
              margin: EdgeInsets.only(left: dimension.horizontalPadding20),
              padding: EdgeInsets.only(
                  left: dimension.horizontalPadding10,
                  right: dimension.horizontalPadding10),
              decoration: BoxDecoration(
                  color: StudlyColors.backgroundColorAqua,
                  borderRadius: BorderRadius.circular(30)),
              child: assess.when(data: (data) {
                return StudlyTypography(
                  text: '${data.attendees.length} Registered',
                  color: StudlyColors.typographyWhite,
                  fontSize: dimension.font14,
                );
              },
                  error: (error,stack) => Container(),
                  loading: () => Container()),),
        ],
      ),
    );
  }
}
