import 'package:eat2beat/features/charity/charity_resturants/controllers/res_details_controller.dart';
import 'package:eat2beat/features/charity/charity_resturants/widgets/colors_res.dart';
import 'package:eat2beat/features/charity/charity_resturants/widgets/don_details_body.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailView extends StatelessWidget {
  const DetailView();

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<RestaurantDetailController>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: _appBar(context),
      body: () {
        if (ctrl.isLoading) {
          return const Center(
              child: CircularProgressIndicator(color: AppColors.primary));
        }
        if (ctrl.error != null) {
          return Center(
            child: Text(ctrl.error!,
                style: const TextStyle(color: AppColors.textSecondary)),
          );
        }
        return DetailBody(detail: ctrl.detail!, ctrl: ctrl);
      }(),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) => AppBar(
        backgroundColor: AppColors.scaffoldBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Restaurant Details',
          style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz_rounded,
                color: AppColors.textPrimary),
            onPressed: () {}, // TODO: show options bottom sheet
          ),
        ],
      );
}
