import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/presentation/lecturer/registration/components/tabbar.dart';
import 'package:student_attendance/widgets/widgets.dart';

class RegistrationUI extends StatelessWidget {
  const RegistrationUI({Key? key}) : super(key: key);
  static const String routeName = '/registration';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const RegistrationUI(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var dimension = Dimensions(context: context);
    return Scaffold(
      appBar: StudlyAppBar(
        title: 'Registration',
        icon: Iconsax.arrow_left_1,
        onPressed: () {
          Navigator.pushNamed(context, '/StudlyPlusHome');
        },
        actions: [
          Padding(
            padding: EdgeInsets.only(top: dimension.verticalPadding10,right: dimension.horizontalPadding10),
            child: IconButton(
              onPressed: (){Navigator.pushNamed(context, '/formfields');},
              icon: const Icon(Iconsax.note_add),color: StudlyColors.backgroundColorBlack,),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(
            left: dimension.horizontalPadding20,
            right: dimension.horizontalPadding20,
            top: dimension.verticalPadding20),
        child: const RegistrationTabBar(),
      ),
    );
  }
}


