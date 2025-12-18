import '../utils/app_images.dart';

class HomeFoodModel {
  final String title;
  final String image;
  final String price;
  final double rate;
  final String time;
  final String description;
  final String size;
  final String restName;
  final String restIcon;

  HomeFoodModel({
    required this.restName,
    required this.restIcon,
    required this.size,
    required this.title,
    required this.image,
    required this.price,
    required this.rate,
    required this.description,
    required this.time,
  });

  static final List<HomeFoodModel> mealDetails = [
    HomeFoodModel(
      restName :'Burger King',
      restIcon: AppImages.king,
      title: 'Healthy Taco Salad With Fresh Vegetables',
      size:'L',
      image: AppImages.food_2,
      price: '120',
      rate: 4.5,
      time:'20 Min',
      description:'Lorem ipsum dolor sit amet consectetur.'
          ' Pellentesque gravida tempor tellus at.'
          ' Et nisl vitae viverra praesent nisl porttitor.'
          ' Velit nibh lectus massa ut et.'
          ' Odio tellus magna nisl pellentesque adipiscing velit.',
    ),
    HomeFoodModel(
      restName :'Burger King',
      restIcon: AppImages.king,
      title: 'Japanese-style Pancakes Recipe',
      size:'M',
      image: AppImages.food,
      price: '90',
      rate: 4.7,
      time:'45 Min',
      description:'Soft mini pancakes served with honey and fresh fruits.',
    ),
    HomeFoodModel(
      restName :'Burger King',
      restIcon: AppImages.king,
      title: 'Healthy Taco Salad With Fresh Vegetables',
      size:'L',
      image: AppImages.food2,
      price: '150',
      rate: 4.9,
      time:'20 Min',
      description:'Lorem ipsum dolor sit amet consectetur.'
          ' Pellentesque gravida tempor tellus at.'
          ' Et nisl vitae viverra praesent nisl porttitor.'
          ' Velit nibh lectus massa ut et.'
          ' Odio tellus magna nisl pellentesque adipiscing velit.',
    ),
    HomeFoodModel(
      restName :'Burger King',
      restIcon: AppImages.king,
      title: 'Japanese-style Pancakes Recipe',
      size:'S',
      image: AppImages.food,
      price: '90',
      rate: 4.2,
      time:'15 Min',
      description:'Creamy avocado slices with fresh bread and light seasoning.',
    ),
    HomeFoodModel(
      restName :'Burger King',
      restIcon: AppImages.king,
      title: 'Healthy Taco Salad With Fresh Vegetables',
      size:'M',
      image: AppImages.food_2,
      price: '120',
      rate: 4.5,
      time:'60 Min',
      description:'Lorem ipsum dolor sit amet consectetur.'
          ' Pellentesque gravida tempor tellus at.'
          ' Et nisl vitae viverra praesent nisl porttitor.'
          ' Velit nibh lectus massa ut et.'
          ' Odio tellus magna nisl pellentesque adipiscing velit.',
    ),
    HomeFoodModel(
      restName :'Burger King',
      restIcon: AppImages.king,
      title: 'Japanese-style Pancakes Recipe',
      size:'M',
      image: AppImages.food4,
      price: '140',
      rate: 4.7,
      time:'30 Min',
      description:'Fresh vegetables mixed with light dressing for a healthy and refreshing taste.',
    ),
    HomeFoodModel(
      restName :'Burger King',
      restIcon: AppImages.king,
      title: 'Healthy Taco Salad With Fresh Vegetables',
      size:'M',
      image: AppImages.food_2,
      price: '120',
      rate: 4.1,
      time:'60 Min',
      description:'Lorem ipsum dolor sit amet consectetur.'
          ' Pellentesque gravida tempor tellus at.'
          ' Et nisl vitae viverra praesent nisl porttitor.'
          ' Velit nibh lectus massa ut et.'
          ' Odio tellus magna nisl pellentesque adipiscing velit.',
    ),
    HomeFoodModel(
      restName :'Burger King',
      restIcon: AppImages.king,
      title: 'Japanese-style Pancakes Recipe',
      size:'M',
      image: AppImages.food3,
      price: '140',
      rate: 4.5,
      time:'30 Min',
      description:'Tender grilled chicken wrapped with fresh veggies and soft bread.',
    ),

  ];

}
