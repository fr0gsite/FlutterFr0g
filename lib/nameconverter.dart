class NameConverter {
  static BigInt nameToUint64(String s) {
    BigInt n = BigInt.zero;

    int i = 0;
    for (; i < 12 && i < s.length; i++) {
      BigInt shiftValue = BigInt.from(64) - BigInt.from(5 * (i + 1));
      n = n |
          (BigInt.from(charToSymbol(s.codeUnitAt(i)) & 0x1f) <<
              shiftValue.toInt());
    }

    if (i == 12) {
      n = n | BigInt.from(charToSymbol(s.codeUnitAt(i - 1)) & 0x0f);
    }

    return n;
  }

  static int charToSymbol(dynamic c) {
    if (c is String) c = c.codeUnitAt(0);

    if (c >= 'a'.codeUnitAt(0) && c <= 'z'.codeUnitAt(0)) {
      return c - 'a'.codeUnitAt(0) + 6;
    }

    if (c >= '1'.codeUnitAt(0) && c <= '5'.codeUnitAt(0)) {
      return c - '1'.codeUnitAt(0) + 1;
    }

    return 0;
  }
}
