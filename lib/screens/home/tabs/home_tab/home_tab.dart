import 'package:eat2beat/models/home_model.dart';
import 'package:eat2beat/models/offers_model.dart';
import 'package:eat2beat/utils/app_colors.dart';
import 'package:eat2beat/utils/app_images.dart';
import 'package:eat2beat/utils/app_routes.dart';
import 'package:eat2beat/utils/app_styles.dart';
import 'package:eat2beat/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatefulWidget {
  HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  TextEditingController searchController = TextEditingController();
  int selectedIndex = 0;

  List<String> categories = [
    "New",
    "Near2You",
    "Popular",
    "Top Rated",
    "Trending",
    "Offers",
    "Pizza",
    "Burgers",
    "Seafood",
    "Desserts",
    "Coffee",
    "Healthy",
    "Asian",
    "Egyptian Food",
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;           // 375
    double screenHeight = MediaQuery.of(context).size.height;         // 812
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.light,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(AppImages.myPhoto),
            ),
            SizedBox(width: screenWidth*0.04,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hello" , style: AppStyles.black13w400,),
                Text("Ahmed Salah" , style: AppStyles.black16Bold,),
              ],
            )
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: screenWidth * 0.02),
            child: Icon(Icons.notifications , color: AppColors.black, size: 25,),
          )
        ],
      ),
      body: Stack(
        children: [
          Image.asset(AppImages.pattern),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth*0.04,
                vertical: screenHeight*0.02
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: screenHeight*0.12,),
                  CustomTextFormField(
                    hintText: "Search",
                    controller: searchController,
                    prefixIcon: Icon(Icons.search , color: AppColors.black,),
                    focusedBorderColor: AppColors.purple,
                  ),
                  SizedBox(height: screenHeight*0.02,),
                  SizedBox(
                    height: screenHeight*0.05,
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: (){
                              selectedIndex = index;
                              setState(() {

                              });
                              print("$selectedIndex");
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth*0.04,
                              ),
                              decoration: BoxDecoration(
                                color: selectedIndex == index ? AppColors.purple
                                    : AppColors.lightPurple,
                                borderRadius: BorderRadius.circular(40),

                              ),
                              child: Text(categories[index],
                                  style: selectedIndex == index ? AppStyles.black16w500.copyWith(
                                    color: AppColors.light,
                                  ): AppStyles.black16w500),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            SizedBox(width: screenWidth * 0.02,),
                        itemCount: categories.length
                    ),
                  ),
                  SizedBox(height: screenHeight*0.02,),
                  GridView.builder(
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      //childAspectRatio: 0.5,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 12,
                      mainAxisExtent: screenHeight*0.28,
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: (){
                          Navigator.of(context).pushNamed(
                              AppRoutes.detailsRouteName ,
                              arguments: HomeFoodModel.mealDetails[index]
                          );
                        },
                        child: Container(
                          width: screenWidth*0.43,
                          //height: screenHeight*0.26,
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth*0.02,
                            vertical: screenHeight*0.01,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(
                                alignment: Alignment.topLeft,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(HomeFoodModel.mealDetails[index].image ,
                                      width: double.infinity,
                                      fit: BoxFit.fill,),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(5)
                                    ),
                                    //padding: EdgeInsets.all(2),
                                    margin: EdgeInsets.all(8),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ImageIcon(
                                          AssetImage(AppImages.rateIcon),
                                          color: AppColors.yellow,),
                                        Padding(
                                          padding: EdgeInsets.only(right: 6.0),
                                          child: Text("${HomeFoodModel.mealDetails[index].rate}",style: AppStyles.grey13w400),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: screenHeight*0.01,),
                              Text(HomeFoodModel.mealDetails[index].description ,
                                style: AppStyles.black13Bold,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("\$ ${HomeFoodModel.mealDetails[index].price}", style: AppStyles.grey13w400,),
                                  ImageIcon(AssetImage(AppImages.dotIcon)),
                                  Icon(Icons.watch_later_outlined ,
                                    color: AppColors.grey,
                                    size: 20,
                                  ),
                                  Text(HomeFoodModel.mealDetails[index].time, style: AppStyles.grey13w400,),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: HomeFoodModel.mealDetails.length,

                  ),
                  SizedBox(height: screenHeight*0.08,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}