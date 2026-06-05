import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/work_model.dart';

class OpenAlexResponse {
  final List<Work> works;
  final int totalCount;

  OpenAlexResponse({required this.works, required this.totalCount});
}

class OpenAlexService {
  static const String _baseUrl = 'api.openalex.org';
  static const String _path = '/works';
  
  // A polite mailto email as recommended by OpenAlex API guidelines
  static const String _mailto = 'student.journalanalyzer@fpt.edu.vn';

  final http.Client _client;

  OpenAlexService({http.Client? client}) : _client = client ?? http.Client();

  /// Searches OpenAlex for works related to the provided [query].
  /// Returns an [OpenAlexResponse] object.
  Future<OpenAlexResponse> searchWorks(String query, {int page = 1, int perPage = 100}) async {
    if (query.trim().isEmpty) return OpenAlexResponse(works: [], totalCount: 0);

    final queryParameters = {
      'search': query,
      'page': page.toString(),
      'per_page': perPage.toString(),
      'mailto': _mailto,
    };

    final uri = Uri.https(_baseUrl, _path, queryParameters);

    try {
      final response = await _client.get(uri).timeout(
        const Duration(seconds: 15),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List? ?? [];
        final meta = data['meta'] as Map<String, dynamic>? ?? {};
        final totalCount = meta['count'] as int? ?? 0;

        final works = results
            .map((workJson) => Work.fromJson(workJson as Map<String, dynamic>))
            .toList();

        return OpenAlexResponse(works: works, totalCount: totalCount);
      } else {
        throw Exception(
            'Failed to load publication data (HTTP ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
