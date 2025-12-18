import 'package:eat2beat/utils/app_colors.dart';
import 'package:flutter/material.dart';
import '../../../../models/home_model.dart';
import '../../../../utils/app_images.dart';
import '../../../../utils/app_styles.dart';
import '../../../../widgets/leading_widget.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; // 375
    double screenHeight = MediaQuery.of(context).size.height; // 812

    HomeFoodModel model = ModalRoute.of(context)?.settings.arguments as HomeFoodModel;
    return Scaffold(
      body: SingleChildScrollView(
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
                    vertical: screenHeight * 0.05,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LeadingWidget(),
                      LeadingWidget(
                        icon: Center(
                          child: Icon(Icons.shopping_cart, size: 20),
                        ),
                        action: () {},
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
    );
  }
}
