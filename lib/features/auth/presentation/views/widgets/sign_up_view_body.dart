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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0,),
        child: Form(
          key: FormKey,
          autovalidateMode: autovalidateMode,
          child: Column(
            children: [
              SizedBox(height: 24,),
              // name 
              CustomFormTextField(
                onSaved: (value){
                  name = value!;
                },
                hintText: 'الاسم كامل', 
                textInputType: TextInputType.name),
          
              SizedBox(height: 16,),
          
              // email
              CustomFormTextField(
                 onSaved: (value){
                  email = value!;
                },
                hintText: 'البريد الإلكتروني',
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
                text: 'إنشاء حساب جديد ',
                onPressed:(){
                  if(FormKey.currentState!.validate()){
                    FormKey.currentState!.save();
                    if (isTermsAccepted) {
                        context.read<SignupCubit>().createUserWithEmailAndPassword(
                          email, password, name
                          );
                      }else{
                        BuildErrorBar(context, 'يجب عليك الموافقة علي الشروط و الاحكام');
                      }
                  }else{
                    setState(() {
                      autovalidateMode = AutovalidateMode.always;
                    });
                  }
                }
                ),

              SizedBox(height: 26,),
              HaveAcount(),
            ],
          ),
        ),
      ),
    );
  }
}