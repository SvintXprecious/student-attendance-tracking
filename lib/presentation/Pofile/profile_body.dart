import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/state/auth/providers/auth_state_provider.dart';
import 'package:student_attendance/state/users/providers/user_info_model_provider.dart';
import 'package:student_attendance/widgets/widgets.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';

class ProfileBody extends ConsumerWidget {
  const ProfileBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var dimension = Dimensions(context: context);
    final student = ref.watch(userInfoModelProvider(authStateProvider));

    return Container(
      color: StudlyColors.backgroundColor,
      margin: EdgeInsets.only(
          top: dimension.verticalPadding30,
          left: dimension.horizontalPadding20,
          right: dimension.horizontalPadding20),
      child: SingleChildScrollView(
          child: student.when(data: (student) {
        return Column(
          children: [
            Center(
              child: WidgetCircularAnimator(
                size: 150,
                innerIconsSize: 3,
                outerIconsSize: 3,
                innerAnimation: Curves.easeInOutBack,
                outerAnimation: Curves.easeInOutBack,
                innerColor: Colors.deepPurple,
                outerColor: Colors.orangeAccent,
                innerAnimationSeconds: 10,
                outerAnimationSeconds: 10,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(student.photoUrl)),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: dimension.verticalPadding20,
            ),
            StudlyTypography(
              text: student.name,
              fontSize: dimension.font19,
            ),
            StudlyTypography(
              text: student.studentId,
              fontWeight: FontWeight.normal,
              fontSize: dimension.font13,
            ),
            SizedBox(
              height: dimension.verticalPadding20,
            ),
            const Divider(
              color: StudlyColors.backgroundColorSlate,
            ),
            SizedBox(
              height: dimension.verticalPadding20,
            ),
            InkWell(
            onTap: () {
            Navigator.pushNamed(context, '/profileInformation',
            arguments: student);
            },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: dimension.containerHeight55,
                    width: dimension.containerWidth55,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: StudlyColors.backgroundColorLightGray,
                        shape: BoxShape.rectangle),
                    child: const Icon(
                      Iconsax.edit_2,
                      color: StudlyColors.backgroundColorBlueAccent,
                    ),
                  ),
                  SizedBox(
                    width: dimension.sizedBoxWidth15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StudlyTypography(text: "Edit Profile"),
                      SizedBox(
                        height: dimension.sizedBox5,
                      ),
                      StudlyTypography(
                        text: "Edit student information.",
                        fontSize: dimension.font13,
                        fontWeight: FontWeight.normal,
                      )
                    ],
                  ),

                ],
              ),
            ),
            SizedBox(
              height: dimension.sizedBox30,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  height: dimension.containerHeight55,
                  width: dimension.containerWidth55,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: StudlyColors.backgroundColorLightGray,
                      shape: BoxShape.rectangle),
                  child: const Icon(
                    Iconsax.profile_2user,
                    color: StudlyColors.backgroundColorBlueAccent,
                  ),
                ),
                SizedBox(
                  width: dimension.sizedBoxWidth15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StudlyTypography(text: "Help Center"),
                    SizedBox(
                      height: dimension.sizedBox5,
                    ),
                    StudlyTypography(
                      text: "If you had a problem,call us.",
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                    )
                  ],
                ),

              ],
            ),
            SizedBox(
              height: dimension.sizedBox30,
            ),
            InkWell(
              onTap: () {
                ref.read(authStateProvider.notifier).logOut();
                Navigator.pushNamed(context, '/');
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                   Container(
                     height: dimension.containerHeight55,
                     width: dimension.containerWidth55,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: StudlyColors.backgroundColorLightGray,
                          shape: BoxShape.rectangle),
                      child: const Icon(
                        Iconsax.logout_1,
                        color: StudlyColors.backgroundColorBlueAccent,
                      ),
                    ),

                  SizedBox(
                    width: dimension.sizedBoxWidth15,
                  ),
                  StudlyTypography(text: "Log out"),

                ],
              ),
            ),
          ],
        );
      }, error: (error, stackTrace) => Container()
      , loading: () => Container()
      )),
    );
  }
}
