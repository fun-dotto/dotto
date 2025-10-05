enum Period {
  first,
  second,
  third,
  fourth,
  fifth,
  sixth;

  const Period();

  int get number => index + 1;

  static Period fromNumber(int number) {
    return Period.values[number - 1];
  }
}
