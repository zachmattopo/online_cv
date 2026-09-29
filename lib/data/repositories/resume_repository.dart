import 'package:online_cv/models/education.dart';
import 'package:online_cv/models/experience.dart';
import 'package:online_cv/models/journey_stop.dart';
import 'package:online_cv/models/project.dart';
import 'package:online_cv/models/skill.dart';
import 'package:online_cv/models/social_link.dart';

import '../../core/static_data.dart';

class ResumeRepository {
  const ResumeRepository();

  String getAppTitle() => appTitle;

  String getName() => appName;

  String getHeroTitle() => heroTitle;

  String getHeroSubtitle() => heroSubtitle;

  String getHeroDescription() => heroDescription;

  List<SocialLink> getSocialLinks() => socialLinks;

  String getHeroSemanticsLabel() => heroSemanticsLabel;

  String getProfileImageUrl() => profileImageUrl;

  String getAboutSectionTitle() => aboutSectionTitle;

  String getAboutSummaryTitle() => aboutSummaryTitle;

  String getAboutSummary() => aboutSummary;

  List<Map<String, String>> getAboutInfoItems() => aboutInfoItems;

  String getContactSectionTitle() => contactSectionTitle;

  String getContactCardTitle() => contactCardTitle;

  String getContactSummary() => contactSummary;

  List<Map<String, String>> getContactButtons() => contactButtons;

  List<Map<String, String>> getContactInfoItems() => contactInfoItems;

  String getEducationSectionTitle() => educationSectionTitle;

  String getEducationCardTitle() => educationCardTitle;

  List<Education> getEducations() => educations;

  String getCertificationsTitle() => certificationsTitle;

  List<Map<String, String>> getCertifications() => certifications;

  List<Experience> getExperiences() => staticExperiences;

  List<Project> getProjects() => staticProjects;

  List<Skill> getSkills() => staticSkills;

  List<JourneyStop> getJourneyStops() => journeyStops;

  String getHeroTagline() => heroTagline;

  String getHeroLede() => heroLede;

  String getHomeCity() => homeCity;

  StopZone getHomeZone() => homeZone;

  String getProjectsTitle() => projectsTitle;

  String getProjectsSubtitle() => projectsSubtitle;

  String getStackTitle() => stackTitle;

  String getStackSubtitle() => stackSubtitle;

  String getPlainCvTitle() => plainCvTitle;

  String getPlainCvSubtitle() => plainCvSubtitle;

  String getContactTitle() => contactTitle;

  String getContactSubtitle() => contactSubtitle;

  List<String> getNavLabels() => navLabels;

  String getSectionExperience() => sectionExperience;

  String getSectionProjects() => sectionProjects;

  String getSectionSkills() => sectionSkills;
}
