import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:searchfield/searchfield.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/presentation/lecturer/registration/components/radio_button.dart';
import 'package:student_attendance/state/auth/providers/auth_state_provider.dart';
import 'package:student_attendance/state/module/providers/fetch_lecturer_modules_provider.dart';
import 'package:student_attendance/state/providers/radiobutton_provider.dart';
import 'package:student_attendance/state/registrations/notifier/registrations.dart';
import 'package:student_attendance/state/users/providers/user_info_model_provider.dart';
import 'package:student_attendance/widgets/widgets.dart';

class AssessmentFormFields extends HookConsumerWidget {
  static const String routeName = '/formfields';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const AssessmentFormFields(),
    );
  }

  const AssessmentFormFields({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var dimension = Dimensions(context: context);
    final modules = ref.watch(fetchLecturerModulesProvider(authStateProvider));
    var type = ref.watch(radioProvider);
    var module = <String>[];
    modules.when(
        data: (modules) {
          for (var mod in modules) {
            module.add(mod.code);
          }
        },
        error: (error, stack) => null,
        loading: () => null);

    final localizations = MaterialLocalizations.of(context);
    final assessmentTitleHasText = useState(false);
    final moduleHasText = useState(false);

    final moduleController = useTextEditingController();
    final assessmentTitleController = useTextEditingController();
    final dateController =
        useTextEditingController(text: DateTime.now().toString());

    useEffect(
      () {
        moduleController.addListener(
          () {
            moduleHasText.value = moduleController.value.text.isNotEmpty;
          },
        );

        assessmentTitleController.addListener(
          () {
            assessmentTitleHasText.value =
                assessmentTitleController.value.text.isNotEmpty;
          },
        );

        return () {};
      },
      [
        moduleController,
        assessmentTitleController,
      ],
    );

    return Scaffold(
      appBar: StudlyAppBar(
        title: 'Assessment Planner',
        icon: Iconsax.arrow_left_1,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Container(
        margin: EdgeInsets.only(
            left: dimension.horizontalPadding20,
            right: dimension.horizontalPadding20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //Lesson
              StudlyInputField(
                hintText: 'Enter assessment title',
                title: 'Assessment',
                controller: assessmentTitleController,
              ),
              //Description
              SizedBox(height: dimension.sizedBox20),
              //Assessment type
              const RadioButtons(),

              Container(
                padding: EdgeInsets.only(top: dimension.verticalPadding30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.only(left: dimension.horizontalPadding6),
                      child: StudlyTypography(
                        text: 'Select module',
                        fontSize: dimension.font17,
                      ),
                    ),
                    SizedBox(height: dimension.sizedBox10),
                    SearchField(
                      textInputAction: TextInputAction.done,
                      controller: moduleController,
                      suggestions: module
                          .map((e) => SearchFieldListItem(e, child: Text(e)))
                          .toList(),
                      onSuggestionTap: (value) {
                        moduleController.text = value.item;
                      },
                    ),
                  ],
                ),
              ),

              //Date

              StudlyInputField(
                controller: dateController,
                hintText: dateController.value.text,
                title: 'Date',
                widget: IconButton(
                    onPressed: () {
                      getDateFromUser(context: context).then((value) {
                        if (!(value!.difference(DateTime.now()).inDays < 0)) {
                          dateController.text = value.toString();
                        }
                      });
                    },
                    icon: const Icon(
                      Iconsax.calendar,
                    )),
              ),

              SizedBox(
                height: dimension.verticalPadding60,
              ),
              StudlyButton(
                  label: 'Create Assessment',
                  onPressed: assessmentTitleController.text.isNotEmpty &&
                          moduleController.text.isNotEmpty && type.isNotEmpty
                      ? () {
                          String moduleName = '';
                          List<dynamic> programCode = [];
                          modules.whenData((modules) {
                            for (var module in modules) {
                              if (module.code == moduleController.value.text) {
                                moduleName = module.name;
                                programCode.addAll(module.programCode);
                              }
                            }
                          });
                          _addAssessmentWithController(
                              moduleController: moduleController,
                              assessmentTitleController:
                                  assessmentTitleController,
                              assessmentTypeController: type,
                              dateController: dateController,
                              ref: ref,
                              programCode: programCode,
                              moduleName: moduleName,
                              context: context);

                          Navigator.pushNamed(context, '/registration');
                        }
                      : null),
            ],
          ),
        ),
      ),
    );
  }

  Future<DateTime?> getDateFromUser({required BuildContext context}) {
    Future<DateTime?> pickerDate = showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2050),
    );
    return pickerDate;
  }

  Future<void> _addAssessmentWithController(
      {required TextEditingController moduleController,
      required TextEditingController assessmentTitleController,
      required String assessmentTypeController,
      required TextEditingController dateController,
      required WidgetRef ref,
      required List<dynamic> programCode,
      required String moduleName,
      required BuildContext context}) async {
    final user = ref.read(userInfoModelProvider(authStateProvider)).value;
    if (user == null) {
      return;
    }

    final isSent = await ref.read(registrationsProvider.notifier).addAssessment(
          type: assessmentTypeController,
          title: assessmentTitleController.text,
          date: dateController.text,
          attendees: [],
          module: {'code': moduleController.text, 'name': moduleName},
          lecturer: {
            'name': user.name,
            'uid': user.uid,
            'photoUrl': user.photoUrl
          },
          programCodes: programCode,
        );

    if (isSent) {
      moduleController.clear();
      assessmentTitleController.clear();
      dateController.clear();
    }
  }


}
