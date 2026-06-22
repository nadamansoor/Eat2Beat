
import 'package:eat2beat/features/charity/charity_resturants/models/charity_res_details_model.dart';
import 'package:eat2beat/features/charity/charity_resturants/models/charity_res_model.dart';
import 'package:eat2beat/features/charity/charity_resturants/widgets/colors_res.dart';
import 'package:flutter/material.dart';

class HeroCard extends StatelessWidget {
  final RestaurantDetail detail;
  const HeroCard({required this.detail});

  @override
  Widget build(BuildContext context) {
    final r = detail.restaurant;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: r.imageAsset.startsWith('http')
                ? Image.network(
                    r.imageAsset,
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 72,
                      height: 72,
                      color: AppColors.primaryLight,
                      child: const Icon(Icons.restaurant,
                          color: AppColors.primary, size: 30),
                    ),
                  )
                : Image.asset(
                    r.imageAsset.isNotEmpty ? r.imageAsset : 'assets/images/food.png',
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 72,
                      height: 72,
                      color: AppColors.primaryLight,
                      child: const Icon(Icons.restaurant,
                          color: AppColors.primary, size: 30),
                    ),
                  ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(r.name,
                          style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 16)),
                    ),
                    StatusBadge(status: r.status),
                  ],
                ),
                const SizedBox(height: 5),
                IconRow(
                    icon: Icons.location_on_outlined, text: r.location),
                const SizedBox(height: 4),
                IconRow(
                    icon: Icons.calendar_today_outlined,
                    text: 'Joined ${detail.joinedDate}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StatsRow extends StatelessWidget {
  final RestaurantDetail detail;
  const StatsRow({required this.detail});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        StatCard(
            value: '${detail.restaurant.mealsDoanted}',
            label: 'Meals Donated',
            valueColor: AppColors.primary),
        const SizedBox(width: 10),
        StatCard(
            value: '${detail.mealsThisMonth}',
            label: 'This Month',
            valueColor: AppColors.textPrimary),
        const SizedBox(width: 10),
        StatCard(
            value: '${detail.reliabilityPercent}%',
            label: 'Reliability',
            valueColor: AppColors.primary),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;
  const StatCard(
      {required this.value, required this.label, required this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(14)),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    color: valueColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 22)),
            const SizedBox(height: 4),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;
  const SectionCard(
      {required this.title, required this.child, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title,
                  style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 15)),
              const Spacer(),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class IconRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const IconRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 15, color: AppColors.primary),
        const SizedBox(width: 6),
        Expanded(
          child: Text(text,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 13, height: 1.5)),
        ),
      ],
    );
  }
}

class DonationTile extends StatelessWidget {
  final RecentDonation donation;
  const DonationTile({required this.donation});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: donation.imageAsset.startsWith('http')
                ? Image.network(
                    donation.imageAsset,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 50,
                      height: 50,
                      color: AppColors.primaryLight,
                      child: const Icon(Icons.fastfood_outlined,
                          color: AppColors.primary, size: 22),
                    ),
                  )
                : Image.asset(
                    donation.imageAsset.isNotEmpty ? donation.imageAsset : 'assets/images/food.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 50,
                      height: 50,
                      color: AppColors.primaryLight,
                      child: const Icon(Icons.fastfood_outlined,
                          color: AppColors.primary, size: 22),
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(donation.itemName,
                    style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13)),
                const SizedBox(height: 3),
                Text('${donation.meals} meals  •  ${donation.timeLabel}',
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 11)),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: donation.received
                  ? const Color(0xFFE8F5E9)
                  : const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              donation.received ? 'Received' : 'Pending',
              style: TextStyle(
                color: donation.received
                    ? AppColors.statusActive
                    : AppColors.statusPending,
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final RestaurantStatus status;
  const StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final label = switch (status) {
      RestaurantStatus.active => 'Active',
      RestaurantStatus.pending => 'Pending',
      RestaurantStatus.inactive => 'Inactive',
    };
    final color = switch (status) {
      RestaurantStatus.active => AppColors.statusActive,
      RestaurantStatus.pending => AppColors.statusPending,
      RestaurantStatus.inactive => AppColors.statusInactive,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label,
          style: TextStyle(
              color: color, fontWeight: FontWeight.w600, fontSize: 12)),
    );
  }
}