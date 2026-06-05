import 'package:flutter_test/flutter_test.dart';
import 'package:journal_trend_analyzer/models/work_model.dart';

void main() {
  group('Abstract Reconstruction Tests', () {
    test('Handles null/empty inverted index', () {
      final workNull = Work.fromJson({});
      expect(workNull.abstractText, 'No abstract available.');

      final workEmpty = Work.fromJson({'abstract_inverted_index': <String, dynamic>{}});
      expect(workEmpty.abstractText, 'No abstract available.');
    });

    test('Reconstructs simple abstract in order', () {
      final json = {
        'title': 'Test title',
        'abstract_inverted_index': {
          'This': [0],
          'is': [1],
          'a': [2],
          'test': [3]
        }
      };
      
      final work = Work.fromJson(json);
      expect(work.abstractText, 'This is a test');
    });

    test('Reconstructs words with multiple indices', () {
      final json = {
        'title': 'Test title',
        'abstract_inverted_index': {
          'the': [0, 3],
          'cat': [1],
          'sat': [2],
          'mat': [4]
        }
      };

      final work = Work.fromJson(json);
      expect(work.abstractText, 'the cat sat the mat');
    });

    test('Handles index gaps gracefully by collapsing whitespace', () {
      final json = {
        'title': 'Test title',
        'abstract_inverted_index': {
          'hello': [1],
          'world': [3]
        }
      };

      final work = Work.fromJson(json);
      // Gaps at 0 and 2 are filled with empty strings, so [' ', 'hello', ' ', 'world']
      // which joins to ' hello  world' and collapses to 'hello world'
      expect(work.abstractText, 'hello world');
    });
  });
}
