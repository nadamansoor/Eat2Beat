import 'package:eat2beat/features/admin/presentation/view/admin_upload/widgets/file_item.dart';
import 'package:eat2beat/features/admin/presentation/view/admin_upload/widgets/image_upload_box.dart';
import 'package:eat2beat/features/admin/presentation/view/admin_upload/widgets/label_section.dart';
import 'package:eat2beat/features/admin/presentation/view/admin_upload/widgets/sumbit_btn.dart';
import 'package:eat2beat/features/admin/presentation/view/admin_upload/widgets/upload_text_field.dart';
import 'package:eat2beat/features/admin/presentation/view/admin_upload/widgets/uploas_app_bar.dart';
import 'package:flutter/material.dart';

class AdminUploadPage extends StatefulWidget {
  const AdminUploadPage({super.key});

  @override
  State<AdminUploadPage> createState() => _AdminUploadPageState();
}

class _AdminUploadPageState extends State<AdminUploadPage> {
  final _mealNameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _caloriesController = TextEditingController();

  // Mock uploaded files — استبدليها بـ logic حقيقي
  final List<Map<String, dynamic>> _uploadingFiles = [
    {'name': 'burger_hero.jpg', 'size': '2.4 MB', 'progress': 1.0},
    {'name': 'salad_bowl.jpg', 'size': '1.8 MB', 'progress': 0.65},
  ];

  @override
  void dispose() {
    _mealNameController.dispose();
    _categoryController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: const AdminUploadAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Upload photo box
            UploadPhotoBox(
              onTap: () {
                // TODO: open image picker
              },
            ),

            const SizedBox(height: 24),

            // ── Meal details
            const SectionLabel(text: 'Meal Details'),
            UploadTextField(
              hint: 'Meal name...',
              controller: _mealNameController,
            ),
            UploadTextField(
              hint: 'Category...',
              controller: _categoryController,
            ),
            UploadTextField(
              hint: 'Calories & nutrition...',
              controller: _caloriesController,
              maxLines: 2,
            ),

            const SizedBox(height: 24),

            // ── Uploading files
            const SectionLabel(text: 'Uploading'),
            ..._uploadingFiles.map((file) => UploadingFileItem(
                  fileName: file['name'],
                  fileSize: file['size'],
                  progress: file['progress'],
                  onRemove: () {
                    setState(() {
                      _uploadingFiles.remove(file);
                    });
                  },
                )),

            const SizedBox(height: 28),

            // ── Submit button
            UploadSubmitButton(
              label: 'Publish Meal',
              onTap: () {
                // TODO: submit logic
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}