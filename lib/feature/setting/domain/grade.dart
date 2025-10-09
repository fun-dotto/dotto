enum Grade {
  b1(label: '1年'),
  b2(label: '2年'),
  b3(label: '3年'),
  b4(label: '4年'),
  m1(label: 'M1'),
  m2(label: 'M2'),
  d1(label: 'D1'),
  d2(label: 'D2'),
  d3(label: 'D3');

  const Grade({required this.label});

  final String label;

  static Grade fromLabel(String label) {
    return Grade.values.firstWhere(
      (grade) => grade.label == label,
      orElse: () => Grade.b1,
    );
  }
}
