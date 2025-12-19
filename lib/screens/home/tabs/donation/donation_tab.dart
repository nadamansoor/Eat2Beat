import 'package:eat2beat/models/donation_model.dart';
import 'package:eat2beat/utils/app_routes.dart';
import 'package:flutter/material.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_images.dart';
import '../../../../utils/app_styles.dart';
import '../../../../widgets/custom_text_field.dart';

class DonationTab extends StatelessWidget {
  DonationTab({super.key});
  TextEditingController searchController = TextEditingController();

  //DonationModel model;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;           // 375
    double screenHeight = MediaQuery.of(context).size.height;         // 812
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.light,
        body: Stack(
          children: [
            Image.asset(
              AppImages.pattern,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth*0.04,
                  vertical: screenHeight*0.02
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextFormField(
                      borderSideColor: AppColors.purple50,
                      radius: 16,
                      hintText: "Search",
                      controller: searchController,
                      prefixIcon: Icon(Icons.search , color: AppColors.black,),
                      focusedBorderColor: AppColors.purple,
                    ),
                    SizedBox(height: screenHeight*0.02,),
                    Text("Latest Campaigns" , style: AppStyles.black24Bold.copyWith(
                        fontSize: 20
                    ),),
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
                                AppRoutes.detailDonationRouteName,
                                arguments: DonationModel.donationModel[index]
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
                                      child: Image.asset(AppImages.donatePhoto ,
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
                                    )
                                  ],
                                ),
                                SizedBox(height: screenHeight*0.01,),
                                Row(
                                  children: [
                                    Text("Social Project" ,
                                      style: AppStyles.grey8w400,
                                    ),
                                    SizedBox(width: screenWidth*0.01,),
                                    Icon(Icons.verified,
                                      color: AppColors.purple,
                                      size: 15,
                                    )
                                  ],
                                ),
                                SizedBox(height: screenHeight*0.01,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(DonationModel.donationModel[index].title,
                                      style: AppStyles.black13Bold,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenHeight*0.01,),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: DonationModel.donationModel.length,
                    ),
                    SizedBox(height: screenHeight*0.1,)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}