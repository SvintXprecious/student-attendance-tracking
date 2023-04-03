import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/widgets/widgets.dart';




class MenuCard extends StatelessWidget {
  const MenuCard({Key? key,required this.option}) : super(key: key);
  final String option;

  @override
  Widget build(BuildContext context) {
    var dimension=Dimensions(context: context);
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, '/lecturer$option',);
      },
      child: Container(
        padding: EdgeInsets.only(right: dimension.horizontalPadding10),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: StudlyColors.backgroundColorLightGray),
                color: StudlyColors.backgroundColorSlate


              ),
            
            ),
            
            Positioned(
              left: dimension.horizontalPadding40,
              right:dimension.horizontalPadding40,
              top: dimension.verticalPadding80,
              child:StudlyTypography(
                text: option,
                fontSize: dimension.font16,
                textOverflow: TextOverflow.visible,maxLines: null,), ),

            Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: dimension.containerHeight50,
                      width: dimension.containerWidth40,
                      decoration: const BoxDecoration(
                        color: StudlyColors.backgroundColorBlueAccent,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(30),
                          topLeft: Radius.circular(30),),),
                      child: IconButton(
                        onPressed: (){ Navigator.pushNamed(context, '/lecturer$option',);},
                        icon:  Icon(
                          Iconsax.arrow_right_2,
                          size: dimension.font24,
                          color: StudlyColors.iconColorWhite,),
                      ),
                    ),
                  ),




          ],
        ),
      ),
    );
  }
}
