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

