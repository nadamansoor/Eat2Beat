import 'package:eat2beat/models/home_model.dart';
import 'package:eat2beat/utils/app_colors.dart';
import 'package:eat2beat/utils/app_images.dart';
import 'package:eat2beat/utils/app_routes.dart';
import 'package:eat2beat/utils/app_styles.dart';
import 'package:eat2beat/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  TextEditingController searchController = TextEditingController();

  int selectedIndex = 0;
  bool isSearching = false;

  late List<HomeFoodModel> searchResults;

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
  void initState() {
    super.initState();
    searchResults = [];
  }

  void onSearch(String value) {
    setState(() {
      isSearching = value.isNotEmpty;
      searchResults = HomeFoodModel.mealDetails
          .where((item) =>
              item.description.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
            SizedBox(width: screenWidth * 0.04),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hello", style: AppStyles.black13w400),
                Text("Ahmed Salah", style: AppStyles.black16Bold),
              ],
            )
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: screenWidth * 0.02),
            child: const Icon(Icons.notifications,
                color: AppColors.black, size: 25),
          )
        ],
      ),
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
                children: [
                  SizedBox(height: screenHeight * 0.12),

                  CustomTextFormField(
                    hintText: "Search",
                    controller: searchController,
                    onChanged: onSearch,
                    prefixIcon: const Icon(Icons.search,
                        color: AppColors.black),
                    suffixIcon: isSearching
                        ? IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              searchController.clear();
                              onSearch('');
                            },
                          )
                        : null,
                    focusedBorderColor: AppColors.purple,
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  if (isSearching)
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: searchResults.length,
                      separatorBuilder: (_, __) =>
                          SizedBox(height: screenHeight * 0.015),
                      itemBuilder: (context, index) {
                        final item = searchResults[index];
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  item.image,
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.03),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppStyles.black16Bold,
                                    ),
                                    SizedBox(height: screenHeight * 0.01),
                                    Text("\$ ${item.price}",
                                        style: AppStyles.grey13w400),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.lightPurple,
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.add,
                                      color: AppColors.purple),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

               
                  if (!isSearching) ...[
                    SizedBox(
                      height: screenHeight * 0.05,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        separatorBuilder: (_, __) =>
                            SizedBox(width: screenWidth * 0.02),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.04),
                              decoration: BoxDecoration(
                                color: selectedIndex == index
                                    ? AppColors.purple
                                    : AppColors.lightPurple,
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Text(
                                categories[index],
                                style: selectedIndex == index
                                    ? AppStyles.black16w500
                                        .copyWith(color: AppColors.light)
                                    : AppStyles.black16w500,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.02),

                   
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: HomeFoodModel.mealDetails.length,
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 12,
                        mainAxisExtent: screenHeight * 0.28,
                      ),
                      itemBuilder: (context, index) {
                        final item =
                            HomeFoodModel.mealDetails[index];
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              AppRoutes.detailsRouteName,
                              arguments: item,
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.02,
                              vertical: screenHeight * 0.01,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                Stack(
                                  alignment: Alignment.topLeft,
                                  children: [
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(8),
                                      child: Image.asset(
                                        item.image,
                                        width: double.infinity,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.all(8),
                                      padding:
                                          const EdgeInsets.symmetric(horizontal: 6),
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius:
                                            BorderRadius.circular(5),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ImageIcon(
                                            AssetImage(AppImages.rateIcon),
                                            color: AppColors.yellow,
                                          ),
                                          Text("${item.rate}",
                                              style:
                                                  AppStyles.grey13w400),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: screenHeight * 0.01),
                                Text(
                                  item.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppStyles.black13Bold,
                                ),
                                const Spacer(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text("\$ ${item.price}",
                                        style:
                                            AppStyles.grey13w400),
                                    ImageIcon(
                                        AssetImage(AppImages.dotIcon)),
                                    const Icon(
                                        Icons.watch_later_outlined,
                                        size: 18),
                                    Text(item.time,
                                        style:
                                            AppStyles.grey13w400),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],

                  SizedBox(height: screenHeight * 0.08),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
