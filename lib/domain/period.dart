enum Period {
  first,
  second,
  third,
  fourth,
  fifth,
  sixth;

  const Period();

  int get number => index + 1;
}
