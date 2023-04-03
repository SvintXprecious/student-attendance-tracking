import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/state/module/model/module.dart';
import 'package:student_attendance/state/module/notifiers/modules.dart';
import 'package:student_attendance/widgets/widgets.dart';


class ModulePlannerEditor extends HookConsumerWidget {
  static const String routeName='/moduleEditor';

  static Route route({required Module module}){
    return MaterialPageRoute(
      settings:const RouteSettings(name: routeName),
      builder: (_) => ModulePlannerEditor(module: module,),);
  }
  const ModulePlannerEditor({Key? key, required this.module}) : super(key: key);
  final Module module;



  @override
  Widget build(BuildContext context,WidgetRef ref) {
    var dimension=Dimensions(context: context);


    final moduleNameHasText=useState(true);
    final moduleDescriptionHasText=useState(true);
    final moduleCodeHasText=useState(true);
    final programCodeHasText=useState(true);

    final moduleNameController=useTextEditingController(text:module.name );
    final programCodeController=useTextEditingController(text: module.programCode.join(" , "));
    final moduleDescriptionController=useTextEditingController(text: module.description);
    final moduleCodeController=useTextEditingController(text: module.code);


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
      [moduleCodeController,moduleDescriptionController,programCodeController,moduleNameController],
    );

    return Scaffold(
      appBar: StudlyAppBar(
          title: 'Module',
          icon: Iconsax.arrow_left_1,
          onPressed: (){
            Navigator.pop(context);

          }),
      body: Container(
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
                hintText: moduleNameController.value.text,
                title: 'Module name',),

              //Description
              StudlyInputField(
                lineHeight: 2,
                controller: moduleDescriptionController,
                maxLines: null,
                hintText: moduleDescriptionController.value.text,
                title: 'Description',),

              //module code
              StudlyInputField(
                controller: moduleCodeController,
                hintText: moduleCodeController.value.text,
                title: 'Code',),

              //program code

              StudlyInputField(
                controller: programCodeController,
                hintText: programCodeController.value.text,
                title: 'Program Code',),

              SizedBox(height: dimension.verticalPadding60,),
              StudlyButton(
                  label: 'Update Module',
                  onPressed: moduleNameHasText.value
                      && moduleCodeHasText.value
                      && moduleDescriptionHasText.value
                      && programCodeHasText.value?(){
                    _updateModuleWithController(
                        moduleNameController: moduleNameController,
                        programCodeController: programCodeController,
                        moduleDescriptionController: moduleDescriptionController,
                        moduleCodeController: moduleCodeController,
                        context: context,
                        ref: ref);
                  }: null)
            ],
          ),
        ) ,
      ),
    );
  }

  Future<void> _updateModuleWithController({
    required  TextEditingController moduleNameController,
    required TextEditingController programCodeController,
    required TextEditingController moduleDescriptionController,
    required TextEditingController moduleCodeController,
    required WidgetRef ref,
    required BuildContext context}
      ) async {

    final isSent = await ref
        .read(modulesProvider.notifier)
        .updateModule(
        moduleCode: moduleCodeController.value.text,
        programCode:programCodeController.value.text.split(',').map((s) => s.trim().toUpperCase()).toList(),
        description: moduleDescriptionController.value.text,
        name: moduleNameController.value.text,);

    if (isSent) {
      moduleNameController.clear();
      programCodeController.clear();
      moduleDescriptionController.clear();
      moduleCodeController.clear();
      Navigator.pushNamed(context, '/lecturerModules');
    }


  }
}
