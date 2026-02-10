import 'package:eat2beat/models/address_model.dart';
import 'package:eat2beat/screens/home/tabs/profile/widgets/Address_Item.dart';
import 'package:eat2beat/utils/app_colors.dart';
import 'package:eat2beat/utils/app_images.dart';
import 'package:eat2beat/utils/app_styles.dart';
import 'package:eat2beat/widgets/circleIcon.dart';
import 'package:flutter/material.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  List<AddressModel> addresses = [
    AddressModel(
      title: "Home",
      details: "2464 Royal Ln. Mesa, New Jersey 45463",
      isSelected: true,
    ),
    AddressModel(
      title: "Grand Mam's House",
      details: "2464 Royal Ln. Mesa, New Jersey 45463",
    ),
    AddressModel(
      title: "Office",
      details: "2464 Royal Ln. Mesa, New Jersey 45463",
    ),
  ];

  void selectAddress(int index) {
    setState(() {
      addresses = addresses
          .asMap()
          .entries
          .map(
            (e) => e.key == index
                ? e.value.copyWith(isSelected: true)
                : e.value.copyWith(isSelected: false),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.light,
        body: Stack(
          children: [
            /// Background
            Positioned.fill(
              child: Image.asset(
                AppImages.PatternCart,
                fit: BoxFit.cover,
              ),
            ),

      Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: height * 0.03),
              Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        circleIcon(
                          icon: Icons.arrow_back_ios_new_rounded,
                          onTap: () => Navigator.pop(context),
                        ),
                        Text(
                          "Save",
                          style: AppStyles.grey13w400,
                        ),
                      ],
                    ),

            SizedBox(height: height * 0.04),

            ...List.generate(
              addresses.length,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AddressItem(
                  address: addresses[index],
                  onTap: () => selectAddress(index),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.add, color: AppColors.purple),
                const SizedBox(width: 8),
                Text("Add Address", style: AppStyles.black16Bold),
              ],
            )
          ],
        ),
      ),
          ],
        ),
      ),
    );
  }
}
