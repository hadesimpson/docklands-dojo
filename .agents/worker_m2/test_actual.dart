import 'package:docklands_dojo/services/fuzzy_match_service.dart';
import 'package:docklands_dojo/services/search_service.dart';

void main() {
  // Test actual FuzzyMatchService
  final fuzzy = FuzzyMatchService();
  final r1 = fuzzy.normalize('mae  geri');
  print('FuzzyMatch normalize("mae  geri"): "$r1"');
  print('FuzzyMatch collapse works: ${r1 == "mae geri"}');

  // Test actual SearchService
  final r2 = SearchService.normalize('mae  geri');
  print('Search normalize("mae  geri"): "$r2"');
  print('Search collapse works: ${r2 == "mae geri"}');

  // Test the trim
  final r3 = fuzzy.normalize('  hello  ');
  print('FuzzyMatch trim test: "$r3"');
}
