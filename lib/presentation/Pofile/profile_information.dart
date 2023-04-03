import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/config/dimensions.dart';
import 'package:student_attendance/presentation/Pofile/profile_information_body.dart';
import 'package:student_attendance/state/users/models/user.dart';
import 'package:student_attendance/widgets/widgets.dart';

class ProfileInformation extends ConsumerWidget {
  static const String routeName='/profileInformation';

  static Route route({required User user}){
    return MaterialPageRoute(
      settings:const RouteSettings(name: routeName),
      builder: (_) => ProfileInformation(user: user,),);
  }
  const ProfileInformation({Key? key,required this.user}) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    var dimension=Dimensions(context: context);

    return Scaffold(
      appBar: StudlyAppBar(
        title: 'Profile Information',
        icon: Iconsax.arrow_left_1,
        onPressed: (){Navigator.pop(context);},),
      body:ProfileInformationBody(student:user ,),

    );
  }
}
