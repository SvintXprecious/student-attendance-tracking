import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/state/module/model/module.dart';
import 'package:student_attendance/state/module/notifiers/modules.dart';
import 'package:student_attendance/state/sessions/model/session.dart';
import 'package:student_attendance/state/sessions/providers/fetch_Sessions_By_Module_Provider.dart';
import 'package:student_attendance/widgets/widgets.dart';

class ModuleCard extends ConsumerWidget{
  const ModuleCard({Key? key,required this.module,this.session}) : super(key: key);
  final Module module;
  final Session? session;

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    var dimension=Dimensions(context: context);
    var sessions=ref.watch(fetchSessionsByModuleProvider(module.code));
    return Container(
      margin: EdgeInsets.only(top: dimension.verticalPadding10,bottom: dimension.verticalPadding10),
      padding:EdgeInsets.all(dimension.verticalPadding20),
      decoration: BoxDecoration(
          color: StudlyColors.backgroundColorBlueAccent,
          borderRadius: BorderRadius.circular(30)
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
            title: IconWithTextFlexed(
              icon: Iconsax.verify5,
              label: module.name,
              labelFontSize: dimension.font16,
              iconColor: StudlyColors.backgroundColorAqua,
              labelColor: StudlyColors.typographyWhite,),
            trailing: StudlyPopUpMenu(
              menuList: [
                PopupMenuItem(
                  child: ListTile(
                    onTap: (){Navigator.pushNamed(context, '/moduleAttendance',arguments: module);},
                    leading: const Icon(
                      Iconsax.chart,
                      color: StudlyColors.backgroundColorBlueAccent,
                    ),
                    title: StudlyTypography(text: "Attendance",fontSize: dimension.font13),
                  ),
                ),
                PopupMenuItem(
                  child: ListTile(
                    onTap: (){Navigator.pushNamed(context, '/modulePlanner');},
                    leading: const Icon(
                      Iconsax.mirror,
                      color: StudlyColors.backgroundColorBlueAccent,
                    ),
                    title: StudlyTypography(text: "View",fontSize: dimension.font13,),
                  ),
                ),
                PopupMenuItem(
                  child: ListTile(
                    onTap: (){Navigator.pushNamed(context, '/moduleEditor',arguments: module);},
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
                      ref.read(modulesProvider.notifier).deleteModule(moduleID: module.code);
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
                  color: StudlyColors.backgroundColorAqua,

                ),
                child: const Icon(Iconsax.more),),

            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: dimension.horizontalPadding50),
            child: StudlyTypography(
              text: module.code,
              fontWeight: FontWeight.normal,
              fontSize: dimension.font11,
              color: StudlyColors.typographyWhite,),
          ),
          SizedBox(height: dimension.sizedBox10,),
          Padding(
            padding: EdgeInsets.only(left: dimension.horizontalPadding50),
            child: StudlyTypography(
              text: 'by ${module.lecturer['name']}',
              textOverflow: TextOverflow.visible,
              maxLines: null,
              fontWeight: FontWeight.normal,
              fontSize: dimension.font11,
              color: StudlyColors.typographyWhite,),
          ),
          SizedBox(height: dimension.sizedBox15,),
          Container(
            margin: EdgeInsets.only(left: dimension.horizontalPadding32),
            padding: EdgeInsets.only(left:dimension.horizontalPadding10,right: dimension.horizontalPadding10),
            decoration: BoxDecoration(
              color:StudlyColors.backgroundColorAqua,
                borderRadius: BorderRadius.circular(30)),
            child: sessions.when(
                data: (sessions) =>  StudlyTypography(
                  text: sessions==1?'${sessions.toString()} lesson':'${sessions.toString()} lessons',
                  color: StudlyColors.typographyWhite,
                  fontSize: dimension.font13,),
                error: (error,stack) => Container(),
                loading: () => Container()),


          ),


        ],
      ),
    );
  }
}

