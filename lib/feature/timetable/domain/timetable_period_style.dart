enum TimetablePeriodStyle {
  numberOnly(label: '時限のみ'),
  numberWithTime(label: '時限と時刻');

  const TimetablePeriodStyle({required this.label});

  final String label;
}
