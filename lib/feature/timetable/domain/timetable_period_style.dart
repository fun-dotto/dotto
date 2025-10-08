enum TimetablePeriodStyle {
  numberOnly,
  numberWithTime;

  const TimetablePeriodStyle();

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
