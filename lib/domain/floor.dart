enum Floor {
  first(label: '1'),
  second(label: '2'),
  third(label: '3'),
  fourth(label: '4'),
  fifth(label: '5'),
  sixth(label: 'R6'),
  seventh(label: 'R7');

  const Floor({required this.label});

  final String label;

  static Floor fromLabel(String label) {
    return Floor.values.firstWhere((floor) => floor.label == label, orElse: () => Floor.first);
  }
}
