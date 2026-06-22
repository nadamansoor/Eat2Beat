import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eat2beat/features/admin/presentation/cubits/admin_donation_cubit/admin_donation_cubit.dart';
import 'package:eat2beat/features/admin/data/models/admin_donation_models.dart';
import 'package:eat2beat/features/admin/presentation/view/admin_home/const.dart';
import 'package:url_launcher/url_launcher.dart';

class CharityProfilePage extends StatefulWidget {
  final String charityId;
  final AdminCharityProfile? initialProfile;

  const CharityProfilePage({
    super.key,
    required this.charityId,
    this.initialProfile,
  });

  @override
  State<CharityProfilePage> createState() => _CharityProfilePageState();
}

class _CharityProfilePageState extends State<CharityProfilePage> {
  AdminCharityProfile? _profile;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.initialProfile != null) {
      _profile = widget.initialProfile;
    } else {
      _fetchProfile();
    }
  }

  Future<void> _fetchProfile() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final cubit = context.read<AdminDonationCubit>();
    final token = await cubit.authRepo.getIdToken();
    if (token == null) {
      setState(() {
        _loading = false;
        _error = 'Unauthorized';
      });
      return;
    }

    final res = await cubit.donationRepo.getCharityProfile(token, widget.charityId);
    res.fold(
      (failure) => setState(() {
        _loading = false;
        _error = failure.message;
      }),
      (profile) => setState(() {
        _loading = false;
        _profile = profile;
      }),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        title: Text(_profile?.name ?? 'Charity Profile', style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: kText,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: kPrimary),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!, style: const TextStyle(color: kRed, fontSize: 16)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchProfile,
              style: ElevatedButton.styleFrom(backgroundColor: kPrimary),
              child: const Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    if (_profile == null) {
      return const Center(
        child: Text('Profile not found'),
      );
    }

    final p = _profile!;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header / Banner Section
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 150,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [kPrimary, Color(0xFF8E87FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              Positioned(
                bottom: -50,
                left: 20,
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                  child: ClipOval(
                    child: p.logoUrl != null && p.logoUrl!.isNotEmpty
                        ? Image.network(
                            p.logoUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => const Icon(Icons.business, size: 50, color: kMuted),
                          )
                        : const Icon(Icons.business, size: 50, color: kMuted),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),

          // Main Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.name,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: kText),
                ),
                if (p.createdAt.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Registered since ${p.createdAt.split("T").first}',
                    style: const TextStyle(color: kMuted, fontSize: 13),
                  ),
                ],
                const SizedBox(height: 20),

                // Description Card
                if (p.description != null && p.description!.isNotEmpty) ...[
                  const Text(
                    'About the Charity',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kText),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: kBorder),
                    ),
                    child: Text(
                      p.description!,
                      style: const TextStyle(fontSize: 14, color: kText, height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Contact details
                const Text(
                  'Contact Information',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kText),
                ),
                const SizedBox(height: 12),
                _buildContactItem(
                  icon: Icons.email_outlined,
                  title: 'Email Address',
                  value: p.email ?? 'Not available',
                  onTap: p.email != null ? () => _launchUrl('mailto:${p.email}') : null,
                ),
                _buildContactItem(
                  icon: Icons.phone_outlined,
                  title: 'Phone Number',
                  value: p.phone ?? 'Not available',
                  onTap: p.phone != null ? () => _launchUrl('tel:${p.phone}') : null,
                ),
                _buildContactItem(
                  icon: Icons.location_on_outlined,
                  title: 'Location / Address',
                  value: p.address ?? 'Not available',
                ),
                _buildContactItem(
                  icon: Icons.language_outlined,
                  title: 'Website',
                  value: p.website ?? 'Not available',
                  onTap: p.website != null ? () => _launchUrl(p.website!) : null,
                  isLink: p.website != null,
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String value,
    VoidCallback? onTap,
    bool isLink = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: kPrimary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: kPrimary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, color: kMuted)),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isLink ? kPrimary : kText,
                      decoration: isLink ? TextDecoration.underline : TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (onTap != null)
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios, size: 14, color: kMuted),
              onPressed: onTap,
            ),
        ],
      ),
    );
  }
}
