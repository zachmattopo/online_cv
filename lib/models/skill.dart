import 'package:flutter/material.dart';

class Skill {
  final String name;
  final String level;
  final List<String> technologies;
  final IconData icon;

  const Skill({
    required this.name,
    required this.level,
    required this.technologies,
    required this.icon,
  });
}

final List<Skill> skills = [
  Skill(
    name: 'Mobile Technologies',
    level: 'Advanced',
    icon: Icons.phone_android,
    technologies: [
      'Flutter',
      'Dart',
      'Swift',
      'iOS',
      'Android',
      'Real-time comms (WebSocket)',
      'Database (SQLite & NoSQL)',
      'BLoC / Provider',
      'Geolocation',
      'REST API',
    ],
  ),
  Skill(
    name: 'Web Technologies',
    level: 'Intermediate',
    icon: Icons.web,
    technologies: [
      'Java',
      'jQuery',
      'HTML',
      'Spring Boot',
    ],
  ),
  Skill(
    name: 'Development Tools',
    level: 'Advanced',
    icon: Icons.build,
    technologies: [
      'Git',
      'Jira',
      'AWS S3',
      'Confluence',
      'VS Code',
      'XCode',
      'Android Studio',
      'Figma',
      'Postman',
      'Codemagic CI/CD',
      'Firebase Remote Config',
      'Firebase A/B Testing',
      'Firebase App Distribution',
      'Firebase Crashlytics',
      'Firebase Google Analytics',
      'Firebase Performance Monitoring',
    ],
  ),
  Skill(
    name: 'Monitoring & Analytics',
    level: 'Intermediate',
    icon: Icons.analytics,
    technologies: [
      'Adobe Experience Manager',
      'Dynatrace',
    ],
  ),
];
