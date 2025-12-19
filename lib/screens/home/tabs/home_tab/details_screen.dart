import 'dart:ui';
import 'package:eat2beat/utils/app_colors.dart';
import 'package:eat2beat/utils/app_routes.dart';
import 'package:eat2beat/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import '../../../../models/home_model.dart';
import '../../../../utils/app_images.dart';
import '../../../../utils/app_styles.dart';
import '../../../../widgets/leading_widget.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  int quantity = 1;
  late HomeFoodModel model;
  //late double totalPrice ;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; // 375
    double screenHeight = MediaQuery.of(context).size.height; // 812

    model = ModalRoute.of(context)?.settings.arguments as HomeFoodModel;
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Image.asset(
                      model.image,
                      height: screenHeight * 0.4,
                      width: double.infinity,
                      fit: BoxFit.fill,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.06,
                        vertical: screenHeight * 0.08,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          LeadingWidget(),
                          LeadingWidget(
                            icon: Center(
                              child: Icon(Icons.shopping_cart, size: 20),
                            ),
                            action: () {
                              Navigator.of(context).pushNamed(AppRoutes.chooseDonateRouteName);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(model.title, style: AppStyles.black20Bold),
                      Row(
                        children: [
                          Image.asset(model.restIcon , ),
                          SizedBox(width: screenWidth * 0.02,),
                          Text(model.restName, style: AppStyles.black16w500,),
                          SizedBox(width: screenWidth * 0.02,),
                          TextButton(
                              onPressed: (){},
                              child: Text("view", style: AppStyles.blue16w500,)
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Image.asset(AppImages.rateIcon ,width: 20, height: 20,),
                          SizedBox(width: screenWidth * 0.01,),
                          Text("${model.rate}" , style: AppStyles.grey16w400,),
                          SizedBox(width: screenWidth * 0.06,),
                          Image.asset(AppImages.dotIcon, color: AppColors.grey,),
                          SizedBox(width: screenWidth * 0.06,),
                          Text("\$ ${model.price}", style: AppStyles.grey16w400,),
                          SizedBox(width: screenWidth * 0.06,),
                          Image.asset(AppImages.dotIcon, color: AppColors.grey,),
                          SizedBox(width: screenWidth * 0.06,),
                          Icon(Icons.watch_later_outlined ,
                            color: AppColors.grey,
                            size: 20,
                          ),
                          SizedBox(width: screenWidth * 0.01,),
                          Text(model.time, style: AppStyles.grey16w400,),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Row(
                        children: [
                          Text("Size ", style: AppStyles.black16w500,),
                          SizedBox(width: screenWidth * 0.01,),
                          Container(
                            alignment: Alignment.center,
                            width: screenWidth * 0.085,
                            height: screenHeight*0.044,
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.purple50,
                              borderRadius: BorderRadius.circular(110),
                            ),
                            child: Text(model.size , style: AppStyles.black16w500,),
                          )
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Text("Ingredients", style: AppStyles.black16Bold,),
                      SizedBox(height: screenHeight * 0.01),
                      Text(model.description, style: AppStyles.grey13w400,),
                      SizedBox(height: screenHeight * 0.02),
                      Text("Some Place", style: AppStyles.black16Bold,),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.06,
          vertical: screenHeight * 0.02
        ),
        decoration: BoxDecoration(
          color: Color(0xd9c4b2fc),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text("\$ ${model.price * quantity}" , style: AppStyles.white25Bold,),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth*0.03,
                    vertical: screenHeight * 0.015
                  ),
                  decoration: BoxDecoration(
                    color: Color(0x1a1b1432),
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: Colors.white
                    )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: (){
                          if(quantity > 1){
                            quantity--;
                          }
                          setState(() {

                          });
                        },
                          child: Container(
                              decoration: BoxDecoration(
                                color: Color(0x33f9f7ff),
                                shape: BoxShape.circle
                              ),
                              child: Icon(Icons.remove, color: Colors.white,))),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.03,

                        ),
                        child: Text("$quantity", style: AppStyles.white16Bold,),
                      ),
                      InkWell(
                          onTap: (){

                            setState(() {
                              quantity++;
                            });
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Color(0x33f9f7ff),
                                  shape: BoxShape.circle
                              ),
                              child: Icon(Icons.add, color: Colors.white,))),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: screenHeight * 0.02,),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                      text: "Add To Cart",
                      textStyle: AppStyles.black16Bold.copyWith(
                        color: AppColors.purple,
                      ),
                      borderColor: AppColors.purple,
                      backgroundColor: AppColors.lightPurple,
                      onPressed: (){}
                  ),
                ),

                SizedBox(width: screenWidth * 0.06,),

                Expanded(
                  child: CustomButton(
                      text: "Order Now",
                      textStyle: AppStyles.black16Bold.copyWith(
                        color: AppColors.white,
                      ),
                      backgroundColor: AppColors.purple,
                      onPressed: (){}
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
