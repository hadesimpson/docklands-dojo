import 'package:docklands_dojo/services/fuzzy_match_service.dart';

void main() {
  final service = FuzzyMatchService();
  final result = service.normalize('mae  geri');
  print('Result: "$result"');
  print('Length: ${result.length}');
  print('Expected: "mae geri"');
  print('Match: ${result == 'mae geri'}');

  // Also test with 3 spaces
  final result2 = service.normalize('mae   geri');
  print('3-space result: "$result2"');
  print('3-space match: ${result2 == 'mae geri'}');
}
