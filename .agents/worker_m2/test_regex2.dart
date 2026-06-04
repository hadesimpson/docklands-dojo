void main() {
  // The actual code from the service
  var result = 'mae  geri';
  result = result.replaceAll(RegExp(r'\\s+'), ' ').trim();
  print('After replaceAll with r"\\\\s+": "$result"');
  print('Whitespace collapsed: ${result == "mae geri"}');

  // Also test what happens after hyphen replacement
  result = 'mae--geri';
  result = result.replaceAll('-', ' ');
  result = result.replaceAll(RegExp(r'\\s+'), ' ').trim();
  print('After hyphen+collapse: "$result"');
}
