import 'package:eat2beat/core/helper/error_bar.dart';
import 'package:eat2beat/core/utils/app_routes.dart';
import 'package:eat2beat/core/widgets/custom_prograss_hud.dart';
import 'package:eat2beat/features/auth/presentation/cubits/cubitsignin/signin_cubit.dart';
import 'package:eat2beat/features/auth/presentation/views/widgets/signin_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eat2beat/core/services/user_profile_notifier.dart';

class SigninViewConsumer extends StatelessWidget {
  const SigninViewConsumer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SigninCubit, SigninState>(
      listener: (context, state) {
        if (state is SigninSuccess) {
          UserProfileNotifier().updateProfile(
            name: state.userEntity.name,
            email: state.userEntity.email,
            phone: UserProfileNotifier().phone,
            phone2: UserProfileNotifier().phone2,
            profileImagePath: UserProfileNotifier().profileImagePath,
          );
          String route = AppRoutes.homeRouteName;
          if (state.role == 'admin') {
            route = AppRoutes.adminRouteName;
          }
          Navigator.pushNamedAndRemoveUntil(
              context, route, (route) => false);
        }
        if (state is SigninProfileNotFound) {
          BuildErrorBar(context, state.message);
          Navigator.pushNamed(context, AppRoutes.registerRouteName);
        }
        if (state is SigninError) {
          BuildErrorBar(context, state.message);
        }
      },
      builder: (context, state) {
        return CustomProgressHud(
          isLoading: state is SigninLoading ? true : false,
          child: signinViewBody());
      },
    );
  }
}
