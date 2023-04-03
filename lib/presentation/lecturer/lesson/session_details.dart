import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/presentation/lecturer/lesson/components/lecturer_modalbottom_sheet.dart';
import 'package:student_attendance/state/sessions/model/session.dart';
import 'package:student_attendance/widgets/widgets.dart';

class SessionDetails extends StatelessWidget {
  static const String routeName = '/sessionDetails';

  static Route route({required Session session}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => SessionDetails(
        session: session,
      ),
    );
  }

  const SessionDetails({Key? key, required this.session}) : super(key: key);

  final Session session;

  @override
  Widget build(BuildContext context) {
    var dimension = Dimensions(context: context);
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: double.maxFinite,
          //width: double.maxFinite,
          child: Stack(
            children: [
              Positioned(
                  child: Container(
                height: dimension.containerHeight310,
                color: StudlyColors.backgroundColorBlueAccent,
              )),
              //Navigation
              Positioned(
                left: dimension.horizontalPadding20,
                top: dimension.verticalPadding20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Iconsax.arrow_left_1,
                        size: dimension.containerHeight30,
                        color: StudlyColors.iconColorWhite,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: dimension.horizontalPadding20,
                top: dimension.verticalPadding20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Iconsax.edit,
                        size: dimension.containerHeight24,
                        color: StudlyColors.iconColorWhite,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(40))),
                            backgroundColor: StudlyColors.backgroundColor,
                            context: context,
                            builder: (BuildContext context) {
                              return LecturerModalBottomSheet();
                            });
                      },
                      icon: Icon(
                        Iconsax.barcode,
                        size: dimension.containerHeight24,
                        color: StudlyColors.iconColorWhite,
                      ),
                    ),
                  ],
                ),
              ),
              //Class title
              Positioned(
                  left: dimension.horizontalPadding20,
                  right: dimension.horizontalPadding20,
                  top: dimension.verticalPadding100,
                  child: StudlyTypography(
                    text: session.title,
                    maxLines: null,
                    textOverflow: TextOverflow.visible,
                    fontSize: dimension.font32,
                    color: StudlyColors.typographyWhite,
                  )),

              //module code
              //time and venue
              Positioned(
                  top: dimension.verticalPadding255,
                  left: dimension.horizontalPadding20,
                  right: dimension.horizontalPadding20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconWithText(
                        icon: Iconsax.clock,
                        label: '${session.start} - ${session.end}',
                        iconColor: StudlyColors.typographyWhite,
                        labelColor: StudlyColors.typographyWhite,
                      ),
                      IconWithText(
                        icon: Iconsax.location,
                        label: session.room,
                        labelColor: StudlyColors.typographyWhite,
                        iconColor: StudlyColors.iconColorWhite,
                      )
                    ],
                  )),

              Positioned(
                top: dimension.positionedHeight280,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.only(
                    top: dimension.verticalPadding20,
                    left: dimension.horizontalPadding20,
                    right: dimension.horizontalPadding20,
                  ),
                  decoration: const BoxDecoration(
                      color: StudlyColors.backgroundColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                                height: dimension.containerHeight30,
                                padding: EdgeInsets.only(
                                  left: dimension.horizontalPadding10,
                                  right: dimension.horizontalPadding10,
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                        color: StudlyColors.borderColorGrey)),
                                child: IconWithText(
                                  icon: Iconsax.verify5,
                                  label: session.module['name']!,
                                )),
                          ],
                        ),
                        SizedBox(
                          height: dimension.verticalPadding20,
                        ),
                        Container(
                            height: dimension.containerHeight30,
                            padding: EdgeInsets.only(
                              left: dimension.horizontalPadding10,
                              right: dimension.horizontalPadding10,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                    color: StudlyColors.borderColorGrey)),
                            child: StudlyTypography(
                              text: session.module['code']!,
                              color: StudlyColors.typographyGrey,
                              fontSize: dimension.font15,
                            )),

                        SizedBox(
                          height: dimension.sizedBox20,
                        ),
                        //About class
                        StudlyTypography(
                          text: 'About this lesson',
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(
                          height: dimension.sizedBox10,
                        ),

                        //Course description
                        StudlyTypography(
                            text: session.description,
                            fontSize: dimension.font14,
                            maxLines: null,
                            fontWeight: FontWeight.normal,
                            height: dimension.lineHeight25,
                            textOverflow: TextOverflow.visible),
                        SizedBox(
                          height: dimension.sizedBox30,
                        ),

                        PictureLabel(
                            imageUrl: session.lecturer['photoUrl'],
                            imageHeight: dimension.containerHeight45,
                            fontWeight: FontWeight.w500,
                            labelColor: StudlyColors.typographyDefaultColor,
                            imageWidth: dimension.containerWidth45,
                            label: session.lecturer['name']),
                        SizedBox(
                          height: dimension.sizedBox15,
                        ),
                        const Divider(
                          color: StudlyColors.borderColorGrey,
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
