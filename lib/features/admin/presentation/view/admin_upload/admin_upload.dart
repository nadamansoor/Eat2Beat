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
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _expiryController = TextEditingController();

  String? _selectedCategory;

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

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _expiryController.dispose();
    super.dispose();
  }

  void _clearForm(AddMealCubit cubit) {
    _nameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _quantityController.clear();
    _expiryController.clear();
    setState(() {
      _selectedCategory = null;
    });
    cubit.reset();
  }

  void _onSubmit(BuildContext context, AddMealCubit cubit) {
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddMealCubit>(
      create: (_) => AddMealCubit(
        authRepo: getIt<AuthRepo>(),
        addMealUseCase: getIt<AddMealUseCase>(),
      ),
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
                    // Image Upload Box
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