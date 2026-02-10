import 'package:eat2beat/models/address_model.dart';
import 'package:eat2beat/utils/app_colors.dart';
import 'package:eat2beat/utils/app_styles.dart';
import 'package:flutter/material.dart';

class AddressItem extends StatelessWidget {
  final AddressModel address;
  final VoidCallback onTap;

  const AddressItem({
    super.key,
    required this.address,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: address.isSelected
                ? AppColors.purple
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(address.title, style: AppStyles.black16Bold),
                  const SizedBox(height: 6),
                  Text(
                    address.details,
                    style: AppStyles.grey16Bold,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              children: [
                Icon(Icons.edit, color: AppColors.purple),
                const SizedBox(height: 12),
                Icon(Icons.delete, color: AppColors.purple),
              ],
            )
          ],
        ),
      ),
    );
  }
}
