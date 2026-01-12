import 'package:bloc/bloc.dart';
import 'package:online_cv/models/social_link.dart';
import '../../data/repositories/resume_repository.dart';

class ResumeState {
  final String appTitle;
  final String name;
  final String heroTitle;
  final String heroSubtitle;
  final String heroDescription;
  final String heroSemanticsLabel;
  final String profileImageUrl;
  final String aboutSectionTitle;
  final String aboutSummaryTitle;
  final String aboutSummary;
  final List<Map<String, String>> aboutInfoItems;
  final String sectionExperience;
  final String sectionSkills;
  final List experiences;
  final List skills;
  final List navLabels;
  final List<SocialLink> socialLinks;
  final String educationSectionTitle;
  final String educationCardTitle;
  final String degreeTitle;
  final String degreeInstitution;
  final String degreeDate;
  final String degreeDescription;
  final String certificationsTitle;
  final List<Map<String, String>> certifications;
  final String contactSectionTitle;
  final String contactCardTitle;
  final String contactSummary;
  final List<Map<String, dynamic>> contactButtons;
  final List<Map<String, String>> contactInfoItems;

  ResumeState({
    required this.appTitle,
    required this.name,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.heroDescription,
    required this.heroSemanticsLabel,
    required this.profileImageUrl,
    required this.aboutSectionTitle,
    required this.aboutSummaryTitle,
    required this.aboutSummary,
    required this.aboutInfoItems,
    required this.educationSectionTitle,
    required this.educationCardTitle,
    required this.degreeTitle,
    required this.degreeInstitution,
    required this.degreeDate,
    required this.degreeDescription,
    required this.certificationsTitle,
    required this.certifications,
    required this.contactSectionTitle,
    required this.contactCardTitle,
    required this.contactSummary,
    required this.contactButtons,
    required this.contactInfoItems,
    required this.experiences,
    required this.skills,
    required this.navLabels,
    required this.socialLinks,
    required this.sectionExperience,
    required this.sectionSkills,
  });
}

class ResumeCubit extends Cubit<ResumeState> {
  ResumeCubit({ResumeRepository? repository})
      : super(
          (() {
            // Optional repository enables dependency injection/mocking for tests and swapping data sources.
            final repo = repository ?? ResumeRepository();

            return ResumeState(
              appTitle: repo.getAppTitle(),
              name: repo.getName(),
              heroTitle: repo.getHeroTitle(),
              heroSubtitle: repo.getHeroSubtitle(),
              heroDescription: repo.getHeroDescription(),
              heroSemanticsLabel: repo.getHeroSemanticsLabel(),
              profileImageUrl: repo.getProfileImageUrl(),
              aboutSectionTitle: repo.getAboutSectionTitle(),
              aboutSummaryTitle: repo.getAboutSummaryTitle(),
              aboutSummary: repo.getAboutSummary(),
              aboutInfoItems: repo.getAboutInfoItems(),
              educationSectionTitle: repo.getEducationSectionTitle(),
              educationCardTitle: repo.getEducationCardTitle(),
              degreeTitle: repo.getDegreeTitle(),
              degreeInstitution: repo.getDegreeInstitution(),
              degreeDate: repo.getDegreeDate(),
              degreeDescription: repo.getDegreeDescription(),
              certificationsTitle: repo.getCertificationsTitle(),
              certifications: repo.getCertifications(),
              contactSectionTitle: repo.getContactSectionTitle(),
              contactCardTitle: repo.getContactCardTitle(),
              contactSummary: repo.getContactSummary(),
              contactButtons: repo.getContactButtons(),
              contactInfoItems: repo.getContactInfoItems(),
              experiences: repo.getExperiences(),
              skills: repo.getSkills(),
              navLabels: repo.getNavLabels(),
              socialLinks: repo.getSocialLinks(),
              sectionExperience: repo.getSectionExperience(),
              sectionSkills: repo.getSectionSkills(),
            );
          })(),
        );

  // For this simple app, no dynamic updates are implemented yet.
}
