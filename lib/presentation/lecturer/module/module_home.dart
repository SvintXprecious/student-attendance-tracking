import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/presentation/lecturer/module/module_body.dart';
import 'package:student_attendance/widgets/appbar.dart';

class ModuleHome extends StatelessWidget {
  static const String routeName='/lecturerModules';

  static Route route(){
    return MaterialPageRoute(
      settings:const RouteSettings(name: routeName),
      builder: (_) => const ModuleHome(),);
  }
  const ModuleHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dimension=Dimensions(context: context);
    return Scaffold(
      appBar: StudlyAppBar(
          title: 'Modules',
          icon: Iconsax.arrow_left_1,
          onPressed: (){Navigator.pushNamed(context, '/StudlyPlusHome');},
        actions: [
            Padding(
          padding: EdgeInsets.only(
              left: dimension.horizontalPadding10,
              top: dimension.verticalPadding10),
          child: IconButton(
            onPressed: (){Navigator.pushNamed(context, '/modulePlanner');},
            icon: Icon(Iconsax.note_favorite, size: dimension.font24,
              color: StudlyColors.iconColorBlack,),
          ),
        ),
      ],),
      body: const ModuleBody(),
      bottomNavigationBar: Container(
        color: StudlyColors.backgroundColor,

        child: GNav(
            backgroundColor: StudlyColors.backgroundColorLightGray,
            rippleColor: Colors.grey, // tab button ripple color when pressed
            hoverColor: Colors.grey, // tab button hover color
            haptic: true, // haptic feedback
            tabBorderRadius: 40,
            selectedIndex: 2,
            // tab button border// tab button shadow
            curve: Curves.easeOutExpo, // tab animation curves
            duration: const Duration(milliseconds: 900), // tab animation duration
            gap: dimension.horizontalPadding8, // the tab button gap between icon and text
            color: Colors.grey[800], // unselected icon color
            activeColor: StudlyColors.backgroundColorBlueAccent, // selected icon and text color
            iconSize: dimension.containerHeight30, // tab button icon size
            tabBackgroundColor: Colors.blueAccent.withOpacity(0.1),
            tabMargin:  EdgeInsets.only(

                bottom: dimension.verticalPadding5,
                top: dimension.verticalPadding5),
            // selected tab background color
            padding:EdgeInsets.only(
                left: dimension.horizontalPadding10,
                right: dimension.horizontalPadding10,
                top:dimension.verticalPadding10,
                bottom: dimension.verticalPadding10), // navigation bar padding
            tabs: [
              GButton(
                icon: Iconsax.home,
                text: "Home",
                iconSize: dimension.containerHeight24,
                textSize: dimension.font13,
                onPressed: (){Navigator.pushNamed(context, '/StudlyPlusHome');},
              ),
              GButton(
                onPressed: (){Navigator.pushNamed(context, '/lecturerTimetable');},
                icon: Iconsax.menu_board,
                iconSize: dimension.containerHeight24,
                textSize: dimension.font13,
                text: 'Timetable',
              ),
              GButton(
                onPressed: (){Navigator.pushNamed(context, '/lecturerModules');},
                icon: Iconsax.save_2,
                iconSize: dimension.containerHeight24,
                textSize: dimension.font13,
                text: 'Modules',
              ),


            ]
        ),
      ) ,

    );
  }
}
