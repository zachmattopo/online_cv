class Education {
  final String qualification;
  final String institution;
  final String location;
  final String date;
  final String? grade;
  final String description;

  const Education({
    required this.qualification,
    required this.institution,
    required this.location,
    required this.date,
    this.grade,
    required this.description,
  });
}
