import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/state/auth/providers/auth_state_provider.dart';
import 'package:student_attendance/state/constants/firebase_field_name.dart';
import 'package:student_attendance/state/module/notifiers/modules.dart';
import 'package:student_attendance/state/users/providers/user_info_model_provider.dart';
import 'package:student_attendance/widgets/widgets.dart';


class ModulePlannerBody extends HookConsumerWidget {
  const ModulePlannerBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    var dimension=Dimensions(context: context);

    final moduleNameHasText=useState(false);
    final moduleDescriptionHasText=useState(false);
    final moduleCodeHasText=useState(false);
    final programCodeHasText=useState(false);

    final moduleNameController=useTextEditingController();
    final programCodeController=useTextEditingController();
    final moduleDescriptionController=useTextEditingController();
    final moduleCodeController=useTextEditingController();


    useEffect(
          () {
            moduleNameController.addListener(() {
              moduleNameHasText.value = moduleNameController.text.isNotEmpty;
            },);

            moduleDescriptionController.addListener(() {
            moduleDescriptionHasText.value = moduleDescriptionController.text.isNotEmpty;
            },);

            moduleCodeController.addListener(() {
              moduleCodeHasText.value = moduleCodeController.text.isNotEmpty;
            },);

            programCodeController.addListener(() {
              programCodeHasText.value = programCodeController.text.isNotEmpty;
            },);

            return () {};
      },
      [moduleCodeController,moduleDescriptionController,moduleNameController,programCodeController,],
    );

    return Container(
      margin: EdgeInsets.only(
          left: dimension.horizontalPadding20,
          right: dimension.horizontalPadding20),
      child:SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            //module
            StudlyInputField(
              controller: moduleNameController,
              hintText: 'Enter module name',
              title: 'Module name',),

            //Description
            StudlyInputField(
              controller: moduleDescriptionController,
              maxLines: null,
              hintText: 'Enter module description',
              title: 'Description',),

            //module code
            StudlyInputField(
              controller: moduleCodeController,
              hintText: 'Enter module code',
              title: 'Code',),

            //program code

            StudlyInputField(
              controller: programCodeController,
              hintText: 'Enter program code',
              title: 'Program Code',),

            SizedBox(height: dimension.verticalPadding60,),
            StudlyButton(
                label: 'Add Module',
                onPressed: moduleNameHasText.value
                    && moduleCodeHasText.value
                    && moduleDescriptionHasText.value && programCodeHasText.value?(){
                  _addModuleWithController(
                      moduleNameController: moduleNameController,
                      programCodeController: programCodeController,
                      moduleDescriptionController: moduleDescriptionController,
                      moduleCodeController: moduleCodeController,
                      context: context,
                      ref: ref);
                }:
                null)
          ],
        ),
      ) ,
    );
  }

  Future<void> _addModuleWithController({
     required  TextEditingController moduleNameController,
      required TextEditingController programCodeController,
      required TextEditingController moduleDescriptionController,
      required TextEditingController moduleCodeController,
      required WidgetRef ref,
    required BuildContext context}
      ) async {
    final user=ref.read(userInfoModelProvider(authStateProvider)).value;
    if (user == null) {
      return;
    }
    final isSent = await ref
        .read(modulesProvider.notifier)
        .addModule(
        name:moduleNameController.text,
        description:moduleDescriptionController.text ,
        lecturer: {FirebaseFieldName.uid:user.uid, FirebaseFieldName.displayName:user.name},
        code: moduleCodeController.text,
        programCode: programCodeController.text
            .toUpperCase()
            .trim()
            .split(',')
            .toList());

    if (isSent) {
      moduleNameController.clear();
      programCodeController.clear();
      moduleDescriptionController.clear();
      moduleCodeController.clear();
      Navigator.pushNamed(context, '/lecturerModules');
    }


  }
}
