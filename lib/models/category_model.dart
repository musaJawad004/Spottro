import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final bool isSelected;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    this.isSelected = false,
  });

  CategoryModel copyWith({
    String? id,
    String? name,
    IconData? icon,
    Color? color,
    bool? isSelected,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  static List<CategoryModel> getDefaultCategories() {
    return [
      CategoryModel(
        id: '1',
        name: 'Coffee',
        icon: Icons.coffee,
        color: const Color(0xFFD4A574),
      ),
      CategoryModel(
        id: '2',
        name: 'Gym',
        icon: Icons.fitness_center,
        color: const Color(0xFFFF6B6B),
      ),
      CategoryModel(
        id: '3',
        name: 'Library',
        icon: Icons.local_library,
        color: const Color(0xFF4ECDC4),
      ),
      CategoryModel(
        id: '4',
        name: 'Restaurant',
        icon: Icons.restaurant,
        color: const Color(0xFFFFA07A),
      ),
      CategoryModel(
        id: '5',
        name: 'Supermarket',
        icon: Icons.shopping_cart,
        color: const Color(0xFF98D8C8),
      ),
      CategoryModel(
        id: '6',
        name: 'Hospital',
        icon: Icons.local_hospital,
        color: const Color(0xFFEE5A6F),
      ),
      CategoryModel(
        id: '7',
        name: 'Park',
        icon: Icons.park,
        color: const Color(0xFF6BCF7F),
      ),
      CategoryModel(
        id: '8',
        name: 'Cinema',
        icon: Icons.local_movies,
        color: const Color(0xFF9B59B6),
      ),
    ];
  }
}
