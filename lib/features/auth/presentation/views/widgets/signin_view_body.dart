import 'dart:io';

import 'package:eat2beat/core/utils/app_colors.dart';
import 'package:eat2beat/core/utils/app_images.dart';
import 'package:eat2beat/core/utils/app_routes.dart';
import 'package:eat2beat/core/utils/app_styles.dart';
import 'package:eat2beat/core/widgets/custom_button.dart';
import 'package:eat2beat/core/widgets/custom_password.dart';
import 'package:eat2beat/core/widgets/custom_text.dart';
import 'package:eat2beat/features/auth/presentation/cubits/cubitsignin/signin_cubit.dart';
import 'package:eat2beat/features/auth/presentation/views/widgets/or_divider.dart';
import 'package:eat2beat/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dont_have_account.dart';
import 'social_login_btn.dart';

class signinViewBody extends StatefulWidget {
  const signinViewBody({super.key});

  @override
  State<signinViewBody> createState() => _signinViewBodyState();
}

class _signinViewBodyState extends State<signinViewBody> {
   AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  late String email , password;
  String selectedRole = 'user'; // default role

  final GlobalKey<FormState> FormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //it will be a scroll view
    return  Stack(
  children: [
    Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 300,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/Pattern.png"),
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),
      ),
    ),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: FormKey,
                autovalidateMode: autovalidateMode,
                child: Column(
                  children: [
                    SizedBox(height: 120),
                    Center(
                      child: Text(
                        S.of(context).welcomeBack,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF191919),
                          fontSize: 28,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w700,
                          height: 1.3,
                        ),
                      ),
                    ),
                    SizedBox(height: 36),
                    CustomFormTextField(
                      onSaved: (value) { email = value!; },
                      hintText: S.of(context).enterEmail,
                      textInputType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 16),
                    CustomPasswordField(
                      onSaved: (value) { password = value!; },
                    ),
                    SizedBox(height: 16),
                  Row(
                    children: ['user', 'restaurant', 'charity'].map((role) {
                      final isSelected = selectedRole == role;
                      final int index = ['user', 'restaurant', 'charity'].indexOf(role);
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => selectedRole = role),
                          child: Container(
                            margin: EdgeInsetsDirectional.only(
                              end: index < 2 ? 8 : 0,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF7B61FF)
                                  : const Color(0xFFF0EEFF),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFF7B61FF),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  role == 'user'
                                      ? Icons.person_outline
                                      : role == 'restaurant'
                                          ? Icons.admin_panel_settings_outlined
                                          : Icons.volunteer_activism_outlined,
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF7B61FF),
                                  size: 18,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  role == 'user'
                                      ? S.of(context).userRole
                                      : role == 'restaurant'
                                          ? S.of(context).adminRole
                                          : S.of(context).charityRole,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF7B61FF),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                    SizedBox(height: 16),
              Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.forgetRouteName);
                      },
                      child: Text(
                        S.of(context).forgotPassword,
                        textAlign: TextAlign.center,
                        style: AppStyles.black13Bold.copyWith(
                          color: AppColors.purple50,
                        ),
                      ),
                    ),
                  ],
                ),
                    SizedBox(height: 33),
                    CustomButton(
                      onPressed: () {
                        if (selectedRole == 'charity') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(S.of(context).charityPortalSoon)),
                          );
                          return;
                        }
                        if (FormKey.currentState!.validate()) {
                          FormKey.currentState!.save();
                          context.read<SigninCubit>().SignIn(email, password, selectedRole);
                        } else {
                          autovalidateMode = AutovalidateMode.always;
                          setState(() {});
                        }
                      },
                      text: S.of(context).login,
                    ),
                    SizedBox(height: 33),
                    OrDivider(
                      hintText: S.of(context).orLoginWith,
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SocialLoginBtn(
                          onPressed: () {
                            context.read<SigninCubit>().signInWithFacebook();
                          },
                          image: Assets.imagesFacebookIc,
                          title: '',
                        ),
                        const SizedBox(width: 16),
                        SocialLoginBtn(
                          onPressed: () {
                            if (selectedRole != 'user') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(S.of(context).googleLoginUserOnly)),
                              );
                              return;
                            }
                            context.read<SigninCubit>().signInWithGoogle(selectedRole);
                          },
                          image: Assets.imagesGoogleIc,
                          title: '',
                        ),
                        if (Platform.isIOS) ...[
                          const SizedBox(width: 16),
                          SocialLoginBtn(
                            onPressed: () {},
                            image: Assets.imagesCibApple,
                            title: '',
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          dontHaveAcount(),
          SafeArea(
            top: false,
            child: SizedBox(height: 24),
          ),
        ],
      ),
    ),
  ],
);
  }
}