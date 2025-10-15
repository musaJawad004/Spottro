import 'package:get/get.dart';
import '../models/place_model.dart';
import '../models/category_model.dart';

class HomeController extends GetxController {
  final _places = <PlaceModel>[].obs;
  final _filteredPlaces = <PlaceModel>[].obs;
  final _categories = <CategoryModel>[].obs;
  final _selectedCategory = Rxn<String>();
  final _isLoading = false.obs;
  final _searchQuery = ''.obs;

  List<PlaceModel> get places => _filteredPlaces;
  List<CategoryModel> get categories => _categories;
  String? get selectedCategory => _selectedCategory.value;
  bool get isLoading => _isLoading.value;
  // Current position removed with geolocation dependency

  @override
  void onInit() {
    super.onInit();
    _categories.value = CategoryModel.getDefaultCategories();
    // Default select the first category so UI shows a chosen background.
    if (_categories.isNotEmpty) {
      selectCategory(_categories.first.name);
    }
    loadNearbyPlaces();
  }

  Future<void> loadNearbyPlaces() async {
    try {
      _isLoading.value = true;
      await Future.delayed(const Duration(seconds: 1));

      // Mock data
      _places.value = [
        PlaceModel(
          id: '1',
          name: 'Starbucks Coffee',
          category: 'Coffee',
          latitude: 37.7749,
          longitude: -122.4194,
          address: '123 Market St, San Francisco, CA',
          phone: '+1 555-0123',
          rating: 4.5,
          reviewCount: 234,
          imageUrl: 'https://images.unsplash.com/photo-1554118811-1e0d58224f24',
          isOpen: true,
          openingHours: '7:00 AM - 9:00 PM',
          distance: 1.2,
          estimatedTime: 5,
        ),
        PlaceModel(
          id: '2',
          name: 'Gold\'s Gym',
          category: 'Gym',
          latitude: 37.7739,
          longitude: -122.4184,
          address: '456 Fitness Ave, San Francisco, CA',
          phone: '+1 555-0456',
          rating: 4.8,
          reviewCount: 456,
          imageUrl:
              'https://images.unsplash.com/photo-1534438327276-14e5300c3a48',
          isOpen: true,
          openingHours: '5:00 AM - 11:00 PM',
          distance: 2.5,
          estimatedTime: 10,
        ),
        PlaceModel(
          id: '3',
          name: 'Central Library',
          category: 'Library',
          latitude: 37.7759,
          longitude: -122.4174,
          address: '789 Book St, San Francisco, CA',
          phone: '+1 555-0789',
          rating: 4.7,
          reviewCount: 189,
          imageUrl:
              'https://images.unsplash.com/photo-1521587760476-6c12a4b040da',
          isOpen: true,
          openingHours: '9:00 AM - 8:00 PM',
          distance: 0.8,
          estimatedTime: 3,
        ),
        PlaceModel(
          id: '4',
          name: 'Italian Bistro',
          category: 'Restaurant',
          latitude: 37.7769,
          longitude: -122.4164,
          address: '321 Pasta Ln, San Francisco, CA',
          phone: '+1 555-0321',
          rating: 4.9,
          reviewCount: 567,
          imageUrl:
              'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4',
          isOpen: true,
          openingHours: '11:00 AM - 10:00 PM',
          distance: 3.2,
          estimatedTime: 15,
        ),
        PlaceModel(
          id: '5',
          name: 'Fresh Market',
          category: 'Supermarket',
          latitude: 37.7729,
          longitude: -122.4154,
          address: '654 Grocery Blvd, San Francisco, CA',
          phone: '+1 555-0654',
          rating: 4.3,
          reviewCount: 312,
          imageUrl: 'https://images.unsplash.com/photo-1542838132-92c53300491e',
          isOpen: true,
          openingHours: '8:00 AM - 10:00 PM',
          distance: 1.8,
          estimatedTime: 7,
        ),
      ];

      _filteredPlaces.value = _places;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load places: ${e.toString()}');
    } finally {
      _isLoading.value = false;
    }
  }

  void selectCategory(String? categoryName) {
    _selectedCategory.value = categoryName;

    // Update category selection
    _categories.value = _categories.map((cat) {
      return cat.copyWith(isSelected: cat.name == categoryName);
    }).toList();

    filterPlaces();
  }

  void search(String query) {
    _searchQuery.value = query;
    // Debounce search with 300ms delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_searchQuery.value == query) {
        filterPlaces();
      }
    });
  }

  void filterPlaces() {
    List<PlaceModel> filtered = _places;

    if (_selectedCategory.value != null) {
      filtered = filtered
          .where((place) => place.category == _selectedCategory.value)
          .toList();
    }

    if (_searchQuery.value.isNotEmpty) {
      filtered = filtered
          .where(
            (place) =>
                place.name.toLowerCase().contains(
                  _searchQuery.value.toLowerCase(),
                ) ||
                place.category.toLowerCase().contains(
                  _searchQuery.value.toLowerCase(),
                ),
          )
          .toList();
    }

    _filteredPlaces.value = filtered;
  }

  void toggleFavorite(String placeId) {
    final index = _places.indexWhere((p) => p.id == placeId);
    if (index != -1) {
      _places[index] = _places[index].copyWith(
        isFavorite: !_places[index].isFavorite,
      );
      _places.refresh();
      filterPlaces();
    }
  }

  Future<void> refreshPlaces() async {
    await loadNearbyPlaces();
  }
}
