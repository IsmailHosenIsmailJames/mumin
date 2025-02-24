int getRamadanNumber() {
  DateTime ramadanStart = DateTime(2025, 3, 1);
  int ramadanDay = DateTime(2025, 3, 29).difference(ramadanStart).inDays;
  if (ramadanDay < 0) ramadanDay = 0;
  ramadanDay++;
  return ramadanDay;
}
