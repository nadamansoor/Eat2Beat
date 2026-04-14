import 'package:eat2beat/core/services/get_it_services.dart';
import 'package:eat2beat/features/auth/domain/repo/auth_repo.dart';
import 'package:eat2beat/features/auth/presentation/cubits/cubit_signup/cubit/signup_cubit.dart';
import 'package:eat2beat/features/auth/presentation/views/widgets/signup_view_cons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  static const routeName = 'sign-up';
  @override
  Widget build(BuildContext context) {
    // bloc provider
    return BlocProvider(
      create: (context) => SignupCubit(
        // get it
        getIt<AuthRepo>(),
      ),
      child: Scaffold(
      //  appBar: BuildAppBar(context, title: ' حساب جديد'),
        // bloc builder
        body: signupviewBlocConsumer()
        ),
      );
  }
}
