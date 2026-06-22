import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eat2beat/features/admin/presentation/cubits/admin_donation_cubit/admin_donation_cubit.dart';
import 'package:eat2beat/features/admin/data/models/admin_donation_models.dart';
import 'package:eat2beat/features/admin/presentation/view/admin_home/const.dart';

class DonationDetailsPage extends StatefulWidget {
  final AdminDonation donation;

  const DonationDetailsPage({super.key, required this.donation});

  @override
  State<DonationDetailsPage> createState() => _DonationDetailsPageState();
}

class _DonationDetailsPageState extends State<DonationDetailsPage> {
  late Future<List<AdminDonationItem>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _itemsFuture = _fetchItems();
  }

  Future<List<AdminDonationItem>> _fetchItems() async {
    final cubit = context.read<AdminDonationCubit>();
    final token = await cubit.authRepo.getIdToken();
    if (token == null) {
      throw Exception('Unauthorized');
    }

    final res = await cubit.donationRepo.getRestaurantDonationItems(token, widget.donation.id);
    return res.fold(
      (failure) => throw Exception(failure.message),
      (items) => items,
    );
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.donation;

    return Scaffold(
      backgroundColor: kBg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Elegant Header with dynamic Image
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: kPrimary,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Donation Details',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black45, blurRadius: 4, offset: Offset(0, 2))],
                ),
              ),
              background: Hero(
                tag: 'donation-img-${d.id}',
                child: d.donationImgUrl.isNotEmpty
                    ? Image.network(
                        d.donationImgUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Container(
                          color: kPrimary.withOpacity(0.2),
                          child: const Icon(Icons.volunteer_activism, size: 80, color: kPrimary),
                        ),
                      )
                    : Container(
                        color: kPrimary.withOpacity(0.2),
                        child: const Icon(Icons.volunteer_activism, size: 80, color: kPrimary),
                      ),
              ),
            ),
          ),

          // Content section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Badge and Date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: d.isAvailable ? kGreenBg : kRedBg,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: d.isAvailable ? kGreen.withOpacity(0.5) : kRed.withOpacity(0.5)),
                        ),
                        child: Text(
                          d.isAvailable ? 'Available' : 'Claimed/Inactive',
                          style: TextStyle(
                            color: d.isAvailable ? kGreen : kRed,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Text(
                        d.createdAt.isNotEmpty ? d.createdAt.split('T').first : '',
                        style: const TextStyle(color: kMuted, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Description
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kText),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    d.description ?? 'No description provided.',
                    style: const TextStyle(fontSize: 14, color: kText, height: 1.5),
                  ),
                  const SizedBox(height: 20),

                  // Pickup Location
                  const Text(
                    'Pickup Location',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kText),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: kPrimary, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          d.pickupLocation ?? 'Not specified',
                          style: const TextStyle(fontSize: 14, color: kText),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Donation Items
                  const Text(
                    'Items Donated',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kText),
                  ),
                  const SizedBox(height: 12),

                  FutureBuilder<List<AdminDonationItem>>(
                    future: _itemsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: CircularProgressIndicator(color: kPrimary),
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Failed to load items: ${snapshot.error}',
                            style: const TextStyle(color: kRed),
                          ),
                        );
                      }

                      final items = snapshot.data ?? [];
                      if (items.isEmpty) {
                        return const Center(
                          child: Text(
                            'No items registered under this donation.',
                            style: TextStyle(color: kMuted, fontStyle: FontStyle.italic),
                          ),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return Card(
                            color: Colors.white,
                            margin: const EdgeInsets.only(bottom: 12),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(color: kBorder),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  // Item Image Thumbnail
                                  Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: kPrimary.withOpacity(0.05),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: item.donationItemImg.isNotEmpty
                                          ? Image.network(
                                              item.donationItemImg,
                                              fit: BoxFit.cover,
                                              errorBuilder: (c, e, s) =>
                                                  const Icon(Icons.fastfood, color: kPrimary, size: 24),
                                            )
                                          : const Icon(Icons.fastfood, color: kPrimary, size: 24),
                                    ),
                                  ),
                                  const SizedBox(width: 16),

                                  // Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.itemName,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: kText,
                                          ),
                                        ),
                                        if (item.description != null && item.description!.isNotEmpty) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            item.description!,
                                            style: const TextStyle(fontSize: 12, color: kMuted),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),

                                  // Quantity Badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: kPrimary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'Qty: ${item.quantity}',
                                      style: const TextStyle(
                                        color: kPrimary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
