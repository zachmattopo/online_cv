class Project {
  final String name;
  final String description;
  final String? period;
  final List<String> highlights;
  final String? url;
  final String? imagePath;

  const Project({
    required this.name,
    required this.description,
    this.period,
    this.highlights = const [],
    this.url,
    this.imagePath,
  });
}
