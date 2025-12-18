import 'package:eat2beat/screens/home/tabs/donation/statistics_donate.dart';
import 'package:eat2beat/utils/app_colors.dart';
import 'package:eat2beat/utils/app_images.dart';
import 'package:eat2beat/utils/app_routes.dart';
import 'package:eat2beat/utils/app_styles.dart';
import 'package:eat2beat/widgets/leading_widget.dart';
import 'package:flutter/material.dart';

class DetailsDonation extends StatelessWidget {
  const DetailsDonation({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;           // 375
    double screenHeight = MediaQuery.of(context).size.height;         // 812
    return SafeArea(
      child: Scaffold(
          backgroundColor: AppColors.light,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Image.asset(
                      AppImages.lDonation,
                      height: screenHeight*0.4,
                      width: double.infinity,
                      fit: BoxFit.fill,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.06,
                          vertical: screenHeight*0.05
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          LeadingWidget(),
                          LeadingWidget(
                            icon: Center(child: Icon(Icons.shopping_cart , size: 20,)),
                            action: () {
                              Navigator.pushNamed(context, AppRoutes.chooseDonateRouteName);
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: screenHeight * 0.02,),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Share Your Food, Share Your\nLove" ,
                        style: AppStyles.black20Bold,),
                      SizedBox(height: screenHeight * 0.02,),
                      Row(
                        children: [
                          Text("Social Project" ,
                            style: AppStyles.black16Bold.copyWith(
                              color: Color(0xff36394A),
                            ),),
                          SizedBox(width: screenWidth * 0.03,),
                          Icon(Icons.verified,
                            color: AppColors.purple,
                            size: 15,
                          )
                        ],
                      ),
                      Text("Verified Account" ,
                        style: AppStyles.grey8w400.copyWith(
                          fontSize: 10
                        ),),
                      SizedBox(height: screenHeight * 0.06,),
                      Text("Lorem ipsum dolor sit amet consectetur."
                          " Ultricies ut augue\n amet vel hac. Ut orci adipiscing"
                          " fusce lacus lectus rhoncus.\n Lorem ipsum dolor sit amet,"
                          " consectetur adipiscing elit,sed\n do eiusmod tempor"
                          " incididunt ut labore et dolore magna\n aliqua."
                          " Ut enim ad minim veniam, " ,
                      style: AppStyles.grey13w400,),
                      SizedBox(height: screenHeight * 0.02,),
                      Text("About Charity", style: AppStyles.black16Bold,),
                      SizedBox(height: screenHeight * 0.01,),
                      Text("Lorem ipsum dolor sit amet consectetur."
                          " Ultricies ut augue amet vel hac. Ut orci"
                          " adipiscing fusce lacus lectus rhoncus."
                          " Lorem ipsum dolor sit amet, consectetur"
                          " adipiscing elit,   " ,
                        style: AppStyles.grey13w400,),
                      SizedBox(height: screenHeight * 0.02,),
                      Text("Activities", style: AppStyles.black16Bold,),
                      SizedBox(height: screenHeight * 0.01,),
                      Row(
                        children: [
                          Expanded(
                            child: StatisticsDonate(
                              containerColor: AppColors.lightGreen,
                              textColor: AppColors.green800,
                              text: 'Number of Running Projects',
                              number: 10,
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.05,),
                          Expanded(
                            child: StatisticsDonate(
                              containerColor: AppColors.green300,
                              textColor: AppColors.green800,
                              text: 'Number of Projects Donated',
                              number: 20,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.08,),
                    ],
                  ),
                )
              ],
            ),
          )
      ),
    );
  }
}