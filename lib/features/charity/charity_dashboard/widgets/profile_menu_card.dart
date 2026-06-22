import 'package:eat2beat/features/charity/charity_dashboard/widgets/profile_data_model.dart';
import 'package:eat2beat/features/charity/charity_dashboard/widgets/profile_menu_item.dart';
import 'package:flutter/material.dart';

import '../../charity_resturants/widgets/colors_res.dart';

class MenuCard extends StatelessWidget {
  final List<MenuItem> items;
  const MenuCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: items.asMap().entries.map((e) {
          final i = e.key;
          final item = e.value;
          final isLast = i == items.length - 1;
          return Column(
            children: [
              MenuItemTile(item: item),
              if (!isLast)
                Divider(
                  height: 1,
                  indent: 52,
                  endIndent: 16,
                  color: AppColors.primaryLight,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
