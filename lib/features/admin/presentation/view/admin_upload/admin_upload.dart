import 'package:eat2beat/core/widgets/custom_prograss_hud.dart';
import 'package:eat2beat/core/services/get_it_services.dart';
import 'package:eat2beat/features/admin/presentation/view/admin_upload/widgets/image_upload_box.dart';
import 'package:eat2beat/features/admin/presentation/view/admin_upload/widgets/label_section.dart';
import 'package:eat2beat/features/admin/presentation/view/admin_upload/widgets/sumbit_btn.dart';
import 'package:eat2beat/features/admin/presentation/view/admin_upload/widgets/upload_text_field.dart';
import 'package:eat2beat/features/admin/presentation/view/admin_upload/widgets/uploas_app_bar.dart';
import 'package:eat2beat/features/admin/presentation/cubits/add_meal_cubit/add_meal_cubit.dart';
import 'package:eat2beat/features/admin/presentation/cubits/add_meal_cubit/add_meal_state.dart';
import 'package:eat2beat/features/admin/domain/usecases/add_meal_usecase.dart';
import 'package:eat2beat/features/admin/domain/usecases/add_offer_usecase.dart';
import 'package:eat2beat/features/admin/domain/usecases/get_restaurant_meals_usecase.dart';
import 'package:eat2beat/features/admin/domain/entities/meal_entity.dart';
import 'package:eat2beat/features/auth/domain/repo/auth_repo.dart';
import 'package:eat2beat/features/admin/presentation/view/admin_upload/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminUploadPage extends StatefulWidget {
  final VoidCallback? onMealPublished;
  const AdminUploadPage({super.key, this.onMealPublished});

  @override
  State<AdminUploadPage> createState() => _AdminUploadPageState();
}

class _AdminUploadPageState extends State<AdminUploadPage> {
  // Toggle Mode
  bool _isUploadMeal = true;

  // Meal Form Fields
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _expiryController = TextEditingController();

  String? _selectedCategory;
  String? _selectedCuisine;
  final List<String> _selectedTags = [];

  // Offer Form Fields
  MealEntity? _linkedMeal;
  final _offerTitleController = TextEditingController();
  final _offerDescriptionController = TextEditingController();
  final _offerOriginalPriceController = TextEditingController();
  final _offerPriceController = TextEditingController();
  final _offerQuantityController = TextEditingController();
  final _offerStartsAtController = TextEditingController();
  final _offerExpiresAtController = TextEditingController();

  String? _offerSelectedCategory;
  String? _offerSelectedCuisine;
  final List<String> _offerSelectedTags = [];
  String? _offerStartsAt;
  String? _offerExpiresAt;
  bool _offerIsActive = true;
  String? _linkedMealImageUrl;

  final List<Map<String, String>> categoryOptions = const [
    {'value': 'burgers', 'labelEn': 'Burgers', 'labelAr': 'برجر'},
    {'value': 'pizza', 'labelEn': 'Pizza', 'labelAr': 'بيتزا'},
    {'value': 'fried_chicken', 'labelEn': 'Fried Chicken', 'labelAr': 'دجاج مقلي'},
    {'value': 'shawarma', 'labelEn': 'Shawarma', 'labelAr': 'شاورما'},
    {'value': 'grills', 'labelEn': 'Grills', 'labelAr': 'مشويات'},
    {'value': 'sandwiches', 'labelEn': 'Sandwiches', 'labelAr': 'سندوتشات'},
    {'value': 'wraps', 'labelEn': 'Wraps', 'labelAr': 'لفائف'},
    {'value': 'koshary', 'labelEn': 'Koshary', 'labelAr': 'كشري'},
    {'value': 'pasta', 'labelEn': 'Pasta', 'labelAr': 'معكرونة'},
    {'value': 'rice_bowls', 'labelEn': 'Rice Bowls', 'labelAr': 'أطباق أرز'},
    {'value': 'salads', 'labelEn': 'Salads', 'labelAr': 'سلطات'},
    {'value': 'soups', 'labelEn': 'Soups', 'labelAr': 'شوربة'},
    {'value': 'breakfast', 'labelEn': 'Breakfast', 'labelAr': 'فطور'},
    {'value': 'desserts', 'labelEn': 'Desserts', 'labelAr': 'حلويات'},
    {'value': 'bakery', 'labelEn': 'Bakery', 'labelAr': 'مخبوزات'},
    {'value': 'coffee', 'labelEn': 'Coffee', 'labelAr': 'قهوة'},
    {'value': 'drinks', 'labelEn': 'Drinks', 'labelAr': 'مشروبات'},
    {'value': 'snacks', 'labelEn': 'Snacks', 'labelAr': 'مقبلات / تسالي'},
    {'value': 'seafood_meals', 'labelEn': 'Seafood Meals', 'labelAr': 'مأكولات بحرية'},
    {'value': 'healthy_meals', 'labelEn': 'Healthy Meals', 'labelAr': 'وجبات صحية'},
    {'value': 'crepes', 'labelEn': 'Crepes', 'labelAr': 'كريب'},
    {'value': 'waffles', 'labelEn': 'Waffles', 'labelAr': 'وافل'},
    {'value': 'ice_cream', 'labelEn': 'Ice Cream', 'labelAr': 'آيس كريم'},
    {'value': 'hot_dogs', 'labelEn': 'Hot Dogs', 'labelAr': 'هوت دوج'},
    {'value': 'manakish', 'labelEn': 'Manakish', 'labelAr': 'مناقيش'},
  ];

  final List<Map<String, String>> cuisineOptions = const [
    {'value': 'american', 'labelEn': 'American', 'labelAr': 'أمريكي'},
    {'value': 'egyptian', 'labelEn': 'Egyptian', 'labelAr': 'مصري'},
    {'value': 'syrian', 'labelEn': 'Syrian', 'labelAr': 'سوري'},
    {'value': 'italian', 'labelEn': 'Italian', 'labelAr': 'إيطالي'},
    {'value': 'levant', 'labelEn': 'Levant', 'labelAr': 'شامي'},
    {'value': 'turkish', 'labelEn': 'Turkish', 'labelAr': 'تركي'},
    {'value': 'indian', 'labelEn': 'Indian', 'labelAr': 'هندي'},
    {'value': 'mexican', 'labelEn': 'Mexican', 'labelAr': 'مكسيكي'},
    {'value': 'asian', 'labelEn': 'Asian', 'labelAr': 'آسيوي'},
    {'value': 'chinese', 'labelEn': 'Chinese', 'labelAr': 'صيني'},
    {'value': 'japanese', 'labelEn': 'Japanese', 'labelAr': 'ياباني'},
    {'value': 'international', 'labelEn': 'International', 'labelAr': 'عالمي'},
  ];

  final List<Map<String, String>> tagOptions = const [
    {'value': 'spicy', 'labelEn': 'Spicy', 'labelAr': 'حار'},
    {'value': 'breakfast', 'labelEn': 'Breakfast', 'labelAr': 'فطور'},
    {'value': 'healthy', 'labelEn': 'Healthy', 'labelAr': 'صحي'},
    {'value': 'budget_friendly', 'labelEn': 'Budget Friendly', 'labelAr': 'اقتصادي'},
    {'value': 'popular', 'labelEn': 'Popular', 'labelAr': 'شائع'},
    {'value': 'high_protein', 'labelEn': 'High Protein', 'labelAr': 'بروتين عالي'},
    {'value': 'low_calorie', 'labelEn': 'Low Calorie', 'labelAr': 'سعرات حرارية منخفضة'},
    {'value': 'vegetarian', 'labelEn': 'Vegetarian', 'labelAr': 'نباتي'},
    {'value': 'vegan', 'labelEn': 'Vegan', 'labelAr': 'نباتي صرف'},
    {'value': 'kids_friendly', 'labelEn': 'Kids Friendly', 'labelAr': 'مناسب للأطفال'},
    {'value': 'family_meal', 'labelEn': 'Family Meal', 'labelAr': 'وجبة عائلية'},
    {'value': 'sweet', 'labelEn': 'Sweet', 'labelAr': 'حلو'},
    {'value': 'savory', 'labelEn': 'Savory', 'labelAr': 'مالح'},
    {'value': 'cheesy', 'labelEn': 'Cheesy', 'labelAr': 'غني بالجبن'},
    {'value': 'crispy', 'labelEn': 'Crispy', 'labelAr': 'مقرمش'},
    {'value': 'grilled', 'labelEn': 'Grilled', 'labelAr': 'مشوي'},
    {'value': 'fried', 'labelEn': 'Fried', 'labelAr': 'مقلي'},
    {'value': 'cold_drink', 'labelEn': 'Cold Drink', 'labelAr': 'مشروب بارد'},
    {'value': 'hot_drink', 'labelEn': 'Hot Drink', 'labelAr': 'مشروب ساخن'},
    {'value': 'late_night', 'labelEn': 'Late Night', 'labelAr': 'وجبة ليلية'},
  ];

  void _onLinkedMealChanged(MealEntity? meal) {
    setState(() {
      _linkedMeal = meal;
      if (meal != null) {
        _offerTitleController.text = meal.name;
        _offerDescriptionController.text = meal.description;
        _offerOriginalPriceController.text = meal.price.toStringAsFixed(2);
        _offerPriceController.text = meal.price.toStringAsFixed(2);
        _offerSelectedCategory = meal.category;
        _offerSelectedCuisine = meal.cuisine;
        _offerSelectedTags.clear();
        if (meal.tags != null) {
          _offerSelectedTags.addAll(meal.tags!);
        }
        _linkedMealImageUrl = meal.imageUrl;
      } else {
        _offerTitleController.clear();
        _offerDescriptionController.clear();
        _offerOriginalPriceController.clear();
        _offerPriceController.clear();
        _offerSelectedCategory = null;
        _offerSelectedCuisine = null;
        _offerSelectedTags.clear();
        _linkedMealImageUrl = null;
      }
    });
  }

  Future<void> _pickDateTime(BuildContext context, bool isStart) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null) return;

    if (!context.mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;

    final combined = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    setState(() {
      final formatted = combined.toIso8601String().substring(0, 16);
      if (isStart) {
        _offerStartsAt = formatted;
        _offerStartsAtController.text = formatted;
      } else {
        _offerExpiresAt = formatted;
        _offerExpiresAtController.text = formatted;
      }
    });
  }

  void _showTagsMultiSelectDialog(BuildContext context, bool forOffer) {
    showModalBottomSheet(
      context: context,
      backgroundColor: kCard,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        final currentTags = forOffer ? _offerSelectedTags : _selectedTags;
        return StatefulBuilder(
          builder: (stContext, setSheetState) {
            return Container(
              height: MediaQuery.of(sheetContext).size.height * 0.6,
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(sheetContext).padding.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Tags',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kText),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: tagOptions.length,
                      itemBuilder: (context, index) {
                        final tag = tagOptions[index];
                        final isSelected = currentTags.contains(tag['value']);
                        return CheckboxListTile(
                          title: Text(tag['labelEn']!, style: const TextStyle(color: kText)),
                          value: isSelected,
                          activeColor: kPrimary,
                          onChanged: (bool? checked) {
                            setSheetState(() {
                              if (checked == true) {
                                currentTags.add(tag['value']!);
                              } else {
                                currentTags.remove(tag['value']!);
                              }
                            });
                            setState(() {});
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(sheetContext),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        'Done',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _expiryController.dispose();

    _offerTitleController.dispose();
    _offerDescriptionController.dispose();
    _offerOriginalPriceController.dispose();
    _offerPriceController.dispose();
    _offerQuantityController.dispose();
    _offerStartsAtController.dispose();
    _offerExpiresAtController.dispose();
    super.dispose();
  }

  void _clearForm(AddMealCubit cubit) {
    _nameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _quantityController.clear();
    _expiryController.clear();

    _offerTitleController.clear();
    _offerDescriptionController.clear();
    _offerOriginalPriceController.clear();
    _offerPriceController.clear();
    _offerQuantityController.clear();
    _offerStartsAtController.clear();
    _offerExpiresAtController.clear();

    setState(() {
      _selectedCategory = null;
      _selectedCuisine = null;
      _selectedTags.clear();

      _linkedMeal = null;
      _offerSelectedCategory = null;
      _offerSelectedCuisine = null;
      _offerSelectedTags.clear();
      _offerStartsAt = null;
      _offerExpiresAt = null;
      _offerIsActive = true;
      _linkedMealImageUrl = null;
    });
    cubit.reset();
  }

  void _onSubmit(BuildContext context, AddMealCubit cubit) {
    if (_isUploadMeal) {
      final name = _nameController.text.trim();
      final category = _selectedCategory ?? '';
      final description = _descriptionController.text.trim();
      final priceStr = _priceController.text.trim();
      final quantityStr = _quantityController.text.trim();
      final expiryTime = _expiryController.text.trim();

      if (name.isEmpty || priceStr.isEmpty || category.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill in name, category, and price!'),
            backgroundColor: Colors.orangeAccent,
          ),
        );
        return;
      }

      if (cubit.pickedImageBase64 == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please pick a meal image before publishing.'),
            backgroundColor: Colors.orangeAccent,
          ),
        );
        return;
      }

      final price = double.tryParse(priceStr) ?? 0.0;
      final quantity = int.tryParse(quantityStr) ?? 1;

      cubit.addMeal(
        name: name,
        description: description,
        price: price,
        quantity: quantity,
        expiryTime: expiryTime,
        category: category,
        cuisine: _selectedCuisine,
        tags: _selectedTags.isEmpty ? null : _selectedTags,
      );
    } else {
      final title = _offerTitleController.text.trim();
      final originalPriceStr = _offerOriginalPriceController.text.trim();
      final offerPriceStr = _offerPriceController.text.trim();
      final quantityStr = _offerQuantityController.text.trim();

      if (title.isEmpty || originalPriceStr.isEmpty || offerPriceStr.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill in Title, Original Price, and Offer Price!'),
            backgroundColor: Colors.orangeAccent,
          ),
        );
        return;
      }

      final originalPrice = double.tryParse(originalPriceStr) ?? 0.0;
      final offerPrice = double.tryParse(offerPriceStr) ?? 0.0;
      final quantity = int.tryParse(quantityStr);

      if (offerPrice > originalPrice) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Offer price must be less than or equal to original price!'),
            backgroundColor: Colors.orangeAccent,
          ),
        );
        return;
      }

      cubit.addOffer(
        mealId: _linkedMeal?.id,
        title: title,
        description: _offerDescriptionController.text.trim().isEmpty 
            ? null 
            : _offerDescriptionController.text.trim(),
        offerImgUrl: _linkedMealImageUrl,
        originalPrice: originalPrice,
        offerPrice: offerPrice,
        quantity: quantity,
        isActive: _offerIsActive,
        category: _offerSelectedCategory,
        cuisine: _offerSelectedCuisine,
        tags: _offerSelectedTags.isEmpty ? null : _offerSelectedTags,
        startsAt: _offerStartsAt,
        expiresAt: _offerExpiresAt,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddMealCubit>(
      create: (_) => AddMealCubit(
        authRepo: getIt<AuthRepo>(),
        addMealUseCase: getIt<AddMealUseCase>(),
        addOfferUseCase: getIt<AddOfferUseCase>(),
        getMealsUseCase: getIt<GetRestaurantMealsUseCase>(),
      )..fetchMeals(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: const AdminUploadAppBar(),
        body: BlocConsumer<AddMealCubit, AddMealState>(
          listener: (context, state) {
            if (state is AddMealSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Meal published successfully!'),
                  backgroundColor: Color(0xFF3DDC97),
                ),
              );
              _clearForm(context.read<AddMealCubit>());
              widget.onMealPublished?.call();
            } else if (state is AddOfferSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Offer published successfully!'),
                  backgroundColor: Color(0xFF3DDC97),
                ),
              );
              _clearForm(context.read<AddMealCubit>());
              widget.onMealPublished?.call();
            } else if (state is AddMealError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          },
          builder: (context, state) {
            final cubit = context.read<AddMealCubit>();
            final isLoading = state is AddMealLoading;
            final pickedPath = cubit.pickedImagePath;

            return CustomProgressHud(
              isLoading: isLoading,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Mode Toggle Selector
                    Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: kBorder.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _isUploadMeal = true;
                                  // Reset picked image when switching tabs
                                  cubit.reset();
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: _isUploadMeal ? kPrimary : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Upload Meal',
                                  style: TextStyle(
                                    color: _isUploadMeal ? Colors.white : kMuted,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _isUploadMeal = false;
                                  // Reset picked image when switching tabs
                                  cubit.reset();
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: !_isUploadMeal ? kPrimary : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Upload Offer',
                                  style: TextStyle(
                                    color: !_isUploadMeal ? Colors.white : kMuted,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (_isUploadMeal) ...[
                      // IMAGE UPLOAD BOX
                      UploadPhotoBox(
                        imagePath: pickedPath,
                        onTap: () => cubit.pickImage(),
                      ),
                      const SizedBox(height: 24),

                      // Meal Details Section Label
                      const SectionLabel(text: 'Meal Details'),
                      const SizedBox(height: 10),

                      // Fields
                      UploadTextField(
                        hint: 'Meal name...',
                        controller: _nameController,
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: kCard,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: kBorder),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField<String>(
                            value: _selectedCategory,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            hint: const Text(
                              'Category...',
                              style: TextStyle(fontSize: 14, color: kMuted),
                            ),
                            style: const TextStyle(fontSize: 14, color: kText),
                            dropdownColor: kCard,
                            items: categoryOptions.map((cat) {
                              return DropdownMenuItem<String>(
                                value: cat['value'],
                                child: Text(cat['labelEn']!),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                _selectedCategory = val;
                              });
                            },
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: kCard,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: kBorder),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField<String>(
                            value: _selectedCuisine,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            hint: const Text(
                              'Cuisine...',
                              style: TextStyle(fontSize: 14, color: kMuted),
                            ),
                            style: const TextStyle(fontSize: 14, color: kText),
                            dropdownColor: kCard,
                            items: cuisineOptions.map((cuisine) {
                              return DropdownMenuItem<String>(
                                value: cuisine['value'],
                                child: Text(cuisine['labelEn']!),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                _selectedCuisine = val;
                              });
                            },
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => _showTagsMultiSelectDialog(context, false),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: kCard,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: kBorder),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: _selectedTags.isEmpty
                                    ? const Text(
                                        'Tags...',
                                        style: TextStyle(fontSize: 14, color: kMuted),
                                      )
                                    : Wrap(
                                        spacing: 6,
                                        runSpacing: 4,
                                        children: _selectedTags.map((tagValue) {
                                          final tagOpt = tagOptions.firstWhere((t) => t['value'] == tagValue);
                                          return Chip(
                                            label: Text(
                                              tagOpt['labelEn']!,
                                              style: const TextStyle(fontSize: 11, color: kPrimary),
                                            ),
                                            backgroundColor: kUploadBg,
                                            padding: EdgeInsets.zero,
                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            side: BorderSide.none,
                                          );
                                        }).toList(),
                                      ),
                              ),
                              const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: kMuted,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      UploadTextField(
                        hint: 'Description...',
                        controller: _descriptionController,
                        maxLines: 3,
                      ),
                      UploadTextField(
                        hint: 'Price (\$)...',
                        controller: _priceController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      ),
                      UploadTextField(
                        hint: 'Quantity...',
                        controller: _quantityController,
                        keyboardType: TextInputType.number,
                      ),
                      UploadTextField(
                        hint: 'Expiry Date (YYYY-MM-DD)...',
                        controller: _expiryController,
                        keyboardType: TextInputType.datetime,
                      ),
                      const SizedBox(height: 28),

                      // Publish Button
                      UploadSubmitButton(
                        label: 'Publish Meal',
                        onTap: () => _onSubmit(context, cubit),
                      ),
                    ] else ...[
                      // IMAGE UPLOAD BOX FOR OFFER
                      UploadPhotoBox(
                        imagePath: pickedPath,
                        imageUrl: _linkedMealImageUrl,
                        onTap: () => cubit.pickImage(),
                      ),
                      const SizedBox(height: 24),

                      // Offer Details Section Label
                      const SectionLabel(text: 'Offer Details'),
                      const SizedBox(height: 10),

                      // Link to Meal (dropdown)
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: kCard,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: kBorder),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField<MealEntity?>(
                            value: _linkedMeal,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            hint: const Text(
                              'Link to Meal (optional)...',
                              style: TextStyle(fontSize: 14, color: kMuted),
                            ),
                            style: const TextStyle(fontSize: 14, color: kText),
                            dropdownColor: kCard,
                            items: [
                              const DropdownMenuItem<MealEntity?>(
                                value: null,
                                child: Text('No linked meal'),
                              ),
                              ...cubit.meals.map((meal) {
                                return DropdownMenuItem<MealEntity?>(
                                  value: meal,
                                  child: Text(meal.name),
                                );
                              }),
                            ],
                            onChanged: (val) {
                              _onLinkedMealChanged(val);
                            },
                          ),
                        ),
                      ),

                      UploadTextField(
                        hint: 'Offer Title...',
                        controller: _offerTitleController,
                      ),

                      // Price original and offer
                      UploadTextField(
                        hint: 'Original Price (\$)...',
                        controller: _offerOriginalPriceController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      ),
                      UploadTextField(
                        hint: 'Offer Price (\$)...',
                        controller: _offerPriceController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onChanged: (_) {
                          setState(() {});
                        },
                      ),

                      // Show discount badge if prices are valid
                      Builder(builder: (c) {
                        final orig = double.tryParse(_offerOriginalPriceController.text) ?? 0.0;
                        final offer = double.tryParse(_offerPriceController.text) ?? 0.0;
                        if (orig > 0 && offer > 0 && offer <= orig) {
                          final pct = ((1 - offer / orig) * 100).round();
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: kUploadBg,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.local_offer_outlined, color: kPrimary, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  'Discount: $pct% off',
                                  style: const TextStyle(color: kPrimary, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }),

                      UploadTextField(
                        hint: 'Quantity (optional, blank for unlimited)...',
                        controller: _offerQuantityController,
                        keyboardType: TextInputType.number,
                      ),

                      UploadTextField(
                        hint: 'Description...',
                        controller: _offerDescriptionController,
                        maxLines: 3,
                      ),

                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: kCard,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: kBorder),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField<String>(
                            value: _offerSelectedCategory,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            hint: const Text(
                              'Category...',
                              style: TextStyle(fontSize: 14, color: kMuted),
                            ),
                            style: const TextStyle(fontSize: 14, color: kText),
                            dropdownColor: kCard,
                            items: categoryOptions.map((cat) {
                              return DropdownMenuItem<String>(
                                value: cat['value'],
                                child: Text(cat['labelEn']!),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                _offerSelectedCategory = val;
                              });
                            },
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: kCard,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: kBorder),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField<String>(
                            value: _offerSelectedCuisine,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            hint: const Text(
                              'Cuisine...',
                              style: TextStyle(fontSize: 14, color: kMuted),
                            ),
                            style: const TextStyle(fontSize: 14, color: kText),
                            dropdownColor: kCard,
                            items: cuisineOptions.map((cuisine) {
                              return DropdownMenuItem<String>(
                                value: cuisine['value'],
                                child: Text(cuisine['labelEn']!),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                _offerSelectedCuisine = val;
                              });
                            },
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => _showTagsMultiSelectDialog(context, true),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: kCard,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: kBorder),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: _offerSelectedTags.isEmpty
                                    ? const Text(
                                        'Tags...',
                                        style: TextStyle(fontSize: 14, color: kMuted),
                                      )
                                    : Wrap(
                                        spacing: 6,
                                        runSpacing: 4,
                                        children: _offerSelectedTags.map((tagValue) {
                                          final tagOpt = tagOptions.firstWhere((t) => t['value'] == tagValue);
                                          return Chip(
                                            label: Text(
                                              tagOpt['labelEn']!,
                                              style: const TextStyle(fontSize: 11, color: kPrimary),
                                            ),
                                            backgroundColor: kUploadBg,
                                            padding: EdgeInsets.zero,
                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            side: BorderSide.none,
                                          );
                                        }).toList(),
                                      ),
                              ),
                              const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: kMuted,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Starts at and Expires at date/time pickers
                      GestureDetector(
                        onTap: () => _pickDateTime(context, true),
                        child: AbsorbPointer(
                          child: UploadTextField(
                            hint: 'Starts At (optional)...',
                            controller: _offerStartsAtController,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _pickDateTime(context, false),
                        child: AbsorbPointer(
                          child: UploadTextField(
                            hint: 'Expires At (optional)...',
                            controller: _offerExpiresAtController,
                          ),
                        ),
                      ),

                      // Active toggle switch
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: kCard,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: kBorder),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Active Offer', style: TextStyle(fontSize: 14, color: kText, fontWeight: FontWeight.w500)),
                            Switch(
                              value: _offerIsActive,
                              activeColor: kPrimary,
                              onChanged: (val) {
                                setState(() {
                                  _offerIsActive = val;
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Publish Button
                      UploadSubmitButton(
                        label: 'Publish Offer',
                        onTap: () => _onSubmit(context, cubit),
                      ),
                    ],
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}