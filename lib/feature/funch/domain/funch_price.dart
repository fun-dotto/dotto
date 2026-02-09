final class FunchPrice {
  FunchPrice(this.large, this.medium, this.small);

  factory FunchPrice.fromJson(Map<String, dynamic> map) {
    if (map.isEmpty) {
      throw ArgumentError('JSON cannot be empty');
    }
    if (!map.containsKey('medium')) {
      throw ArgumentError('JSON must contain medium key');
    }
    final large = map['large'];
    final medium = map['medium'];
    final small = map['small'];
    return FunchPrice(large as int?, medium as int, small as int?);
  }
  final int? large;
  final int medium;
  final int? small;
}

final class FunchOriginalPrice extends FunchPrice {
  FunchOriginalPrice(super.large, super.medium, super.small, this.id, this.categories);
  final String id;
  final List<int> categories;
}
