import 'package:eat2beat/features/charity/charity_donations/controllers/don_charity_contoller.dart';
import 'package:eat2beat/features/charity/charity_donations/models/don_charity_model.dart';
import 'package:eat2beat/features/charity/charity_donations/widgets/don_charity_details.dart';
import 'package:eat2beat/features/charity/charity_donations/widgets/don_empty_state.dart';
import 'package:eat2beat/features/charity/charity_donations/widgets/don_list_title.dart';
import 'package:eat2beat/features/charity/charity_donations/widgets/don_search_field.dart';
import 'package:eat2beat/features/charity/charity_resturants/widgets/colors_res.dart';
import 'package:flutter/material.dart';
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
            child: ctrl.filtered.isEmpty
                ? const EmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: ctrl.filtered.length,
                    itemBuilder: (context, i) {
                      final d = ctrl.filtered[i];
                      return DonationListTile(
                        donation: d,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DonationDetailPage(donation: d),
                          ),
                        ),
                      );
                    },
                  ),
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