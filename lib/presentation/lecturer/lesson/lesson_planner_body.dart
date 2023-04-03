import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:searchfield/searchfield.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/state/auth/providers/auth_state_provider.dart';
import 'package:student_attendance/state/module/providers/fetch_lecturer_modules_provider.dart';
import 'package:student_attendance/state/sessions/model/session.dart';
import 'package:student_attendance/state/sessions/notifier/sessions.dart';
import 'package:student_attendance/state/users/providers/fetch_student_enrolment.dart';
import 'package:student_attendance/state/users/providers/user_info_model_provider.dart';
import 'package:student_attendance/widgets/widgets.dart';


class LessonPlannerBody extends HookConsumerWidget {
  const LessonPlannerBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    var dimension=Dimensions(context: context);

    final modules=ref.watch(fetchLecturerModulesProvider(authStateProvider));
    final localizations = MaterialLocalizations.of(context);
    final lessonTitleHasText=useState(false);
    final lessonDescriptionHasText=useState(false);
    final roomHasText=useState(false);
    final dateHasText=useState(true);
    final startTimeHasText=useState(true);
    final endTimeHasText=useState(true);
    

    double timeValidation=0;


    final moduleController=useTextEditingController();
    final lessonTitleController=useTextEditingController();
    final lessonDescriptionController=useTextEditingController();
    final roomController=useTextEditingController();
    final dateController=useTextEditingController(text:DateTime.now().toString());
    final startTimeController=useTextEditingController(text: localizations.formatTimeOfDay(TimeOfDay.now(),alwaysUse24HourFormat: true));
    final endTimeController=useTextEditingController(text: localizations.formatTimeOfDay(TimeOfDay.now(),alwaysUse24HourFormat: true));


    final enrolment=ref.watch(fetchStudentEnrolmentProvider);
    final List<Map<String,dynamic>> attendance=[];

    useEffect(
          () {
            lessonDescriptionController.value.text;

            lessonTitleController.addListener(() {
              lessonTitleHasText.value = lessonTitleController.value.text.isNotEmpty;
        },);



            lessonDescriptionController.addListener(() {
              lessonDescriptionHasText.value = lessonDescriptionController.value.text.isNotEmpty;
        },);

            roomController.addListener(() {
              roomHasText.value = roomController.value.text.isNotEmpty;
        },);

            dateController.addListener(() {
              dateHasText.value = dateController.value.text.isNotEmpty;
        },);

            startTimeController.addListener(() {
              startTimeHasText.value = startTimeController.value.text.isNotEmpty;
            },);

            endTimeController.addListener(() {
              endTimeHasText.value = endTimeController.value.text.isNotEmpty;
            },);

        return () {};
      },
      [moduleController,lessonTitleController,lessonDescriptionController,roomController,dateController,startTimeController,endTimeController],
    );

    return Container(
      margin: EdgeInsets.only(left: dimension.horizontalPadding20,right: dimension.horizontalPadding20),
      child:SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //Lesson
            StudlyInputField(
              hintText: 'Enter lesson title',
              title: 'Lesson', controller: lessonTitleController, ),
            //Description
            StudlyInputField(
              maxLines: null,
              hintText: 'Enter lesson description',
              title: 'Description', controller: lessonDescriptionController,),


        Container(
          padding: EdgeInsets.only(top: dimension.verticalPadding30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: dimension.horizontalPadding6),
                child: StudlyTypography(text: 'Select module',fontSize: dimension.font17,),
              ),
              SizedBox(height:dimension.sizedBox10),
              modules.when(
                  data: (modules){
                    return SearchField(
                      textInputAction: TextInputAction.done,
                      controller:moduleController,
                      suggestions:modules.map((e) => SearchFieldListItem(e.code, child: Text(e.code))).toList(),
                      onSuggestionTap:(value){moduleController.text=value.item;} ,);
                  },
                  error: (error,stack) => Container(),
                  loading: () => Container()),


            ],
          ),
        ),


            //Room #
            StudlyInputField(
              controller: roomController,
              hintText: 'Enter room #',
              title: 'Room',),
            //Date

            StudlyInputField(
              controller: dateController,
              hintText: dateController.value.text,
              title: 'Date',
              widget: IconButton(
                  onPressed: () {
                    getDateFromUser(context: context)
                      .then((value) {
                        if(!(value!.difference(DateTime.now()).inDays<0))

                          {
                            dateController.text= value.toString();
                          }
                          });
                    },
                  icon: const Icon(Iconsax.calendar,)),),

            //Start time
            StudlyInputField(
              controller: startTimeController,
              hintText: startTimeController.value.text,
              title: 'Start time',
              widget: IconButton(
                  onPressed: (){
                    getTimeFromUser(context: context)
                      .then((value) {
                        timeValidation=toDouble(value!);
                        startTimeController.text= localizations
                        .formatTimeOfDay(value,alwaysUse24HourFormat: true);
                  });
                    },
                  icon: const Icon(Iconsax.clock_1,)),),
            //End time
            StudlyInputField(
              controller: endTimeController,
              hintText: endTimeController.value.text,
              title: 'End time',
              widget: IconButton(
                  onPressed: (){
                    getTimeFromUser(context: context)
                        .then((value) {
                          var validateTime=toDouble(value!) > timeValidation;
                          if(validateTime){
                            endTimeController.text= localizations.formatTimeOfDay(value,alwaysUse24HourFormat: true);
                          }
                        }
                    );
                  },
                  icon: const Icon(Iconsax.clock_1,)),),
            SizedBox(height: dimension.verticalPadding60,),
            StudlyButton(
                label: 'Create Lesson',
                onPressed: lessonTitleController.text.isNotEmpty
                && lessonDescriptionController.text.isNotEmpty
                && roomController.text.isNotEmpty
                && dateController.text.isNotEmpty
                && startTimeController.text.isNotEmpty
                && endTimeController.text.isNotEmpty ?(){
              String moduleName='';
              List<dynamic> programCode=[];
              modules.whenData((modules) {
                for(var module in modules){
                  if(module.code==moduleController.value.text){
                    moduleName=module.name;
                    programCode.addAll(module.programCode);
                  }
                }
              });

              enrolment.whenData((students) {
                for (var student in students){
                  if(programCode.contains(student.code)){
                    attendance.add({
                      'uid':student.uid,
                      'clock_in':'',
                      'clock_out':'',
                    });
                  }
                }

              });

              _addLessonWithController(
                  attendees:attendance ,
                  moduleName: moduleName ,
                  programCode: programCode,
                  moduleController: moduleController,
                  lessonTitleController: lessonTitleController,
                  lessonDescriptionController: lessonDescriptionController,
                  roomController: roomController,
                  dateController: dateController,
                  startTimeController: startTimeController,
                  endTimeController: endTimeController,
                  ref: ref,
                  context: context);
              Navigator.pushNamed(context, '/lecturerTimetable');

            }:null),
          ],
        ),
      ) ,
    );



  }
  Future<DateTime?> getDateFromUser({required BuildContext context}){
    Future<DateTime?> pickerDate=showDatePicker(
      context: context,
      initialDate:DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2050),);
    return pickerDate;

  }
  Future<void> _addLessonWithController({
    required  TextEditingController lessonTitleController,
    required TextEditingController lessonDescriptionController,
    required TextEditingController roomController,
    required TextEditingController dateController,
    required TextEditingController startTimeController,
    required TextEditingController endTimeController,
    required TextEditingController moduleController,
    required WidgetRef ref,
    required List<dynamic> programCode,
    required List<Map<String, dynamic>> attendees,
    required String moduleName,
    required BuildContext context}
      ) async {
    final user = ref.read(userInfoModelProvider(authStateProvider)).value;
    if (user == null) {
      return;
    }

    final isSent = await ref
        .read(sessionsProvider.notifier)
        .addSession(
      title: lessonTitleController.text,
      description: lessonDescriptionController.text,
      room: roomController.text,
      date: dateController.text,
      startTime: startTimeController.text,
      endTime: endTimeController.text,
      attendees:attendees ,
      module: {'code':moduleController.text,'name':moduleName},
      sessionID: Session.generateSessionID(moduleCode:moduleController.value.text,chars: user.uid),
      lecturer: {'name': user.name, 'uid': user.uid,'photoUrl':user.photoUrl},
      programCodes:programCode,
    );

    if (isSent) {
      lessonTitleController.clear();
      lessonDescriptionController.clear();
      moduleController.clear();
      roomController.clear();
      dateController.clear();
      startTimeController.clear();
      endTimeController.clear();

    }
  }

  Future<TimeOfDay?> getTimeFromUser({required BuildContext context}){
    Future<TimeOfDay?> pickerTime=showTimePicker(
        context: context,
        initialTime: TimeOfDay.now());
    return pickerTime;

  }

  double toDouble(TimeOfDay time) => time.hour + time.minute/60.0;


}


