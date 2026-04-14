import 'package:eat2beat/core/helper/error_bar.dart';
import 'package:eat2beat/core/widgets/custom_button.dart';
import 'package:eat2beat/core/widgets/custom_password.dart';
import 'package:eat2beat/core/widgets/custom_text.dart';
import 'package:eat2beat/features/auth/presentation/cubits/cubit_signup/cubit/signup_cubit.dart';
import 'package:eat2beat/features/auth/presentation/views/widgets/have_an_acc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'terms_and_cond.dart';

class SignUpViewbody extends StatefulWidget {
  const SignUpViewbody({super.key});

  @override
  State<SignUpViewbody> createState() => _SignUpViewbodyState();
}

class _SignUpViewbodyState extends State<SignUpViewbody> {
  final GlobalKey<FormState> FormKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

 String email = '';
String password = '';
String name = '';
 late bool isTermsAccepted = false ;
  @override
  Widget build(BuildContext context) {
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
    ),SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0,),
        child: Form(
          key: FormKey,
          autovalidateMode: autovalidateMode,
          child: Column(
            children: [
              SizedBox(height: 120),
                    Center(
                      child: Text(
                        'Hello! Register to get\nstarted',
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
              SizedBox(height: 24,),
              // name 
              CustomFormTextField(
                onSaved: (value){
                  name = value!;
                },
                hintText: 'Username', 
                textInputType: TextInputType.name),
          
              SizedBox(height: 16,),
          
              // email
              CustomFormTextField(
                 onSaved: (value){
                  email = value!;
                },
                hintText: 'Email',
                 textInputType: TextInputType.emailAddress),
          
              SizedBox(height: 16,),  
          
              // password
              CustomPasswordField(
                 onSaved: (value){
                      password = value!;
                      },
              ),
            
              SizedBox(height: 16,),
          
              TermsandConditions(
                onChanged: (value) {                 
                    isTermsAccepted = value;
                  
                },
              ),
              SizedBox(height: 30,),
              CustomButton(
                text: 'Register',
                onPressed:(){
                  if(FormKey.currentState!.validate()){
                    FormKey.currentState!.save();
                    if (isTermsAccepted) {
                        context.read<SignupCubit>().createUserWithEmailAndPassword(
                          email, password, name
                          );
                      }else{
                        BuildErrorBar(context, 'you must accept the terms and conditions');
                      }
                  }else{
                    setState(() {
                      autovalidateMode = AutovalidateMode.always;
                    });
                  }
                }
                ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.27),
              SizedBox(height: 26,),
              HaveAcount(),
            ],
          ),
        ),
      ),
    ),
  ],
    );
  }
}