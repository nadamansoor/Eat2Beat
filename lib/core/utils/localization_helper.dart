import 'package:eat2beat/generated/l10n.dart';
import 'package:flutter/material.dart';

String getLocalizedText(BuildContext context, String text) {
  final s = S.of(context);
  final trimmedText = text.trim();
  switch (trimmedText) {
    // Restaurants
    case 'Burger King':
      return s.burgerKing;
    // Meal titles
    case 'Healthy Taco Salad With Fresh Vegetables':
    case 'Healthy Taco Salad':
      return s.healthyTacoSalad;
    case 'Japanese-style Pancakes Recipe':
    case 'Japanese-style Pancakes':
      return s.japanesePancakes;
    case 'Beef Burger':
      return s.beefBurger;
    case 'Chicken Wrap':
      return s.chickenWrap;
    case 'Golden Box':
      return s.goldenBox;
    // Banners
    case '35% OFF on\nBurgers at\nOMG!':
      return s.banner1;
    case '20% OFF on\nPizza Today':
      return s.banner2;
    case 'Buy 1 Get 1\nFree Desserts':
      return s.banner3;
    // Descriptions
    case 'Lorem ipsum dolor sit amet consectetur. Pellentesque gravida tempor tellus at. Et nisl vitae viverra praesent nisl porttitor. Velit nibh lectus massa ut et. Odio tellus magna nisl pellentesque adipiscing velit.':
    case 'Lorem ipsum dolor sit amet consectetur.':
      return s.tacoSaladDesc;
    case 'Soft mini pancakes served with honey and fresh fruits.':
      return s.pancakesDesc;
    case 'Creamy avocado slices with fresh bread and light seasoning.':
      return s.avocadoDesc;
    case 'Fresh vegetables mixed with light dressing for a healthy and refreshing taste.':
      return s.vegetablesDesc;
    case 'Tender grilled chicken wrapped with fresh veggies and soft bread.':
      return s.chickenWrapDesc;
    default:
      if (trimmedText.startsWith('hdbdusiwjdjjdjdj') || trimmedText.startsWith('Lorem ipsum')) {
        return s.placeholderDesc;
      }
      return text;
  }
}
