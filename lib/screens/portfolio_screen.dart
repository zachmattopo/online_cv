import 'package:flutter/material.dart';
import 'package:super_sliver_list/super_sliver_list.dart';
import '../widgets/hero_section.dart';
import '../widgets/about_section.dart';
import '../widgets/experience_section.dart';
import '../widgets/skills_section.dart';
import '../widgets/education_section.dart';
import '../widgets/contact_section.dart';
import '../widgets/app_bar_widget.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final ScrollController _scrollController = ScrollController();
  final ListController _listController = ListController();
  bool _isFabVisible = false;

  final List<GlobalKey> _sectionKeys = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
  ];

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.offset > 0) {
        setState(() {
          _isFabVisible = true;
        });
      } else if (_scrollController.offset == 0) {
        setState(() {
          _isFabVisible = false;
        });
      }
    });
    super.initState();
  }

  void _scrollToSection(int index) {
    _listController.animateToItem(
      index: index,
      scrollController: _scrollController,
      alignment: 0.0,
      duration: (estimatedDistance) => Duration(milliseconds: 500),
      curve: (estimatedDistance) => Curves.easeOutCubic,
    );
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          AppBarWidget(onNavigate: _scrollToSection),
          SuperSliverList(
            listController: _listController,
            delegate: SliverChildListDelegate([
              HeroSection(key: _sectionKeys[0]),
              AboutSection(key: _sectionKeys[1]),
              ExperienceSection(key: _sectionKeys[2]),
              SkillsSection(key: _sectionKeys[3]),
              EducationSection(key: _sectionKeys[4]),
              ContactSection(key: _sectionKeys[5]),
            ]),
          ),
        ],
      ),
      floatingActionButton: _isFabVisible
          ? FloatingActionButton(
              tooltip: 'Back to top',
              onPressed: _scrollToTop,
              child: const Icon(Icons.arrow_upward),
            )
          : null,
    );
  }
}
