import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../models/clothing_item_model.dart';

abstract class LaundryLocalDataSource {
  Future<void> cacheClothingItems(List<ClothingItemModel> items);
  Future<List<ClothingItemModel>?> getCachedClothingItems();
  Future<void> clearCache();
}

class LaundryLocalDataSourceImpl implements LaundryLocalDataSource {
  static const String _clothingItemsKey = 'cached_clothing_items';

  @override
  Future<void> cacheClothingItems(List<ClothingItemModel> items) async {
    final prefs = await SharedPreferences.getInstance();

    // Convert to JSON string
    final jsonList = items.map((item) => item.toJson()).toList();
    await prefs.setString(_clothingItemsKey, json.encode(jsonList));
  }

  @override
  Future<List<ClothingItemModel>?> getCachedClothingItems() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_clothingItemsKey);

    if (jsonString == null) return null;

    try {
      // Parse JSON string
      final jsonList = json.decode(jsonString) as List<dynamic>;

      // Convert JSON to ClothingItemModel
      return jsonList
          .map((json) => ClothingItemModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error parsing cached items: $e');
      return null;
    }
  }

  @override
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_clothingItemsKey);
  }
}