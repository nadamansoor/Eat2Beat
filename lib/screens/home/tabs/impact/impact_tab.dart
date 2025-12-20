import 'package:eat2beat/models/total_stat_model.dart';
import 'package:eat2beat/screens/home/tabs/impact/rest_container.dart';
import 'package:eat2beat/screens/home/tabs/impact/statistics_container.dart';
import 'package:eat2beat/utils/app_colors.dart';
import 'package:eat2beat/utils/app_images.dart';
import 'package:eat2beat/utils/app_styles.dart';
import 'package:flutter/material.dart';

class ImpactTab extends StatefulWidget {
  ImpactTab({super.key});

  @override
  State<ImpactTab> createState() => _ImpactTabState();
}

class _ImpactTabState extends State<ImpactTab> {
  List<String> logoPaths = [
    AppImages.mcLogo,
    AppImages.tastuLogo,
    AppImages.kfcLogo,
    AppImages.subwayLogo,
    AppImages.mcLogo,
    AppImages.tastuLogo,
    AppImages.kfcLogo,
    AppImages.subwayLogo
  ];

  List<String> restNames = [
    "McDonald's",
    "Tastu",
    "KFC",
    "Subway",
    "McDonald's",
    "Tastu",
    "KFC",
    "Subway",
  ];

  int selectedIndex = 0;

  late double screenWidth ;

  late double screenHeight;

  late TotalStatsModel statsModel ;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width; // 375
    screenHeight = MediaQuery.of(context).size.height; // 812

    var statsModel = TotalStatsModel.totalStats[selectedIndex];
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.light,
        body: Stack(
          children: [
            Image.asset(AppImages.pattern),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.02,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(AppImages.impactIcon, color: AppColors.black),
                        SizedBox(width: screenWidth * 0.04),
                        Text("Impact", style: AppStyles.black24Bold),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Text(
                      "When you save a meal, you save more than food ,"
                          "thanks for making an impact.",
                      style: AppStyles.black16w500,
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    Container(
                      width: double.infinity,
                      height: screenHeight * 0.06,
                      decoration: BoxDecoration(
                        color: AppColors.lightPurple,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                              child: SizedBox(
                                  child: Center(
                                      child: buildStatContainer(
                                          index: 0,
                                          duration: "Week")))),
                          Container(
                            height: screenHeight * 0.025,
                            width: 2,
                            color: AppColors.purple50,
                          ),
                          Expanded(
                              child: SizedBox(
                                  child: Center(
                                      child: buildStatContainer(
                                          index: 1,
                                          duration: "Month")
                                  ))),
                          Container(
                            height: screenHeight * 0.025,
                            width: 2,
                            color: AppColors.purple50,
                          ),
                          Expanded(
                              child: SizedBox(
                                  child: Center(
                                      child: buildStatContainer(
                                          index: 2,
                                          duration: "Year")))),
                        ],
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.02),
                    Row(
                      children: [
                        Expanded(
                          child: StatisticsContainer(
                            index: selectedIndex,
                            containerColor: AppColors.lightGreen,
                            textColor: AppColors.green800,
                            text: 'Meals Saved',
                            number: statsModel.mealSaved,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.05,),
                        Expanded(
                          child: StatisticsContainer(
                            index: selectedIndex,
                            containerColor: AppColors.purple50,
                            textColor: AppColors.purple800,
                            text: 'Donations Made',
                            number: statsModel.donationMade,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    StatisticsContainer(
                      index: selectedIndex,
                      containerColor: AppColors.possibleYellow,
                      textColor: AppColors.grey800,
                      text: 'Your Orders',
                      number: statsModel.yourOrder,
                      width: screenWidth * 0.43,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04,
                          vertical: screenHeight * 0.005
                      ),
                      height: screenHeight * 0.12,
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Reviews", style: AppStyles.black16Bold,),
                              InkWell(
                                onTap: (){},
                                child: Text("See All" , style: AppStyles.blue14w500,),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Image.asset(AppImages.rateIcon,
                                height: 18, width: 17, fit: BoxFit.fill,),
                              SizedBox(width: screenWidth*0.02,),
                              Text("4.9" , style: AppStyles.grey16Bold,),
                              SizedBox(width: screenWidth*0.05,),
                              Text("Total 100 Reviews" ,
                                style: AppStyles.black13w400,),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight*0.02,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Top Restaurants ", style: AppStyles.black16Bold,),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    SizedBox(
                      height: screenHeight * 0.1,
                      child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return RestContainer(
                              width: screenWidth * 0.128,
                              restName: restNames[index],
                              logoPath: logoPaths[index],
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(width: screenWidth * 0.1,);
                          },
                          itemCount: 8
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.15),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStatContainer({
    required int index,
    required String duration,
  }){
    return InkWell(
      onTap: (){
        setState(() {
          selectedIndex = index ;
        });
      },
      child: selectedIndex == index ? Container(
        margin: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.01,
            vertical: screenHeight * 0.003
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        alignment: Alignment.center,
        child: Text(duration, style: AppStyles.black13w400),
      )
          : Text(duration, style: AppStyles.black13w400),
    );
  }
}