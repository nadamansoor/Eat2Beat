import 'package:eat2beat/features/charity/charity_donations/controllers/don_charity_contoller.dart';
import 'package:eat2beat/features/charity/charity_donations/models/don_charity_model.dart';
import 'package:eat2beat/features/charity/charity_donations/widgets/don_charity_details.dart';
import 'package:eat2beat/features/charity/charity_donations/widgets/don_empty_state.dart';
import 'package:eat2beat/features/charity/charity_donations/widgets/don_list_title.dart';
import 'package:eat2beat/features/charity/charity_donations/widgets/don_search_field.dart';
import 'package:eat2beat/features/charity/charity_resturants/widgets/colors_res.dart';
import 'package:eat2beat/features/charity/presentation/cubit/charity_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class DonationsView extends StatelessWidget {
  const DonationsView();

  static const _filters = <(String, DonationStatus?)>[
    ('All', null),
    ('Received', DonationStatus.received),
    ('Pending', DonationStatus.pending),
    ('Cancelled', DonationStatus.cancelled),
  ];

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<DonationsController>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: _appBar(context, ctrl),
      body: Column(
        children: [
          const SizedBox(height: 12),

          // Search field
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: ctrl.isSearchOpen
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: SearchField(onChanged: ctrl.setSearchQuery),
                  )
                : const SizedBox.shrink(),
          ),

          // Filter chips
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final (label, value) = _filters[i];
                final selected = ctrl.filter == value;
                return GestureDetector(
                  onTap: () => ctrl.setFilter(value),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primary
                          : AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(label,
                        style: TextStyle(
                          color: selected
                              ? Colors.white
                              : AppColors.primaryChipText,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        )),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: ctrl.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  )
                : ctrl.filtered.isEmpty
                    ? const EmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 24),
                        itemCount: ctrl.filtered.length,
                        itemBuilder: (context, i) {
                          final d = ctrl.filtered[i];
                          return DonationListTile(
                            donation: d,
                            onViewItems: () {
                              final cubit = ctrl.charityCubit;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: cubit,
                                    child: DonationDetailPage(
                                      donation: d,
                                      charityCubit: cubit,
                                      showRequestButton: true,
                                    ),
                                  ),
                                ),
                              );
                            },
                            onRequestPickup: () {
                              _showRequestPickupDialog(context, ctrl.charityCubit, d);
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  void _showRequestPickupDialog(
      BuildContext context, CharityCubit charityCubit, DonationCharityModel donation) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Request Pickup',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
        content: Text(
            'Are you sure you want to request a pickup for surplus food from "${donation.restaurantName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogCtx); // Pop the confirmation dialog
              // Show loading
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              );
              try {
                await charityCubit.requestPickupDonation(donation.id);
                if (context.mounted) {
                  Navigator.pop(context); // Pop loading
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      title: const Text('Success',
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.w700)),
                      content:
                          const Text('Pickup request submitted successfully!'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('OK',
                              style: TextStyle(fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context); // Pop loading
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to request pickup: $e')),
                  );
                }
              }
            },
            child: const Text('Request',
                style: TextStyle(
                    color: AppColors.primary, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _appBar(
      BuildContext context, DonationsController ctrl) {
    return AppBar(
      backgroundColor: AppColors.scaffoldBg,
      elevation: 0,
      scrolledUnderElevation: 0,
      title: const Text('Donations',
          style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 18)),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            ctrl.isSearchOpen ? Icons.close_rounded : Icons.search_rounded,
            color: AppColors.textPrimary,
          ),
          onPressed: ctrl.toggleSearch,
        ),
      ],
    );
  }
}