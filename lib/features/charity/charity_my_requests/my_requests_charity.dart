import 'package:eat2beat/features/charity/charity_donations/widgets/don_charity_details.dart';
import 'package:eat2beat/features/charity/charity_my_requests/request_details_charity.dart';
import 'package:eat2beat/features/charity/charity_resturants/widgets/colors_res.dart';
import 'package:eat2beat/features/charity/data/models/charity_models.dart';
import 'package:eat2beat/features/charity/presentation/cubit/charity_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyRequestsCharity extends StatefulWidget {
  const MyRequestsCharity({super.key});

  @override
  State<MyRequestsCharity> createState() => _MyRequestsCharityState();
}

class _MyRequestsCharityState extends State<MyRequestsCharity> {
  int _activeSubTab = 0; // 0 = Pickup Requests, 1 = Approved, 2 = Picked Up, 3 = Rejected

  final List<String> _subTabLabels = [
    'Pickup Requests',
    'Approved',
    'Picked Up',
    'Rejected',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'My Requests',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<CharityCubit, CharityState>(
        builder: (context, state) {
          if (state is CharityLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          } else if (state is CharityError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'Error loading requests: ${state.message}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),
            );
          } else if (state is CharityLoaded) {
            final List<PickupRequest> listToShow;
            final String emptyText;
            final String listSrc;

            if (_activeSubTab == 0) {
              listToShow = state.pickupRequests
                  .where((r) => r.pickedUp != 'picked_up' && r.status == 'pending')
                  .toList();
              emptyText = 'No pending pickup requests yet';
              listSrc = 'active';
            } else if (_activeSubTab == 1) {
              listToShow = state.approvedPickups
                  .where((r) => r.pickedUp != 'picked_up' && r.status == 'approved')
                  .toList();
              emptyText = 'No approved pickups yet';
              listSrc = 'approved';
            } else if (_activeSubTab == 2) {
              listToShow = state.pickedUpDonations;
              emptyText = 'No completed pickups yet';
              listSrc = 'picked-up';
            } else {
              listToShow = state.rejectedPickups;
              emptyText = 'No rejected requests yet';
              listSrc = 'rejected';
            }

            return Column(
              children: [
                const SizedBox(height: 8),
                _buildSubTabBar(state),
                const SizedBox(height: 16),
                Expanded(
                  child: RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: () => context.read<CharityCubit>().loadAllData(),
                    child: listToShow.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.5,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.inbox_outlined,
                                        size: 48,
                                        color: AppColors.textSecondary.withOpacity(0.4),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        emptyText,
                                        style: const TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 24),
                            itemCount: listToShow.length,
                            itemBuilder: (context, idx) {
                              final request = listToShow[idx];
                              return _buildRequestRow(context, request, listSrc);
                            },
                          ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSubTabBar(CharityLoaded state) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _subTabLabels.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, idx) {
          final isSelected = _activeSubTab == idx;
          int badgeCount = 0;
          if (idx == 0) {
            badgeCount = state.pickupRequests
                .where((r) => r.pickedUp != 'picked_up' && r.status == 'pending')
                .length;
          } else if (idx == 1) {
            badgeCount = state.approvedPickups
                .where((r) => r.pickedUp != 'picked_up' && r.status == 'approved')
                .length;
          } else if (idx == 2) {
            badgeCount = state.pickedUpDonations.length;
          } else {
            badgeCount = state.rejectedPickups.length;
          }

          return GestureDetector(
            onTap: () {
              setState(() {
                _activeSubTab = idx;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.15)
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.white,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Text(
                    _subTabLabels[idx],
                    style: TextStyle(
                      color: isSelected ? AppColors.primary : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                  if (badgeCount > 0) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$badgeCount',
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.primary,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRequestRow(
    BuildContext context,
    PickupRequest request,
    String src,
  ) {
    Color statusColor;
    String statusLabel;

    if (src == 'picked-up') {
      statusColor = AppColors.statusActive;
      statusLabel = 'Picked Up';
    } else {
      statusColor = request.status == 'approved'
          ? AppColors.statusActive
          : request.status == 'pending'
              ? AppColors.statusPending
              : AppColors.statusInactive;
      statusLabel = request.status.toUpperCase();
    }

    final hasActions = (request.status == 'pending' && src == 'active') ||
        (request.status == 'approved' && src != 'picked-up');

    final code = request.id.length > 6
        ? request.id.substring(request.id.length - 6)
        : request.id;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (routeContext) => BlocProvider.value(
                    value: context.read<CharityCubit>(),
                    child: CharityRequestDetailsPage(
                      request: request,
                      src: src,
                    ),
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: request.donationImgUrl != null &&
                            request.donationImgUrl!.startsWith('http')
                        ? Image.network(
                            request.donationImgUrl!,
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _buildFallbackThumb(),
                          )
                        : _buildFallbackThumb(),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Request #$code',
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                statusLabel,
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        if (request.restaurantName != null) ...[
                          Row(
                            children: [
                              const Icon(Icons.storefront_outlined,
                                  size: 13, color: AppColors.primary),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  request.restaurantName!,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                        ],
                        if (request.description != null) ...[
                          Text(
                            request.description!,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                        ],
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined,
                                size: 12, color: AppColors.textSecondary),
                            const SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                request.pickupLocation ?? 'Location TBD',
                                style: const TextStyle(
                                    color: AppColors.textSecondary, fontSize: 11),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (hasActions) ...[
            const Divider(height: 1, color: AppColors.primaryLight),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  if (request.status == 'pending' && src == 'active') ...[
                    OutlinedButton.icon(
                      onPressed: () => _handleCancel(context, request.id),
                      icon: const Icon(Icons.close_rounded, size: 14),
                      label: const Text('Cancel', style: TextStyle(fontSize: 11)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      ),
                    ),
                  ],
                  if (request.status == 'approved' && src != 'picked-up') ...[
                    ElevatedButton.icon(
                      onPressed: () => _handleConfirmPickup(context, request.id),
                      icon: const Icon(Icons.check_rounded, size: 14),
                      label: const Text('Confirm Pickup', style: TextStyle(fontSize: 11)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        elevation: 0,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFallbackThumb() {
    return Container(
      width: 64,
      height: 64,
      color: AppColors.primaryLight,
      child: const Icon(
        Icons.fastfood_outlined,
        color: AppColors.primary,
        size: 26,
      ),
    );
  }

  void _handleCancel(BuildContext context, String pickupId) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Cancel Request',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
        content: const Text(
            'Are you sure you want to cancel this pickup request?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Keep Request', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogCtx);
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              );
              try {
                await context.read<CharityCubit>().cancelPickupRequest(pickupId);
                if (context.mounted) {
                  Navigator.pop(context); // Pop loading
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Request cancelled successfully!')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context); // Pop loading
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to cancel request: $e')),
                  );
                }
              }
            },
            child: const Text('Cancel Request',
                style: TextStyle(
                    color: Colors.red, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _handleConfirmPickup(BuildContext context, String pickupId) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Confirm Pickup',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
        content: const Text(
            'Are you sure you want to confirm that you have picked up this donation?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogCtx);
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              );
              try {
                await context.read<CharityCubit>().confirmPickupRequest(pickupId);
                if (context.mounted) {
                  Navigator.pop(context); // Pop loading
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pickup confirmed successfully!')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context); // Pop loading
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to confirm pickup: $e')),
                  );
                }
              }
            },
            child: const Text('Confirm',
                style: TextStyle(
                    color: AppColors.primary, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
