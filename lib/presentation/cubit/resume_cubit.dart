import 'package:bloc/bloc.dart';
import 'package:online_cv/models/education.dart';
import 'package:online_cv/models/experience.dart';
import 'package:online_cv/models/journey_stop.dart';
import 'package:online_cv/models/project.dart';
import 'package:online_cv/models/skill.dart';
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
  final String sectionProjects;
  final String sectionSkills;
  final List<Experience> experiences;
  final List<Project> projects;
  final List<Skill> skills;
  final List<String> navLabels;
  final List<JourneyStop> journeyStops;
  final String heroTagline;
  final String heroLede;
  final String homeCity;
  final StopZone homeZone;
  final String projectsTitle;
  final String projectsSubtitle;
  final String stackTitle;
  final String stackSubtitle;
  final String plainCvTitle;
  final String plainCvSubtitle;
  final String contactTitle;
  final String contactSubtitle;
  final List<SocialLink> socialLinks;
  final String educationSectionTitle;
  final String educationCardTitle;
  final List<Education> educations;
  final String certificationsTitle;
  final List<Map<String, String>> certifications;
  final String contactSectionTitle;
  final String contactCardTitle;
  final String contactSummary;
  final List<Map<String, String>> contactButtons;
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
    required this.educations,
    required this.certificationsTitle,
    required this.certifications,
    required this.contactSectionTitle,
    required this.contactCardTitle,
    required this.contactSummary,
    required this.contactButtons,
    required this.contactInfoItems,
    required this.experiences,
    required this.projects,
    required this.skills,
    required this.navLabels,
    required this.socialLinks,
    required this.sectionExperience,
    required this.sectionProjects,
    required this.sectionSkills,
    required this.journeyStops,
    required this.heroTagline,
    required this.heroLede,
    required this.homeCity,
    required this.homeZone,
    required this.projectsTitle,
    required this.projectsSubtitle,
    required this.stackTitle,
    required this.stackSubtitle,
    required this.plainCvTitle,
    required this.plainCvSubtitle,
    required this.contactTitle,
    required this.contactSubtitle,
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
              educations: repo.getEducations(),
              certificationsTitle: repo.getCertificationsTitle(),
              certifications: repo.getCertifications(),
              contactSectionTitle: repo.getContactSectionTitle(),
              contactCardTitle: repo.getContactCardTitle(),
              contactSummary: repo.getContactSummary(),
              contactButtons: repo.getContactButtons(),
              contactInfoItems: repo.getContactInfoItems(),
              experiences: repo.getExperiences(),
              projects: repo.getProjects(),
              skills: repo.getSkills(),
              navLabels: repo.getNavLabels(),
              socialLinks: repo.getSocialLinks(),
              sectionExperience: repo.getSectionExperience(),
              sectionProjects: repo.getSectionProjects(),
              sectionSkills: repo.getSectionSkills(),
              journeyStops: repo.getJourneyStops(),
              heroTagline: repo.getHeroTagline(),
              heroLede: repo.getHeroLede(),
              homeCity: repo.getHomeCity(),
              homeZone: repo.getHomeZone(),
              projectsTitle: repo.getProjectsTitle(),
              projectsSubtitle: repo.getProjectsSubtitle(),
              stackTitle: repo.getStackTitle(),
              stackSubtitle: repo.getStackSubtitle(),
              plainCvTitle: repo.getPlainCvTitle(),
              plainCvSubtitle: repo.getPlainCvSubtitle(),
              contactTitle: repo.getContactTitle(),
              contactSubtitle: repo.getContactSubtitle(),
            );
          })(),
        );

  // For this simple app, no dynamic updates are implemented yet.
}
