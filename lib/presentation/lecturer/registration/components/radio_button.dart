import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/state/providers/radiobutton_provider.dart';
import 'package:student_attendance/widgets/widgets.dart';



class RadioButtons extends ConsumerWidget {
  const RadioButtons({Key? key}) : super(key: key);

  Widget build(BuildContext context,WidgetRef ref) {
    var dimension=Dimensions(context: context);
    var result=ref.watch(radioProvider);
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StudlyTypography(text:'Assessment Type'),
          RadioListTile(
              title: StudlyTypography(text:'Exam',fontWeight: FontWeight.normal,fontSize: dimension.font13,),
              value: 'Exam',
              groupValue: result,
              onChanged: (value) {
                ref.read(radioProvider.notifier).onChangeOption(value!);
              }),
          RadioListTile(
              title: StudlyTypography(text:'Test',fontWeight: FontWeight.normal,fontSize: dimension.font13,),
              value: 'Test',
              groupValue: result,
              onChanged: (value) {
                ref.read(radioProvider.notifier).onChangeOption(value!);;
              }),

        ],

    );
  }
}