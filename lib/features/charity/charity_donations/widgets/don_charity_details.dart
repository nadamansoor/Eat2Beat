import 'package:eat2beat/features/charity/charity_donations/models/don_charity_model.dart';
import 'package:eat2beat/features/charity/charity_donations/widgets/don_app_bar.dart';
import 'package:eat2beat/features/charity/charity_donations/widgets/don_info_bar.dart';
import 'package:eat2beat/features/charity/charity_donations/widgets/don_section_title.dart';
import 'package:eat2beat/features/charity/charity_donations/widgets/don_status_chip.dart';
import 'package:eat2beat/features/charity/charity_donations/widgets/statues_badge_bar.dart';
import 'package:eat2beat/features/charity/charity_resturants/widgets/colors_res.dart';
import 'package:eat2beat/features/charity/presentation/cubit/charity_cubit.dart';
import 'package:eat2beat/features/charity/data/models/charity_models.dart';
import 'package:flutter/material.dart';

class DonationDetailPage extends StatefulWidget {
  final DonationCharityModel donation;
  final CharityCubit charityCubit;
  final bool showRequestButton;

  const DonationDetailPage({
    super.key,
    required this.donation,
    required this.charityCubit,
    this.showRequestButton = false,
  });

  @override
  State<DonationDetailPage> createState() => _DonationDetailPageState();
}

class _DonationDetailPageState extends State<DonationDetailPage> {
  late Future<List<DonationItem>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _itemsFuture = widget.charityCubit.charityRepository.getDonationItems(widget.donation.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: CustomScrollView(
        slivers: [
          HeroAppBar(donation: widget.donation),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Status badge
                StatusBadgeRow(status: widget.donation.status),
                const SizedBox(height: 16),

                // Title block
                Text(widget.donation.itemName,
                    style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 22)),
                const SizedBox(height: 6),
                Text(widget.donation.restaurantName,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 14)),
                const SizedBox(height: 6),

                // Date
                Row(
                  children: [
                    Expanded(
                      child: Text(widget.donation.timeLabel,
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 13)),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 20),

                // Pickup details
                if (widget.donation.pickupAddress.isNotEmpty) ...[
                  SectionTitle('Pickup Details'),
                  const SizedBox(height: 12),
                  InfoRow(
                      icon: Icons.location_on_outlined,
                      text: widget.donation.pickupAddress),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 20),
                ],

                // Notes
                if (widget.donation.notes.isNotEmpty) ...[
                  SectionTitle('Notes from Restaurant'),
                  const SizedBox(height: 10),
                  Text(widget.donation.notes,
                      style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          height: 1.6)),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 20),
                ],

                // Items Section
                SectionTitle('Items'),
                const SizedBox(height: 10),
                FutureBuilder<List<DonationItem>>(
                  future: _itemsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.0),
                        child: Center(
                            child: CircularProgressIndicator(
                                color: AppColors.primary)),
                      );
                    } else if (snapshot.hasError) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Failed to load items.',
                          style: TextStyle(color: Colors.red, fontSize: 13),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'No items listed for this donation.',
                          style: TextStyle(
                              color: AppColors.textSecondary, fontSize: 13),
                        ),
                      );
                    } else {
                      final items = snapshot.data!;
                      return Column(
                        children: items
                            .map((item) => ItemCard(item: item))
                            .toList(),
                      );
                    }
                  },
                ),

                if (widget.showRequestButton) ...[
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _handleRequestPickup(context),
                    icon: const Icon(Icons.local_shipping_outlined, size: 18),
                    label: const Text('Request Pickup',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ],
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _handleRequestPickup(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Request Pickup',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
        content: Text(
            'Are you sure you want to request a pickup for surplus food from "${widget.donation.restaurantName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              // Show loading
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              );
              try {
                await widget.charityCubit.requestPickupDonation(widget.donation.id);
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
                        onPressed: () {
                          Navigator.pop(ctx);
                          Navigator.pop(context); // Pop details screen
                        },
                        child: const Text('OK',
                            style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                );
              } catch (e) {
                Navigator.pop(context); // Pop loading
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to request pickup: $e')),
                );
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
}

class ItemCard extends StatelessWidget {
  final DonationItem item;
  const ItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryLight),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: item.donationItemImg.startsWith('http')
                ? Image.network(
                    item.donationItemImg,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildFallback(),
                  )
                : Image.asset(
                    item.donationItemImg.isNotEmpty
                        ? item.donationItemImg
                        : 'assets/images/food.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildFallback(),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.itemName,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                if (item.description != null && item.description!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    item.description!,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Qty: ${item.quantity}',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallback() {
    return Container(
      width: 50,
      height: 50,
      color: AppColors.primaryLight,
      child: const Icon(
        Icons.fastfood_outlined,
        color: AppColors.primary,
        size: 20,
      ),
    );
  }
}

extension DonationStatusLabelExt on DonationStatusChip {
  static String statusLabel(DonationStatus s) => switch (s) {
        DonationStatus.received => 'Received',
        DonationStatus.pending => 'Pending',
        DonationStatus.cancelled => 'Cancelled',
      };
}