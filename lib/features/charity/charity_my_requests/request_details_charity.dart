import 'package:eat2beat/features/charity/charity_donations/widgets/don_charity_details.dart';
import 'package:eat2beat/features/charity/charity_resturants/widgets/colors_res.dart';
import 'package:eat2beat/features/charity/data/models/charity_models.dart';
import 'package:eat2beat/features/charity/presentation/cubit/charity_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CharityRequestDetailsPage extends StatefulWidget {
  final PickupRequest request;
  final String src;

  const CharityRequestDetailsPage({
    super.key,
    required this.request,
    required this.src,
  });

  @override
  State<CharityRequestDetailsPage> createState() => _CharityRequestDetailsPageState();
}

class _CharityRequestDetailsPageState extends State<CharityRequestDetailsPage> {
  late Future<List<DonationItem>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _itemsFuture = context
        .read<CharityCubit>()
        .charityRepository
        .getDonationItems(widget.request.donationId);
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusLabel;

    if (widget.src == 'picked-up') {
      statusColor = AppColors.statusActive;
      statusLabel = 'Picked Up';
    } else {
      statusColor = widget.request.status == 'approved'
          ? AppColors.statusActive
          : widget.request.status == 'pending'
              ? AppColors.statusPending
              : AppColors.statusInactive;
      statusLabel = widget.request.status.toUpperCase();
    }

    final code = widget.request.id.length > 6
        ? widget.request.id.substring(widget.request.id.length - 6)
        : widget.request.id;

    final hasActions = (widget.request.status == 'pending' && widget.src == 'active') ||
        (widget.request.status == 'approved' && widget.src != 'picked-up');

    String dateStr = '';
    try {
      final parsed = DateTime.parse(widget.request.createdAt);
      dateStr = DateFormat('MMM dd, yyyy - hh:mm a').format(parsed);
    } catch (_) {
      dateStr = widget.request.createdAt;
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Request #$code',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Request info card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                statusLabel,
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              dateStr,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        if (widget.request.donationImgUrl != null &&
                            widget.request.donationImgUrl!.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              widget.request.donationImgUrl!,
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        if (widget.request.restaurantName != null) ...[
                          Row(
                            children: [
                              const Icon(Icons.storefront_outlined,
                                  size: 16, color: AppColors.primary),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  widget.request.restaurantName!,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                        if (widget.request.pickupLocation != null) ...[
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined,
                                  size: 15, color: AppColors.textSecondary),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  widget.request.pickupLocation!,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                        if (widget.request.description != null &&
                            widget.request.description!.isNotEmpty) ...[
                          const Divider(height: 24),
                          const Text(
                            'Description',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.request.description!,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Donation items section
                  const Row(
                    children: [
                      Icon(Icons.fastfood_outlined, size: 16, color: AppColors.primary),
                      SizedBox(width: 6),
                      Text(
                        'Donation Items',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  FutureBuilder<List<DonationItem>>(
                    future: _itemsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24.0),
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                              strokeWidth: 2.5,
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return const Text(
                          'Failed to load items.',
                          style: TextStyle(color: Colors.red, fontSize: 13),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text(
                          'No items listed for this request.',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                        );
                      } else {
                        return Column(
                          children: snapshot.data!
                              .map((item) => ItemCard(item: item))
                              .toList(),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          if (hasActions) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 10,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    if (widget.request.status == 'pending' && widget.src == 'active') ...[
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _handleCancel(context, widget.request.id),
                          icon: const Icon(Icons.close_rounded, size: 16),
                          label: const Text('Cancel Request',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red, width: 1.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                    if (widget.request.status == 'approved' && widget.src != 'picked-up') ...[
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _handleConfirmPickup(context, widget.request.id),
                          icon: const Icon(Icons.check_rounded, size: 16),
                          label: const Text('Confirm Pickup',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ],
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
                  Navigator.pop(context); // Pop details page back to list
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
                  Navigator.pop(context); // Pop details page back to list
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
