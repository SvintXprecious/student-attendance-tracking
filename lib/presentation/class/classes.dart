import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:student_attendance/config/config.dart';

import 'lessons_view.dart';

class LessonsUI extends StatelessWidget {
  static const String routeName='/lessons';

  static Route route(){
    return MaterialPageRoute(
      settings:const RouteSettings(name: routeName),
      builder: (_) => const LessonsUI(),);
  }

  const LessonsUI({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    var dimension=Dimensions(context: context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: StudlyColors.backgroundColor,
        automaticallyImplyLeading: true,
        toolbarHeight: dimension.toolbarHeight65,
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.only(left: dimension.horizontalPadding10,top: dimension.verticalPadding10),
          child: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(Iconsax.arrow_left_1,size: dimension.font24,color: StudlyColors.iconColorBlack,),
          ),
        ),

        title: Padding(
          padding: EdgeInsets.only(top: dimension.verticalPadding10),
          child: RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: 'Lessons',
                  style:GoogleFonts.poppins(textStyle: TextStyle(fontSize:dimension.font19,
                      fontWeight: FontWeight.bold, color: StudlyColors.typographyDefaultColor))),

              TextSpan(
                  text: '.',
                  style: TextStyle(fontSize:dimension.font32,color: StudlyColors.typographyRed))
            ]),
          ),
        ),
      ),
      body: const LessonsView(),
      bottomNavigationBar: Container(
        color: StudlyColors.backgroundColor,
        child: GNav(
            backgroundColor: StudlyColors.backgroundColorLightGray,
            rippleColor: Colors.grey,
            // tab button ripple color when pressed
            hoverColor: Colors.grey,
            // tab button hover color
            haptic: true,
            selectedIndex: 1,
            // haptic feedback
            tabBorderRadius: 40,
            // tab button border// tab button shadow
            curve: Curves.easeOutExpo,
            // tab animation curves
            duration: const Duration(milliseconds: 900),
            // tab animation duration
            gap: 8,
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
                icon: Iconsax.book,
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
