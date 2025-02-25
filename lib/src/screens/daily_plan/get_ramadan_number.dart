int getRamadanNumber() {
  DateTime ramadanStart = DateTime(2025, 3, 1);
  int ramadanDay = DateTime.now().difference(ramadanStart).inDays;
  if (ramadanDay < 0) ramadanDay = 0;
  ramadanDay++;
  return ramadanDay;
}

DateTime getDateByRamadanNumber(int day) {
  DateTime ramadanStart = DateTime(2025, 3, 1);
  return ramadanStart.add(Duration(days: day));
}
