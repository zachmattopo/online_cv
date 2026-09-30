class UrlLink {
  final String url;
  final String label;

  const UrlLink({
    required this.url,
    required this.label,
  });
}

class Experience {
  final String company;
  final String position;
  final String location;
  final String date;
  final List<String> highlights;
  final List<UrlLink> urls;

  const Experience({
    required this.company,
    required this.position,
    required this.location,
    required this.date,
    required this.highlights,
    this.urls = const [],
  });
}

