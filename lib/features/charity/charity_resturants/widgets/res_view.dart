import 'package:eat2beat/features/charity/charity_resturants/controllers/res_controller.dart';
import 'package:eat2beat/features/charity/charity_resturants/resturants_charity.dart';
import 'package:eat2beat/features/charity/charity_resturants/widgets/colors_res.dart';
import 'package:eat2beat/features/charity/charity_resturants/widgets/res_app_bar.dart';
import 'package:eat2beat/features/charity/charity_resturants/widgets/res_empty_state.dart';
import 'package:eat2beat/features/charity/charity_resturants/widgets/res_filter_bar.dart';
import 'package:eat2beat/features/charity/charity_resturants/widgets/res_list_title.dart';
import 'package:eat2beat/features/charity/charity_resturants/widgets/res_search_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RestaurantsView extends StatelessWidget {
  const RestaurantsView();

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<RestaurantsController>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: buildAppBar(context, ctrl),
      body: Column(
        children: [
          const SizedBox(height: 12),

          // ── Search bar (slides in when toggled) ───────────────────────────
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: ctrl.isSearchOpen
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: SearchField(
                      onChanged: ctrl.setSearchQuery,
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          // ── Filter chips ──────────────────────────────────────────────────
          RestaurantFilterBar(
            selected: ctrl.activeFilter,
            onSelected: ctrl.setFilter,
          ),

          const SizedBox(height: 12),

          // ── Restaurant list ───────────────────────────────────────────────
          Expanded(
            child: ctrl.filteredRestaurants.isEmpty
                ? const EmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: ctrl.filteredRestaurants.length,
                    itemBuilder: (context, index) {
                      final restaurant = ctrl.filteredRestaurants[index];
                      return RestaurantListTile(
                        restaurant: restaurant,
                        onTap: () => ctrl.onRestaurantTap(context, restaurant),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}