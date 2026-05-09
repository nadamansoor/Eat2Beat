import 'package:flutter/material.dart';
import '../../admin_home/const.dart';

class ProfileAvatarSection extends StatelessWidget {
  final String? imagePath;
  final String restaurantName;
  final String email;
  final VoidCallback? onChangPhoto;

  const ProfileAvatarSection({
    super.key,
    this.imagePath,
    required this.restaurantName,
    required this.email,
    this.onChangPhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28),
      color: kCard,
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: kPrimary, width: 2.5),
                  color: const Color(0xFFDBEAFE),
                ),
                child: ClipOval(
                  child: imagePath != null
                      ? Image.asset(imagePath!, fit: BoxFit.cover)
                      : const Icon(Icons.store_rounded,
                          color: kPrimary, size: 42),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: onChangPhoto,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: kPrimary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.camera_alt_rounded,
                        color: Colors.white, size: 14),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            restaurantName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: kText,
            ),
          ),
          const SizedBox(height: 4),
          Text(email,
              style: const TextStyle(fontSize: 13, color: kMuted)),
        ],
      ),
    );
  }
}
