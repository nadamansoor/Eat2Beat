import 'package:eat2beat/core/services/api_service.dart';
import 'package:eat2beat/core/services/get_it_services.dart';
import 'package:eat2beat/features/auth/domain/repo/auth_repo.dart';
import 'package:eat2beat/features/auth/presentation/cubits/cubitsignin/signin_cubit.dart';
import 'package:eat2beat/features/auth/presentation/views/widgets/signin_view_bloc_cons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SignInView extends StatelessWidget {
  const SignInView({super.key});
  static const routeName = 'login';
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SigninCubit(getIt.get<AuthRepo>(), getIt.get<ApiService>()),
      child: Scaffold(
        //appBar: BuildAppBar(context, title: ''),
        body: SigninViewConsumer(),
      ),
    );
  }
}