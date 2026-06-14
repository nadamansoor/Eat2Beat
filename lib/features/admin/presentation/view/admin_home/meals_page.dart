import 'package:eat2beat/features/admin/presentation/view/admin_home/widgets/custom_app_bar.dart';
import 'package:eat2beat/features/admin/presentation/view/admin_home/widgets/food_item_card.dart';
import 'package:eat2beat/features/admin/presentation/view/admin_home/edit_meal_page.dart';
import 'package:eat2beat/features/admin/domain/entities/meal_entity.dart';
import 'package:eat2beat/features/admin/presentation/cubits/meals_cubit/meals_cubit.dart';
import 'package:eat2beat/features/admin/presentation/cubits/meals_cubit/meals_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MealsPage extends StatefulWidget {
  final String restaurantName;
  final String? restaurantImageUrl;

  const MealsPage({
    super.key,
    required this.restaurantName,
    this.restaurantImageUrl,
  });

  @override
  State<MealsPage> createState() => _MealsPageState();
}

class _MealsPageState extends State<MealsPage> {
  FoodCategory _category = FoodCategory.all;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MealEntity> _getFiltered(List<MealEntity> meals) {
    return meals.where((item) {
      if (_category == FoodCategory.vegan && item.category.toLowerCase() != 'vegan') return false;
      if (_category == FoodCategory.protein && item.category.toLowerCase() != 'protein') return false;
      
      if (_searchQuery.isNotEmpty &&
          !item.name.toLowerCase().contains(_searchQuery.toLowerCase())) {
        return false;
      }
      return true;
    }).toList();
  }

  Future<void> _showDeleteConfirmDialog(BuildContext context, MealsCubit cubit, String mealId) async {
    return showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Delete Meal?'),
          content: const Text('Are you sure you want to delete this meal? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                cubit.deleteMeal(mealId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Delete', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _navigateToEdit(BuildContext context, MealsCubit cubit, MealEntity meal) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditMealPage(meal: meal),
      ),
    );
    if (result == true) {
      cubit.loadMeals();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<MealsCubit>();
    final state = cubit.state;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: BlocListener<MealsCubit, MealsState>(
        listener: (context, state) {
          if (state is MealDeleteError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        child: RefreshIndicator(
          onRefresh: () => cubit.loadMeals(),
          color: const Color(0xFF2ECC87),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // Custom App Bar displaying real Restaurant name
              CustomAdminAppbar(
                userName: widget.restaurantName,
                greeting: 'Restaurant Menu Dashboard',
                avatarImagePath: widget.restaurantImageUrl,
                onNotificationTap: () {},
                searchController: _searchController,
                onSearchChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),

              // Sliver category quick filter tabs
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: FoodCategory.values.map((cat) {
                      final isSelected = _category == cat;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _category = cat;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF2ECC87) : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF2ECC87) : const Color(0xFFEEF0F4),
                            ),
                          ),
                          child: Text(
                            cat.name[0].toUpperCase() + cat.name.substring(1),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white : const Color(0xFF1A1D23),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              if (state is MealsLoading || state is MealsInitial)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2ECC87)),
                    ),
                  ),
                )
              else if (state is MealsError)
                SliverFillRemaining(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline_rounded, size: 48, color: Colors.orangeAccent),
                          const SizedBox(height: 12),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 14, color: Color(0xFF9499A5)),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => cubit.loadMeals(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2ECC87),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('Retry', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else if (state is MealsLoaded) ...[
                Builder(
                  builder: (context) {
                    final meals = state.meals;
                    final deletingMealId = state is MealDeleting ? state.mealId : null;
                    final filteredMeals = _getFiltered(meals);

                    if (filteredMeals.isEmpty) {
                      return const SliverFillRemaining(
                        child: Center(
                          child: Text(
                            'No meals found',
                            style: TextStyle(fontSize: 14, color: Color(0xFF9499A5)),
                          ),
                        ),
                      );
                    }

                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, i) {
                          final meal = filteredMeals[i];
                          return FoodItemCard(
                            item: meal,
                            isDeleting: deletingMealId == meal.id,
                            onEdit: () => _navigateToEdit(context, cubit, meal),
                            onDelete: () => _showDeleteConfirmDialog(context, cubit, meal.id),
                            onTap: () {},
                          );
                        },
                        childCount: filteredMeals.length,
                      ),
                    );
                  },
                ),
              ],

              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        ),
      ),
    );
  }
}