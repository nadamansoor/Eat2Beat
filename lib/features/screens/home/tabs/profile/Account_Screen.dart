import 'dart:io';
import 'package:eat2beat/core/services/theme_notifier.dart';
import 'package:eat2beat/features/screens/home/tabs/profile/widgets/build_input.dart';
import 'package:eat2beat/core/utils/app_colors.dart';
import 'package:eat2beat/core/utils/app_images.dart';
import 'package:eat2beat/core/utils/app_styles.dart';
import 'package:eat2beat/core/widgets/circleIcon.dart';
import 'package:eat2beat/core/services/user_profile_notifier.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController phone1Controller;
  late final TextEditingController phone2Controller;
  String? _selectedImagePath;

  @override
  void initState() {
    super.initState();
    final profile = UserProfileNotifier();
    nameController = TextEditingController(text: profile.name);
    emailController = TextEditingController(text: profile.email);
    phone1Controller = TextEditingController(text: profile.phone);
    phone2Controller = TextEditingController(text: profile.phone2);
    _selectedImagePath = profile.profileImagePath;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return ListenableBuilder(
      listenable: ThemeNotifier(),
      builder: (context, child) {
        return Scaffold(
          backgroundColor: AppColors.light,
          body: SafeArea(
            bottom: false,
            child: Stack(
              children: [
                /// Background
                Positioned.fill(
                  child: Image.asset(
                    ThemeNotifier().isDarkMode ? Assets.imagesPattern : Assets.imagesPatternCart,
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
                      GestureDetector(
                        onTap: () async {
                          await UserProfileNotifier().updateProfile(
                            name: nameController.text,
                            email: emailController.text,
                            phone: phone1Controller.text,
                            phone2: phone2Controller.text,
                            profileImagePath: _selectedImagePath ?? "",
                          );
                          if (!context.mounted) return;
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Profile saved successfully!')),
                          );
                        },
                        child: Text(
                          "Save",
                          style: AppStyles.purple,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: height * 0.04),

                  /// Profile Image
                  GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: width * 0.15,
                          backgroundColor: AppColors.purple50,
                          backgroundImage: _selectedImagePath != null && _selectedImagePath!.isNotEmpty
                              ? FileImage(File(_selectedImagePath!)) as ImageProvider
                              : null,
                          child: (_selectedImagePath == null || _selectedImagePath!.isEmpty)
                              ? Icon(
                                  Icons.person,
                                  size: width * 0.15,
                                  color: AppColors.purple,
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 6,
                          right: width * 0.18,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: AppColors.purple800,
                            child: const Icon(
                              Icons.camera_alt,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
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
                          hintText: "01000000000",
                        ),
                        buildInput(
                          title: "Phone 2",
                          controller: phone2Controller,
                          keyboardType: TextInputType.phone,
                          hintText: "01000000000",
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
      },
    );
  }
}
