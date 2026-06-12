import 'package:eat2beat/core/helper/error_bar.dart';
import 'package:eat2beat/core/utils/app_routes.dart';
import 'package:eat2beat/features/auth/presentation/cubits/cubit_signup/cubit/signup_cubit.dart';
import 'package:eat2beat/features/auth/presentation/views/widgets/sign_up_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:eat2beat/core/services/user_profile_notifier.dart';

class signupviewBlocConsumer extends StatelessWidget {
  const signupviewBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return BlocConsumer<SignupCubit, SignupState>(
          listener: (context, state) {
            if (state is SignupSuccess) {
              UserProfileNotifier().updateProfile(
                name: state.userEntity.name,
                email: state.userEntity.email,
                phone: UserProfileNotifier().phone,
                phone2: UserProfileNotifier().phone2,
                profileImagePath: UserProfileNotifier().profileImagePath,
              );
              if (state.role == 'admin') {
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.adminRouteName,
                );
              } else {
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.homeScreenRouteName,
                );
              }
            }
            if (state is SignupError) {
              BuildErrorBar(context, state.message);
            }
          },
          builder: (context, state) {
            return ModalProgressHUD(
              inAsyncCall: state is SignupLoading ? true : false,

              child: SignUpViewbody(),
            );
          },
        );
      },
    );
  }
}
