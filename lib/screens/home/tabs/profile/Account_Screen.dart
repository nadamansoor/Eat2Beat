import 'package:eat2beat/screens/home/tabs/profile/widgets/build_input.dart';
import 'package:eat2beat/utils/app_colors.dart';
import 'package:eat2beat/utils/app_images.dart';
import 'package:eat2beat/utils/app_styles.dart';
import 'package:eat2beat/widgets/circleIcon.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final TextEditingController nameController =
      TextEditingController(text: "Nada Mansour");
  final TextEditingController emailController =
      TextEditingController(text: "nadamansour1566@gmail.com");
  final TextEditingController phone1Controller =
      TextEditingController(text: "01558591638");
  final TextEditingController phone2Controller =
      TextEditingController(text: "01111111111");

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.light,
        body: Stack(
          children: [
            /// Background
            Positioned.fill(
              child: Image.asset(
                AppImages.PatternCart,
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: Column(
                children: [
                  SizedBox(height: height * 0.03),

                  /// App Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      circleIcon(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () => Navigator.pop(context),
                      ),
                      Text(
                        "Save",
                        style: AppStyles.purple,
                      ),
                    ],
                  ),

                  SizedBox(height: height * 0.04),

                  /// Profile Image
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: width * 0.15,
                        backgroundImage: AssetImage(AppImages.myPhotoNada),
                      ),
                      Positioned(
                        bottom: 6,
                        right: width * 0.18,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: AppColors.purple800,
                          child: Icon(
                            Icons.camera_alt,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: height * 0.05),

                  Expanded(
                    child: ListView(
                      children: [
                        buildInput(
                          title: "Name",
                          controller: nameController,
                        ),
                        buildInput(
                          title: "Email",
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        buildInput(
                          title: "Phone",
                          controller: phone1Controller,
                          keyboardType: TextInputType.phone,
                        ),
                        buildInput(
                          title: "Phone 2",
                          controller: phone2Controller,
                          keyboardType: TextInputType.phone,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
