import 'package:eat2beat/core/helper/error_bar.dart';
import 'package:eat2beat/core/widgets/custom_button.dart';
import 'package:eat2beat/core/widgets/custom_password.dart';
import 'package:eat2beat/core/widgets/custom_text.dart';
import 'package:eat2beat/features/auth/presentation/cubits/cubit_signup/cubit/signup_cubit.dart';
import 'package:eat2beat/features/auth/presentation/views/widgets/have_an_acc.dart';
import 'package:eat2beat/generated/l10n.dart';
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
  String selectedRole = 'user'; // Default value
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
        Positioned.fill(
          child: Padding(
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
                            S.of(context).registerHeader,
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
                        SizedBox(height: 24),
                        CustomFormTextField(
                          onSaved: (value) {
                            name = value!;
                          },
                          hintText: S.of(context).username,
                          textInputType: TextInputType.name,
                        ),
                        SizedBox(height: 16),
                        CustomFormTextField(
                          onSaved: (value) {
                            email = value!;
                          },
                          hintText: S.of(context).email,
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
                              ['user', 'restaurant', 'charity'].map((role) {
                                final isSelected = selectedRole == role;
                                final int index = ['user', 'restaurant', 'charity'].indexOf(role);
                                return Expanded(
                                  child: GestureDetector(
                                    onTap: () => setState(() => selectedRole = role),
                                    child: Container(
                                      margin: EdgeInsetsDirectional.only(
                                        end: index < 2 ? 8 : 0,
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
                                                : role == 'restaurant'
                                                    ? Icons.admin_panel_settings_outlined
                                                    : Icons.volunteer_activism_outlined,
                                            color:
                                                isSelected
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
                                              color:
                                                  isSelected
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

                        TermsandConditions(
                          onChanged: (value) {
                            isTermsAccepted = value;
                          },
                        ),
                        SizedBox(height: 30),
                        CustomButton(
                          text: S.of(context).register,
                          onPressed: () {
                            if (selectedRole == 'charity') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(S.of(context).charityPortalSoon)),
                              );
                              return;
                            }
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
                                  S.of(context).acceptTermsFirst,
                                );
                              }
                            } else {
                              setState(() {
                                autovalidateMode = AutovalidateMode.always;
                              });
                            }
                          },
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
              HaveAcount(),
              SafeArea(
                top: false,
                child: SizedBox(height: 24),
              ),
            ],
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
          hintText: S.of(context).restaurantName,
          textInputType: TextInputType.name,
        ),
        SizedBox(height: 12),
        CustomFormTextField(
          onSaved: (value) {
            ownerFullName = value!;
          },
          hintText: S.of(context).ownerFullName,
          textInputType: TextInputType.name,
        ),
        SizedBox(height: 12),
        CustomFormTextField(
          onSaved: (value) {
            phone = value!;
          },
          hintText: S.of(context).phoneNumber,
          textInputType: TextInputType.phone,
        ),
        SizedBox(height: 12),
        CustomFormTextField(
          onSaved: (value) {
            address = value!;
          },
          hintText: S.of(context).restaurantAddress,
          textInputType: TextInputType.streetAddress,
        ),
        SizedBox(height: 12),
        CustomFormTextField(
          onSaved: (value) {
            nationalId = value!;
          },
          hintText: S.of(context).nationalId,
          textInputType: TextInputType.text,
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
