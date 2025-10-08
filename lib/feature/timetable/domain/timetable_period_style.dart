enum TimetablePeriodStyle {
  numberOnly(label: '時限のみ'),
  numberWithTime(label: '時限と時刻');

  const TimetablePeriodStyle({required this.label});

  final String label;

  static TimetablePeriodStyle fromString(String? value) {
    switch (value) {
      case 'numberOnly':
        return TimetablePeriodStyle.numberOnly;
      case 'numberWithTime':
        return TimetablePeriodStyle.numberWithTime;
      default:
        return TimetablePeriodStyle.numberOnly;
    }
  }
}
