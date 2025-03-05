String safeSubString(String s, int range) {
  if (s.length > range) {
    return '${s.substring(0, range)}...';
  }
  return s;
}
