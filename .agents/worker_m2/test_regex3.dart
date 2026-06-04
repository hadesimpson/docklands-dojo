void main() {
  // Exactly mimic the normalize function
  String normalize(String input) {
    var result = input.toLowerCase();
    result = result
        .replaceAll('ō', 'o')
        .replaceAll('ū', 'u')
        .replaceAll('ā', 'a')
        .replaceAll('ē', 'e')
        .replaceAll('ī', 'i');
    result = result.replaceAll('-', ' ');
    result = result.replaceAll(RegExp(r'\\s+'), ' ').trim();
    return result;
  }

  print('Test 1: "${normalize('mae  geri')}"');
  print('Test 2: "${normalize('mae   geri')}"');
  print('Test 3: "${normalize('mae-geri')}"');
  print('Test 4: "${normalize('mae--geri')}"');
  print('Match test 1: ${normalize('mae  geri') == 'mae geri'}');
}
