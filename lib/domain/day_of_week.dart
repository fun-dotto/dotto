enum DayOfWeek {
  monday(label: '月'),
  tuesday(label: '火'),
  wednesday(label: '水'),
  thursday(label: '木'),
  friday(label: '金'),
  saturday(label: '土'),
  sunday(label: '日');

  const DayOfWeek({required this.label});

  final String label;
  int get number => index + 1;

  static List<DayOfWeek> get weekdays => [
    DayOfWeek.monday,
    DayOfWeek.tuesday,
    DayOfWeek.wednesday,
    DayOfWeek.thursday,
    DayOfWeek.friday,
  ];

  static DayOfWeek fromNumber(int number) {
    return DayOfWeek.values[number - 1];
  }
}
