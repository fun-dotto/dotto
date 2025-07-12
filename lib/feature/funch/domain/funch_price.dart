class FunchPrice {
  final int? large;
  final int medium;
  final int? small;

  FunchPrice(this.large, this.medium, this.small);

  factory FunchPrice.fromJson(Map map) {
    if (map.isEmpty) {
      throw ArgumentError('JSON cannot be empty');
    }
    if (!map.containsKey('medium')) {
      throw ArgumentError('JSON must contain medium key');
    }
    final large = map["large"];
    final medium = map["medium"];
    final small = map["small"];
    return FunchPrice(large, medium, small);
  }
}

class FunchOriginalPrice extends FunchPrice {
  final String id;
  final List<int> categories;

  FunchOriginalPrice(super.large, super.medium, super.small, this.id, this.categories);
}
