List<String> splitStringByDigit(String input) {
  List<String> result = input.split(RegExp(r'\d+\.'));

  List<String> trimmedList = [];

  for (String str in result) {
    String trimmedString = str.trim();
    trimmedList.add(trimmedString);
  }
  trimmedList.removeWhere((str) => str.isEmpty);

  return trimmedList;
}
