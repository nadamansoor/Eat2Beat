
// ─── Upload Photo Box ───────────────────────────────────────────────
import 'dart:io';
import 'package:eat2beat/features/admin/presentation/view/admin_upload/const.dart';
import 'package:flutter/material.dart';

class UploadPhotoBox extends StatelessWidget {
  final VoidCallback? onTap;
  final String? imagePath;
  final String? imageUrl;

  const UploadPhotoBox({
    super.key,
    this.onTap,
    this.imagePath,
    this.imageUrl,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: kUploadBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: kUploadBorder,
            width: 1.5,
            style: BorderStyle.solid,
          ),
        ),
        child: imagePath != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  File(imagePath!),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              )
            : imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (_, __, ___) => _buildPlaceholder(),
                    ),
                  )
                : _buildPlaceholder(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: kCard,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: kPrimary.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.add_photo_alternate_outlined,
            color: kPrimary,
            size: 28,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Upload Meal Photos',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: kText,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'PNG, JPG up to 10MB',
          style: TextStyle(
            fontSize: 12,
            color: kMuted,
          ),
        ),
      ],
    );
  }
}
