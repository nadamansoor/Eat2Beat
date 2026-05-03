import 'package:eat2beat/features/admin/domain/entities/food_item.dart';
import 'package:eat2beat/features/admin/presentation/view/admin_home/widgets/custom_app_bar.dart';
import 'package:eat2beat/features/admin/presentation/view/admin_home/widgets/food_item_card.dart';
import 'package:flutter/material.dart';


class MealsPage extends StatefulWidget {
  const MealsPage({super.key});

  @override
  State<MealsPage> createState() => _MealsPageState();
}

class _MealsPageState extends State<MealsPage> {
  int _approvalTab = 0;
  FoodCategory _category = FoodCategory.all;
  String _searchQuery = '';

  final List<FoodItem> _meals = const [
    FoodItem(
      id: '1',
      name: 'Caesar Salad Bowl',
      
      calories: 430,
      protein: 22,
      imageAsset: 'assets/imgoffers/food1.png',
      category: FoodCategory.vegan,
      status: ApprovalStatus.approved,
    ),
    FoodItem(
      id: '2',
      name: 'Classic Beef Burger',
      calories: 680,
      protein: 38,
      imageAsset: 'assets/imgoffers/food2.png',
      category: FoodCategory.protein,
      status: ApprovalStatus.approved,
    ),
    FoodItem(
      id: '3',
      name: 'Pasta Primavera',
      calories: 520,
      protein: 18,
      imageAsset: 'assets/imgoffers/food3.png',
      category: FoodCategory.vegan,
      status: ApprovalStatus.pending,
    ),
    FoodItem(
      id: '4',
      name: 'Grilled Chicken Wrap',
      
      calories: 480,
      protein: 42,
      imageAsset: 'assets/imgoffers/food4.png',
      category: FoodCategory.protein,
      status: ApprovalStatus.approved,
    ),
    FoodItem(
      id: '5',
      name: 'Lentil Stew',
      calories: 310,
      protein: 16,
      imageAsset: 'assets/imgoffers/food1.png',
      category: FoodCategory.vegan,
      status: ApprovalStatus.rejected,
    ),
        FoodItem(
      id: '5',
      name: 'Lentil Stew',
      calories: 310,
      protein: 16,
      imageAsset: 'assets/imgoffers/food1.png',
      category: FoodCategory.vegan,
      status: ApprovalStatus.rejected,
    ),
        FoodItem(
      id: '3',
      name: 'Pasta Primavera',
      calories: 520,
      protein: 18,
      imageAsset: 'assets/imgoffers/food3.png',
      category: FoodCategory.vegan,
      status: ApprovalStatus.pending,
    ),
  ];

  List<FoodItem> get _filtered {
    return _meals.where((item) {
      if (_approvalTab == 1 && item.status != ApprovalStatus.pending) return false;
      if (_approvalTab == 2 && item.status != ApprovalStatus.rejected) return false;
      if (_category != FoodCategory.all && item.category != _category) return false;
      if (_searchQuery.isNotEmpty &&
          !item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ) {
        return false;
      }
      return true;
    }).toList();
  }

  int get _totalActive =>
      _meals.where((e) => e.status == ApprovalStatus.approved).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          // ── AppBar (بيستخدم السيرش الموجود عندك جوّاه)
          CustomAdminAppbar(
            userName: 'Admin',       // ← غيريها بالاسم الحقيقي
            greeting: 'Approved Meals',
            onNotificationTap: () {},
          ),

          // ── Empty state
          if (_filtered.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Text(
                  'No meals found',
                  style: TextStyle(fontSize: 14, color: Color(0xFF9499A5)),
                ),
              ),
            ),

          // ── Meals list
          if (_filtered.isNotEmpty)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => FoodItemCard(
                  item: _filtered[i],
                  onTap: () {
                    // TODO: navigate to meal detail
                  },
                ),
                childCount: _filtered.length,
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }
}