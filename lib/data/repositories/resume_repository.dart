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

  List<Map<String, dynamic>> getContactButtons() => contactButtons;

  List<Map<String, String>> getContactInfoItems() => contactInfoItems;

  String getEducationSectionTitle() => educationSectionTitle;

  String getEducationCardTitle() => educationCardTitle;

  String getDegreeTitle() => degreeTitle;

  String getDegreeInstitution() => degreeInstitution;

  String getDegreeDate() => degreeDate;

  String getDegreeDescription() => degreeDescription;

  String getCertificationsTitle() => certificationsTitle;

  List<Map<String, String>> getCertifications() => certifications;

  List getExperiences() => staticExperiences;

  List getSkills() => staticSkills;

  List<String> getNavLabels() => navLabels;

  String getSectionExperience() => sectionExperience;

  String getSectionSkills() => sectionSkills;
}
