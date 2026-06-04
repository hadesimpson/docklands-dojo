void main() {
  // r'\\s+' is a raw string, so the regex engine sees \\s+ (literal backslash + s+)
  final bad = RegExp(r'\\s+');
  // r'\s+' is a raw string, so the regex engine sees \s+ (whitespace class)
  final good = RegExp(r'\s+');

  const test = 'hello  world';
  print('Bad regex matches whitespace: ${bad.hasMatch(test)}');
  print('Good regex matches whitespace: ${good.hasMatch(test)}');
  print('Bad replaceAll: "${test.replaceAll(bad, " ")}"');
  print('Good replaceAll: "${test.replaceAll(good, " ")}"');
}
