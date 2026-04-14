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
                        'Welcome back! Glad\nto see you, Again!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
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
                      hintText: 'Enter your Email',
                      textInputType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 16),
                    CustomPasswordField(
                      onSaved: (value) { password = value!; },
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
                        'Forgot Password?',
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
                        if (FormKey.currentState!.validate()) {
                          FormKey.currentState!.save();
                          context.read<SigninCubit>().SignIn(email, password);
                        } else {
                          autovalidateMode = AutovalidateMode.always;
                          setState(() {});
                        }
                      },
                      text: 'Login',
                    ),
                    SizedBox(height: 33),
                    OrDivider(
                      hintText: 'Or Login with',
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
                            context.read<SigninCubit>().signInWithGoogle();
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
          SizedBox(height: 24),
        ],
      ),
    ),
  ],
);
  }
}