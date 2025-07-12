import 'package:dotto/feature/funch/domain/funch_price.dart';

class FunchMenu {
  final String id;
  final String name;
  final int categoryId;
  final FunchPrice prices;
  final String imageUrl;

  FunchMenu(this.id, this.name, this.categoryId, this.prices, this.imageUrl);
}

final class FunchCommonMenu extends FunchMenu {
  final int energy;

  FunchCommonMenu(
    super.id,
    super.name,
    super.categoryId,
    super.prices,
    super.imageUrl,
    this.energy,
  );

  factory FunchCommonMenu.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      throw ArgumentError('JSON cannot be empty');
    }
    if (!json.containsKey('item_code') ||
        !json.containsKey('title') ||
        !json.containsKey('price') ||
        !json.containsKey('category') ||
        !json.containsKey('image') ||
        !json.containsKey('energy')) {
      throw ArgumentError(
          'JSON must contain item_code, title, price, category, image, and energy keys');
    }
    final id = json["item_code"].toString();
    final name = json["title"];
    final prices = FunchPrice.fromJson(json["price"]);
    final category = json["category"];
    final imageUrl = json["image"];
    final energy = json["energy"];
    return FunchCommonMenu(id, name, category, prices, imageUrl, energy);
  }
}

final class FunchOriginalMenu extends FunchMenu {
  FunchOriginalMenu(
    super.id,
    super.name,
    super.categoryId,
    super.prices,
    super.imageUrl,
  );

  factory FunchOriginalMenu.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      throw ArgumentError('JSON cannot be empty');
    }
    if (!json.containsKey('id') ||
        !json.containsKey('name') ||
        !json.containsKey('category_id') ||
        !json.containsKey('prices')) {
      throw ArgumentError('JSON must contain id, name, category_id, and prices keys');
    }
    final id = json['id'];
    final name = json['name'];
    final categoryId = json['category_id'];
    final prices = FunchPrice.fromJson(json['prices'] as Map<String, dynamic>);
    final imageUrl =
        "https://firebasestorage.googleapis.com/v0/b/swift2023groupc.appspot.com/o/funch%2Fimages%2F$id.webp?alt=media";
    return FunchOriginalMenu(id, name, categoryId, prices, imageUrl);
  }
}
