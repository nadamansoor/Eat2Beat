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
  String selectedRole = 'user'; // ✅ القيمة الافتراضية
  late bool isTermsAccepted = false;

  // Restaurant-specific fields
  String restaurantName = '';
  String ownerFullName = '';
  String phone = '';
  String address = '';
  String nationalId = '';

  @override
  Widget build(BuildContext context) {
    return Stack(
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
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                  SizedBox(height: 24),
                  CustomFormTextField(
                    onSaved: (value) {
                      name = value!;
                    },
                    hintText: 'Username',
                    textInputType: TextInputType.name,
                  ),
                  SizedBox(height: 16),
                  CustomFormTextField(
                    onSaved: (value) {
                      email = value!;
                    },
                    hintText: 'Email',
                    textInputType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 16),
                  CustomPasswordField(
                    onSaved: (value) {
                      password = value!;
                    },
                  ),

                  SizedBox(height: 12),

                  // ✅ Restaurant-specific fields (animated)
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child:
                        selectedRole == 'restaurant'
                            ? _buildRestaurantFields()
                            : const SizedBox.shrink(),
                  ),

                  // ✅ Role Selector
                  Row(
                    children:
                        ['user', 'restaurant'].map((role) {
                          final isSelected = selectedRole == role;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => selectedRole = role),
                              child: Container(
                                margin: EdgeInsets.only(
                                  right: role == 'user' ? 8 : 0,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
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
                                          : Icons.admin_panel_settings_outlined,
                                      color:
                                          isSelected
                                              ? Colors.white
                                              : const Color(0xFF7B61FF),
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      role == 'user' ? 'User' : 'Restaurant',
                                      style: TextStyle(
                                        color:
                                            isSelected
                                                ? Colors.white
                                                : const Color(0xFF7B61FF),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
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

                  TermsandConditions(
                    onChanged: (value) {
                      isTermsAccepted = value;
                    },
                  ),
                  SizedBox(height: 30),
                  CustomButton(
                    text: 'Register',
                    onPressed: () {
                      if (FormKey.currentState!.validate()) {
                        FormKey.currentState!.save();
                        if (isTermsAccepted) {
                          if (selectedRole == 'restaurant') {
                            // ✅ Restaurant signup with extra fields
                            context.read<SignupCubit>().createRestaurantAccount(
                              email: email,
                              password: password,
                              userName: name,
                              restaurantName: restaurantName,
                              ownerFullName: ownerFullName,
                              phone: phone,
                              address: address,
                              nationalId: nationalId,
                            );
                          } else {
                            // ✅ Normal user signup — unchanged
                            context
                                .read<SignupCubit>()
                                .createUserWithEmailAndPassword(
                                  email,
                                  password,
                                  name,
                                  selectedRole,
                                );
                          }
                        } else {
                          BuildErrorBar(
                            context,
                            'you must accept the terms and conditions',
                          );
                        }
                      } else {
                        setState(() {
                          autovalidateMode = AutovalidateMode.always;
                        });
                      }
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                  SizedBox(height: 26),
                  HaveAcount(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the extra restaurant verification fields
  Widget _buildRestaurantFields() {
    return Column(
      children: [
        //SizedBox(height: 16),
        CustomFormTextField(
          onSaved: (value) {
            restaurantName = value!;
          },
          hintText: 'Restaurant Name',
          textInputType: TextInputType.name,
        ),
        SizedBox(height: 12),
        CustomFormTextField(
          onSaved: (value) {
            ownerFullName = value!;
          },
          hintText: 'Owner Full Name',
          textInputType: TextInputType.name,
        ),
        SizedBox(height: 12),
        CustomFormTextField(
          onSaved: (value) {
            phone = value!;
          },
          hintText: 'Phone Number',
          textInputType: TextInputType.phone,
        ),
        SizedBox(height: 12),
        CustomFormTextField(
          onSaved: (value) {
            address = value!;
          },
          hintText: 'Restaurant Address',
          textInputType: TextInputType.streetAddress,
        ),
        SizedBox(height: 12),
        CustomFormTextField(
          onSaved: (value) {
            nationalId = value!;
          },
          hintText: 'National ID ',
          textInputType: TextInputType.text,
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
