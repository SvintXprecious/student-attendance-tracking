import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/presentation/Pofile/profile_body.dart';
import 'package:student_attendance/widgets/widgets.dart';

class ProfileUI extends StatelessWidget {
  static const String routeName='/profile';

  static Route route(){
    return MaterialPageRoute(
      settings:const RouteSettings(name: routeName),
      builder: (_) => const ProfileUI(),);
  }
  const ProfileUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dimension=Dimensions(context: context);
    return Scaffold(
      backgroundColor: StudlyColors.backgroundColor,
      appBar: StudlyAppBar(title: 'Profile',icon: Iconsax.arrow_left_1,onPressed: (){Navigator.pop(context);},),
      body: const ProfileBody(),
      bottomNavigationBar: Container(
        color: StudlyColors.backgroundColor,
        child: GNav(
            backgroundColor: StudlyColors.backgroundColorLightGray,
            rippleColor: Colors.grey,
            // tab button ripple color when pressed
            hoverColor: Colors.grey,
            // tab button hover color
            haptic: true,
            // haptic feedback
            tabBorderRadius: 40,
            // tab button border// tab button shadow
            curve: Curves.easeOutExpo,
            // tab animation curves
            duration: const Duration(milliseconds: 900),
            // tab animation duration
            gap: 8,
            selectedIndex: 3,
            // the tab button gap between icon and text
            color: Colors.grey[800],
            // unselected icon color
            activeColor: StudlyColors.backgroundColorBlueAccent,
            // selected icon and text color
            iconSize: dimension.containerHeight30,
            // tab button icon size
            tabBackgroundColor: Colors.blueAccent.withOpacity(0.1),
            tabMargin: EdgeInsets.only(
                bottom: dimension.verticalPadding5,
                top: dimension.verticalPadding5),
            // selected tab background color
            padding: EdgeInsets.only(
                left: dimension.horizontalPadding10,
                right: dimension.horizontalPadding10,
                top: dimension.verticalPadding10,
                bottom: dimension.verticalPadding10),
            // navigation bar padding
            tabs: [
              GButton(
                icon: Iconsax.home,
                text: "Home",
                iconSize: dimension.containerHeight24,
                textSize: dimension.font13,
                onPressed: () {
                  Navigator.pushNamed(context, '/');
                },
              ),
              GButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/lessons');
                },
                icon: Iconsax.menu_board,
                iconSize: dimension.containerHeight24,
                textSize: dimension.font13,
                text: 'Classes',
              ),
              GButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/modules');
                },
                icon: Iconsax.save_2,
                iconSize: dimension.containerHeight24,
                textSize: dimension.font13,
                text: 'Modules',
              ),
              GButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/profile');
                },
                icon: Iconsax.user,
                iconSize: dimension.containerHeight24,
                textSize: dimension.font13,
                text: 'Profile',
              ),
            ]),
      ),
    );
  }
}
