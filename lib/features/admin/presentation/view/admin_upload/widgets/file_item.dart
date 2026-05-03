
// ─── Uploading File Item ────────────────────────────────────────────
import 'package:eat2beat/features/admin/presentation/view/admin_upload/const.dart';
import 'package:flutter/material.dart';

class UploadingFileItem extends StatelessWidget {
  final String fileName;
  final String fileSize;
  final double progress; // 0.0 to 1.0
  final VoidCallback? onRemove;

  const UploadingFileItem({
    super.key,
    required this.fileName,
    required this.fileSize,
    required this.progress,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final isComplete = progress >= 1.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorder),
      ),
      child: Row(
        children: [
          // File icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: kUploadBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.image_outlined,
              color: kPrimary,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          // Name + progress
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        fileName,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: kText,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isComplete)
                      const Icon(
                        Icons.check_circle_rounded,
                        size: 16,
                        color: kPrimary,
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 4,
                    backgroundColor: kProgressBg,
                    valueColor: const AlwaysStoppedAnimation(kPrimary),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      fileSize,
                      style: const TextStyle(
                        fontSize: 11,
                        color: kMuted,
                      ),
                    ),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 11,
                        color: kPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Remove button
          if (onRemove != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onRemove,
              child: const Icon(
                Icons.close_rounded,
                size: 18,
                color: kMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
