class Book {
  const Book({
    required this.id,
    required this.title,
    required this.authors,
    required this.summary,
    this.coverId,
    this.firstPublishYear,
    this.publishers = const [],
    this.languages = const [],
    this.subjects = const [],
  });

  final String id;
  final String title;
  final List<String> authors;
  final String summary;
  final int? coverId;
  final int? firstPublishYear;
  final List<String> publishers;
  final List<String> languages;
  final List<String> subjects;

  String get authorsText =>
      authors.isEmpty ? 'Autor não informado' : authors.join(', ');

  String? get coverUrl =>
      coverId == null ? null : 'https://covers.openlibrary.org/b/id/$coverId-M.jpg';

  factory Book.fromOpenLibraryJson(Map<String, dynamic> json) {
    final title = _asString(json['title']) ?? 'Título não informado';
    final authors = _asStringList(json['author_name']);
    final publishers = _asStringList(json['publisher']);
    final languages = _asStringList(json['language']);
    final subjects = _asStringList(json['subject']);
    final firstPublishYear = _asInt(json['first_publish_year']);
    final coverId = _asInt(json['cover_i']);
    final firstSentence = _extractFirstSentence(json['first_sentence']);

    final rawKey = _asString(json['key']);
    final fallbackId = [
      title,
      authors.join('-'),
      firstPublishYear?.toString() ?? 'sem-ano',
    ].join('|');

    return Book(
      id: rawKey?.isNotEmpty == true ? rawKey! : fallbackId,
      title: title,
      authors: authors,
      coverId: coverId,
      firstPublishYear: firstPublishYear,
      publishers: publishers,
      languages: languages,
      subjects: subjects,
      summary: firstSentence ??
          _buildFallbackSummary(
            authors: authors,
            year: firstPublishYear,
            subjects: subjects,
          ),
    );
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: _asString(json['id']) ?? '',
      title: _asString(json['title']) ?? 'Título não informado',
      authors: _asStringList(json['authors']),
      summary: _asString(json['summary']) ?? 'Resumo não disponível.',
      coverId: _asInt(json['coverId']),
      firstPublishYear: _asInt(json['firstPublishYear']),
      publishers: _asStringList(json['publishers']),
      languages: _asStringList(json['languages']),
      subjects: _asStringList(json['subjects']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'authors': authors,
      'summary': summary,
      'coverId': coverId,
      'firstPublishYear': firstPublishYear,
      'publishers': publishers,
      'languages': languages,
      'subjects': subjects,
    };
  }

  static String _buildFallbackSummary({
    required List<String> authors,
    required int? year,
    required List<String> subjects,
  }) {
    if (subjects.isNotEmpty) {
      final selected = subjects.take(3).join(', ');
      return 'Temas relacionados: $selected.';
    }

    final authorText =
        authors.isEmpty ? 'autor não informado' : authors.first;
    final yearText = year == null ? '' : ', publicado originalmente em $year';

    return 'Livro de $authorText$yearText.';
  }

  static String? _extractFirstSentence(dynamic value) {
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }

    if (value is List && value.isNotEmpty) {
      return _extractFirstSentence(value.first);
    }

    if (value is Map && value['value'] != null) {
      return _extractFirstSentence(value['value']);
    }

    return null;
  }

  static String? _asString(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  static int? _asInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '');
  }

  static List<String> _asStringList(dynamic value) {
    if (value is List) {
      return value
          .map((item) => item.toString().trim())
          .where((item) => item.isNotEmpty)
          .toList();
    }

    if (value is String && value.trim().isNotEmpty) {
      return [value.trim()];
    }

    return const [];
  }
}