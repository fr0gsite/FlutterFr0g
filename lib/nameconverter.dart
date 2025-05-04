class NameConverter {
  static BigInt nameToUint64(String s) {
    BigInt n = BigInt.zero;

    int i = 0;
    for (; i < 12 && i < s.length; ++i) {
      final shift = 64 - 5 * (i + 1);
      n |= (BigInt.from(charToSymbol(s.codeUnitAt(i)) & 0x1f) << shift);
    }

    if (s.length > 12) {
      n |= BigInt.from(charToSymbol(s.codeUnitAt(12)) & 0x0f);
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


  static const String _charMap = ".12345abcdefghijklmnopqrstuvwxyz";
  // Converts a `BigInt` (EOS name in uint64 format) back
  // into the readable string (max. 12 characters).
  static String uint64ToName(BigInt value) {
    // We retain up to 13 “potential” characters,
    // as EOS still has the option of 13 characters internally.
    List<String> temp = List.filled(13, '');
    BigInt tmp = value;

    for (int i = 0; i <= 12; i++) {
       // Only 4 bits are read during the very first run (i == 0)
      // (because of the EOS format). Thereafter 5 bits each time.
      int c;
      if (i == 0) {
        c = (tmp & BigInt.from(0x0f)).toInt();
        tmp = tmp >> 4;
      } else {
        c = (tmp & BigInt.from(0x1f)).toInt();
        tmp = tmp >> 5;
      }
      temp[12 - i] = _charMap[c];
    }

    return temp.join('').replaceAll('.', '').trim();
  }
}
