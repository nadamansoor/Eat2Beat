import 'package:flutter/material.dart';
import '../../admin_home/const.dart';

class PresetImagePickerDialog extends StatefulWidget {
  final Function(String) onImageSelected;

  const PresetImagePickerDialog({
    super.key,
    required this.onImageSelected,
  });

  @override
  State<PresetImagePickerDialog> createState() => _PresetImagePickerDialogState();
}

class _PresetImagePickerDialogState extends State<PresetImagePickerDialog> {
  String selectedCategory = 'all';

  // Categories definition
  final List<Map<String, dynamic>> categories = [
    {'id': 'all', 'nameAr': 'الكل', 'nameEn': 'All', 'icon': Icons.restaurant_menu_rounded},
    {'id': 'burger', 'nameAr': 'وجبات سريعة', 'nameEn': 'Fast Food', 'icon': Icons.fastfood_rounded},
    {'id': 'pizza', 'nameAr': 'بيتزا وإيطالي', 'nameEn': 'Pizza & Italian', 'icon': Icons.local_pizza_rounded},
    {'id': 'cafe', 'nameAr': 'كافيه وفطور', 'nameEn': 'Cafe & Coffee', 'icon': Icons.coffee_rounded},
    {'id': 'grill', 'nameAr': 'مشويات وشرقي', 'nameEn': 'Grill & Eastern', 'icon': Icons.kebab_dining_rounded},
    {'id': 'bakery', 'nameAr': 'مخبوزات وحلويات', 'nameEn': 'Bakery & Dessert', 'icon': Icons.cake_rounded},
    {'id': 'egyptian', 'nameAr': 'أكلات شعبية', 'nameEn': 'Traditional', 'icon': Icons.food_bank_rounded},
    {'id': 'healthy', 'nameAr': 'أكل صحي', 'nameEn': 'Healthy', 'icon': Icons.spa_rounded},
    {'id': 'seafood', 'nameAr': 'مأكولات بحرية', 'nameEn': 'Seafood', 'icon': Icons.sailing_rounded},
  ];

  // Preset images list
  final List<Map<String, String>> presetImages = [
    // Fast Food / Burger
    {
      'url': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=500&q=80',
      'category': 'burger',
      'titleAr': 'برجر كلاسيك فاخر',
      'titleEn': 'Gourmet Classic Burger',
    },
    {
      'url': 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=500&q=80',
      'category': 'burger',
      'titleAr': 'وجبة برجر وبطاطس',
      'titleEn': 'Burger Meal & Fries',
    },
    {
      'url': 'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?auto=format&fit=crop&w=500&q=80',
      'category': 'burger',
      'titleAr': 'دجاج مقلي مقرمش',
      'titleEn': 'Crispy Fried Chicken',
    },
    // Pizza & Italian
    {
      'url': 'https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=500&q=80',
      'category': 'pizza',
      'titleAr': 'بيتزا نابوليتان إيطالية',
      'titleEn': 'Italian Neapolitan Pizza',
    },
    {
      'url': 'https://images.unsplash.com/photo-1534308983496-4fabb1a015ee?auto=format&fit=crop&w=500&q=80',
      'category': 'pizza',
      'titleAr': 'بيتزا ببروني شهية',
      'titleEn': 'Tasty Pepperoni Pizza',
    },
    {
      'url': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?auto=format&fit=crop&w=500&q=80',
      'category': 'pizza',
      'titleAr': 'بيتزا مارجريتا طازجة',
      'titleEn': 'Fresh Margherita Pizza',
    },
    // Cafe & Coffee
    {
      'url': 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?auto=format&fit=crop&w=500&q=80',
      'category': 'cafe',
      'titleAr': 'فنجان قهوة لاتيه',
      'titleEn': 'Latte Coffee Cup',
    },
    {
      'url': 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?auto=format&fit=crop&w=500&q=80',
      'category': 'cafe',
      'titleAr': 'ركن قهوة دافئ',
      'titleEn': 'Cozy Cafe Vibe',
    },
    {
      'url': 'https://images.unsplash.com/photo-1517256064527-09c53b2d0bc6?auto=format&fit=crop&w=500&q=80',
      'category': 'cafe',
      'titleAr': 'فطور فرنسي متكامل',
      'titleEn': 'French Style Breakfast',
    },
    // Grill & Eastern
    {
      'url': 'https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=500&q=80',
      'category': 'grill',
      'titleAr': 'مشويات مشكلة فاخرة',
      'titleEn': 'Premium Mixed Grill',
    },
    {
      'url': 'https://images.unsplash.com/photo-1529193591184-b1d58069ecdd?auto=format&fit=crop&w=500&q=80',
      'category': 'grill',
      'titleAr': 'كباب وكفتة شرقية',
      'titleEn': 'Oriental Kebab & Kofta',
    },
    {
      'url': 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?auto=format&fit=crop&w=500&q=80',
      'category': 'grill',
      'titleAr': 'أطباق لحوم مشوية',
      'titleEn': 'Grilled Steak & Meat',
    },
    // Bakery & Dessert
    {
      'url': 'https://images.unsplash.com/photo-1509440159596-0249088772ff?auto=format&fit=crop&w=500&q=80',
      'category': 'bakery',
      'titleAr': 'كرواسون ومخبوزات طازجة',
      'titleEn': 'Fresh Croissants & Bakery',
    },
    {
      'url': 'https://images.unsplash.com/photo-1551024601-bec78aea704b?auto=format&fit=crop&w=500&q=80',
      'category': 'bakery',
      'titleAr': 'دونات وحلويات ملونة',
      'titleEn': 'Colorful Sweet Donuts',
    },
    {
      'url': 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?auto=format&fit=crop&w=500&q=80',
      'category': 'bakery',
      'titleAr': 'قالب كيك شوكولاتة',
      'titleEn': 'Rich Chocolate Cake',
    },
    // Traditional
    {
      'url': 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=500&q=80',
      'category': 'egyptian',
      'titleAr': 'كشري مصري أصيل',
      'titleEn': 'Authentic Egyptian Koshary',
    },
    {
      'url': 'https://images.unsplash.com/photo-1626132647523-66f5bf380027?auto=format&fit=crop&w=500&q=80',
      'category': 'egyptian',
      'titleAr': 'فلافل مصرية ساخنة',
      'titleEn': 'Hot Egyptian Falafel',
    },
    {
      'url': 'https://images.unsplash.com/photo-1541518763669-27fef04b14ea?auto=format&fit=crop&w=500&q=80',
      'category': 'egyptian',
      'titleAr': 'فطور شعبي متكامل',
      'titleEn': 'Traditional Breakfast Feast',
    },
    // Healthy
    {
      'url': 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=500&q=80',
      'category': 'healthy',
      'titleAr': 'طبق سلطة صحية وملونة',
      'titleEn': 'Colorful Healthy Salad Bowl',
    },
    {
      'url': 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=500&q=80',
      'category': 'healthy',
      'titleAr': 'وجبات نباتية صحية',
      'titleEn': 'Healthy Vegan Meals',
    },
    {
      'url': 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=500&q=80',
      'category': 'healthy',
      'titleAr': 'سلطة سيزر دجاج صحية',
      'titleEn': 'Healthy Chicken Caesar',
    },
    // Seafood
    {
      'url': 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?auto=format&fit=crop&w=500&q=80',
      'category': 'seafood',
      'titleAr': 'سمك سلمون مشوي طازج',
      'titleEn': 'Fresh Grilled Salmon',
    },
    {
      'url': 'https://images.unsplash.com/photo-1534080391025-097b03b2af0e?auto=format&fit=crop&w=500&q=80',
      'category': 'seafood',
      'titleAr': 'طبق فواكه البحر والجمبري',
      'titleEn': 'Seafood & Shrimp Platter',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Filter images based on selected category
    final filteredImages = selectedCategory == 'all'
        ? presetImages
        : presetImages.where((img) => img['category'] == selectedCategory).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: kBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle and Title
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            alignment: Alignment.center,
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'مساعد صور المطعم',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                    color: kText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'اختر صورة تعبر عن مطعمك بدقة وجاذبية',
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Cairo',
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: kBorder),

          // Categories horizontal scroll list
          Container(
            height: 56,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isSelected = selectedCategory == cat['id'];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    avatar: Icon(
                      cat['icon'],
                      size: 16,
                      color: isSelected ? Colors.white : kPrimary,
                    ),
                    label: Text(
                      cat['nameAr'],
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.white : kText,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          selectedCategory = cat['id']!;
                        });
                      }
                    },
                    selectedColor: kPrimary,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? kPrimary : kBorder,
                        width: 1,
                      ),
                    ),
                    showCheckmark: false,
                  ),
                );
              },
            ),
          ),

          // Images Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.85,
              ),
              itemCount: filteredImages.length,
              itemBuilder: (context, index) {
                final img = filteredImages[index];
                return GestureDetector(
                  onTap: () {
                    widget.onImageSelected(img['url']!);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: kBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Image Thumbnail
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                            child: Image.network(
                              img['url']!,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                    color: kPrimary,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[100],
                                  child: const Icon(
                                    Icons.image_not_supported_outlined,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        // Title / Description
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                img['titleAr']!,
                                style: const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: kText,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                img['titleEn']!,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[500],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
