import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:searchfield/searchfield.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/state/auth/providers/auth_state_provider.dart';
import 'package:student_attendance/state/users/models/user.dart';
import 'package:student_attendance/widgets/widgets.dart';

class ProfileInformationBody extends HookConsumerWidget {
  const ProfileInformationBody({Key? key, required this.student})
      : super(key: key);
  final User student;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var dimension = Dimensions(context: context);

    Map<String ,String> programs = {'Business Information Technology':'BIT'};

    final studentProgramHasText = useState(false);
    final studentProgramYearHasText = useState(false);

    final studentNameController = useTextEditingController(text: student.name);
    final studentEmailController =
        useTextEditingController(text: student.email);
    final studentIDController =
        useTextEditingController(text: student.studentId);
    final studentProgramController =
        useTextEditingController(text: student.program);
    final studentProgramYearController =
        useTextEditingController(text: student.year);
    final studentUniversityController = useTextEditingController(
        text: 'Malawi University Of Science and Technology');

    useEffect(
      () {
        studentProgramController.addListener(
          () {
            studentProgramHasText.value =
                studentProgramController.text.toString().isNotEmpty;
          },
        );

        studentProgramYearController.addListener(
          () {
            studentProgramYearHasText.value =
                studentProgramYearController.text.toString().isNotEmpty;
          },
        );

        return () {};
      },
      [studentProgramController, studentProgramYearController],
    );

    return Container(
      margin: EdgeInsets.only(
          left: dimension.horizontalPadding20,
          right: dimension.horizontalPadding20),
      child: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //module
          StudlyInputField(
            readOnly: true,
            controller: studentNameController,
            hintText: studentNameController.value.text,
            title: 'Name',
          ),

          //Description
          StudlyInputField(
            readOnly: true,
            controller: studentEmailController,
            maxLines: null,
            hintText: studentEmailController.value.text,
            title: 'Email',
          ),

          //module code
          StudlyInputField(
            readOnly: true,
            controller: studentIDController,
            hintText: studentIDController.value.text,
            title: 'Student ID',
          ),

          Container(
            padding: EdgeInsets.only(top: dimension.verticalPadding30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: dimension.horizontalPadding6),
                  child: StudlyTypography(
                    text: 'Program',
                    fontSize: dimension.font14,
                  ),
                ),
                SizedBox(height: dimension.sizedBox10),
                SearchField(
                  textInputAction: TextInputAction.done,
                  controller: studentProgramController,
                  suggestions: programs.keys
                      .map((program) =>
                          SearchFieldListItem(
                              program,
                              child: StudlyTypography(text: program,)))
                      .toList(),
                  onSuggestionTap: (value) {
                    studentProgramController.text = value.item;
                  },
                ),
              ],
            ),
          ),

          //program code

          StudlyInputField(
            controller: studentProgramYearController,
            hintText: studentProgramYearController.value.text,
            title: 'Year',
          ),

          StudlyInputField(
            readOnly: true,
            controller: studentUniversityController,
            hintText: studentUniversityController.value.text,
            title: 'University',
          ),

          SizedBox(
            height: dimension.verticalPadding60,
          ),
          StudlyButton(
              label: 'Update Details',
              onPressed: studentProgramController.text.isNotEmpty &&
                      studentProgramYearController.text.isNotEmpty
                  ? () {
                      _updateUser(
                          context: context,
                          ref: ref,
                          studentProgramController: studentProgramController,
                          studentProgramYearController:studentProgramYearController,
                          code: programs[studentProgramController.text]!
                      );
                    }
                  : null)
        ],
      )),
    );
  }

  Future<void> _updateUser(
      {required TextEditingController studentProgramController,
      required TextEditingController studentProgramYearController,
        required String code,
      required WidgetRef ref,
      required BuildContext context}) async {
    final isSent = await ref.read(authStateProvider.notifier).updateUser(
        uid: student.uid,
        program: studentProgramController.value.text,
        year: studentProgramYearController.value.text,
        code:generateProgramCode(
          program: code,
          year: studentProgramYearController.value.text,)
    );

    if (isSent) {
      studentProgramController.clear();
      studentProgramYearController.clear();

      Navigator.pushNamed(context, '/profile');
    }
  }

  String generateProgramCode({required String program,required String year}) => '${program.toUpperCase()}$year';




}
