import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/presentation/lecturer/home/components/drawer_item.dart';
import 'package:student_attendance/state/auth/providers/auth_state_provider.dart';
import 'package:student_attendance/state/users/models/user.dart';
import 'package:student_attendance/state/users/providers/user_info_model_provider.dart';
import 'package:student_attendance/widgets/widgets.dart';

class StudlyNavigationDrawer extends ConsumerWidget {
  const StudlyNavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var dimension = Dimensions(context: context);
    var user = ref.watch(userInfoModelProvider(authStateProvider));

    return Drawer(
      child: Material(
        color: StudlyColors.backgroundColorBlueAccent,
        child: Padding(
          padding: EdgeInsets.only(
            left: dimension.horizontalPadding22,
            top: dimension.verticalPadding80,
            right: dimension.horizontalPadding22,
          ),
          child: Column(
            children: [
              user.when(
                  data: (user) {
                    return headerWidget(
                      user: user,
                      dimension: dimension,
                    );
                  },
                  error: (error, stack) => Container(),
                  loading: () => Container()),
              SizedBox(
                height: dimension.sizedBox40,
              ),
              Divider(
                thickness: 1,
                height: dimension.containerHeight12,
                color: Colors.grey,
              ),
              SizedBox(
                height: dimension.sizedBox40,
              ),
              DrawerItem(
                  name: 'Home',
                  icon: Iconsax.home_1,
                  onPressed: () {
                    Navigator.pushNamed(context, '/StudlyPlusHome');
                  }),
              SizedBox(
                height: dimension.sizedBox30,
              ),
              DrawerItem(
                  name: 'Registration',
                  icon: Iconsax.check,
                  onPressed: () {
                    Navigator.pushNamed(context, '/registration');
                  }),
              SizedBox(
                height: dimension.sizedBox30,
              ),
              DrawerItem(
                  name: 'Log out',
                  icon: Iconsax.logout_1,
                  onPressed: () {
                    ref.read(authStateProvider.notifier).logOut();
                    Navigator.pushNamed(context, '/');
                    // Navigator.pushNamed(context, '/logout');
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget headerWidget({required User user, required Dimensions dimension}) {
    var url = user.photoUrl;
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage(url),
        ),
        SizedBox(
          height: dimension.sizedBox10,
        ),
        StudlyTypography(
          text: user.name,
          fontSize: dimension.font14,
          color: StudlyColors.typographyWhite,
        ),
        SizedBox(
          height: dimension.sizedBox10,
        ),
        StudlyTypography(
          text: user.email,
          fontSize: dimension.font14,
          color: StudlyColors.typographyWhite,
        ),
      ],
    );
  }
}
