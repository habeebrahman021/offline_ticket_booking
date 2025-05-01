extension StringToDateTime on String {
  DateTime toDateTime() {
    if (isEmpty) return DateTime.now();
    return DateTime.parse(this);
  }
}
