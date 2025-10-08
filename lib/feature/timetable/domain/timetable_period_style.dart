enum TimetablePeriodStyle {
  numberOnly,
  timeOnly;

  const TimetablePeriodStyle();

  static TimetablePeriodStyle fromString(String? value) {
    switch (value) {
      case 'numberOnly':
        return TimetablePeriodStyle.numberOnly;
      case 'timeOnly':
        return TimetablePeriodStyle.timeOnly;
      default:
        return TimetablePeriodStyle.numberOnly;
    }
  }
}
