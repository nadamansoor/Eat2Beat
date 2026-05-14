import 'package:eat2beat/features/admin/presentation/view/admin_home/widgets/custom_app_bar.dart';

class FoodItem {
  final String id;
  final String name;
  final int calories;
  final int protein;
  final String imageAsset;
  final FoodCategory category;
  final ApprovalStatus status;

  const FoodItem({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.imageAsset,
    required this.category,
    required this.status,
  });
}