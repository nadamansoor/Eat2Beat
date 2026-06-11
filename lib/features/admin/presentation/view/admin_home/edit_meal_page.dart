import 'package:eat2beat/core/widgets/custom_prograss_hud.dart';
import 'package:eat2beat/core/helper/error_bar.dart';
import 'package:eat2beat/core/services/get_it_services.dart';
import 'package:eat2beat/features/admin/domain/entities/meal_entity.dart';
import 'package:eat2beat/features/admin/domain/usecases/update_meal_usecase.dart';
import 'package:eat2beat/features/admin/presentation/cubits/edit_meal_cubit/edit_meal_cubit.dart';
import 'package:eat2beat/features/admin/presentation/cubits/edit_meal_cubit/edit_meal_state.dart';
import 'package:eat2beat/features/admin/presentation/view/admin_upload/widgets/image_upload_box.dart';
import 'package:eat2beat/features/admin/presentation/view/admin_upload/widgets/label_section.dart';
import 'package:eat2beat/features/admin/presentation/view/admin_upload/widgets/sumbit_btn.dart';
import 'package:eat2beat/features/admin/presentation/view/admin_upload/widgets/upload_text_field.dart';
import 'package:eat2beat/features/auth/domain/repo/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditMealPage extends StatefulWidget {
  final MealEntity meal;

  const EditMealPage({super.key, required this.meal});

  @override
  State<EditMealPage> createState() => _EditMealPageState();
}

class _EditMealPageState extends State<EditMealPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _quantityController;
  late final TextEditingController _expiryController;
  late final TextEditingController _categoryController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.meal.name);
    _descriptionController = TextEditingController(text: widget.meal.description);
    _priceController = TextEditingController(text: widget.meal.price.toString());
    _quantityController = TextEditingController(text: widget.meal.quantity.toString());
    _expiryController = TextEditingController(text: widget.meal.expiryTime.split('T')[0]);
    _categoryController = TextEditingController(text: widget.meal.category);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _expiryController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditMealCubit>(
      create: (_) => EditMealCubit(
        authRepo: getIt<AuthRepo>(),
        updateMealUseCase: getIt<UpdateMealUseCase>(),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: AppBar(
          title: const Text(
            'Edit Meal',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: const Color(0xFF2ECC87),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocConsumer<EditMealCubit, EditMealState>(
          listener: (context, state) {
            if (state is EditMealSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Meal updated successfully!'),
                  backgroundColor: Color(0xFF2ECC87),
                ),
              );
              Navigator.pop(context, true);
            }
            if (state is EditMealError) {
              BuildErrorBar(context, state.message);
            }
          },
          builder: (context, state) {
            final cubit = context.read<EditMealCubit>();
            final pickedImagePath = cubit.pickedImagePath;

            return CustomProgressHud(
              isLoading: state is EditMealLoading,
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionLabel(text: 'Meal Photo'),
                      const SizedBox(height: 8),
                      UploadPhotoBox(
                        imagePath: pickedImagePath,
                        imageUrl: pickedImagePath == null ? widget.meal.imageUrl : null,
                        onTap: () {
                          context.read<EditMealCubit>().pickImage();
                        },
                      ),
                      const SizedBox(height: 24),
                      const SectionLabel(text: 'Meal Details'),
                      UploadTextField(
                        hint: 'Meal name...',
                        controller: _nameController,
                      ),
                      UploadTextField(
                        hint: 'Category...',
                        controller: _categoryController,
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
                      const SizedBox(height: 32),
                      UploadSubmitButton(
                        label: 'Save Changes',
                        onTap: () {
                          final price = double.tryParse(_priceController.text) ?? 0.0;
                          final qty = int.tryParse(_quantityController.text) ?? 0;
                          context.read<EditMealCubit>().updateMeal(
                                mealId: widget.meal.id,
                                name: _nameController.text,
                                description: _descriptionController.text,
                                price: price,
                                quantity: qty,
                                expiryTime: _expiryController.text,
                                category: _categoryController.text,
                                originalImageUrl: widget.meal.imageUrl,
                              );
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
