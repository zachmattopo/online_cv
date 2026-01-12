import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../models/experience.dart';
import '../models/skill.dart';
import '../models/social_link.dart';
import 'package:flutter/material.dart';

// App-level static strings and data consolidated here
const String appTitle = 'Hafiz Nordin - Online CV';
const String appName = 'Hafiz Nordin';

const String heroTitle = 'Hi, I\'m Hafiz Nordin';
const String heroSubtitle = 'Senior Software Engineer';

const String heroDescription =
    'A self-taught developer with a degree in Mechanical Engineering from 🇺🇸. Born and raised in 🇲🇾, now based in 🇬🇧.';

// Accessibility semantics for hero description (readable form)
const String heroSemanticsLabel =
    'A self-taught developer with a degree in Mechanical Engineering from the United States of America. Born and raised in Malaysia, now based in the United Kingdom.';

// Profile image URL
const String profileImageUrl = 'https://avatars.githubusercontent.com/u/39941205?v=4';

const List<String> navLabels = [
  'About',
  'Experience',
  'Skills',
  'Education',
  'Contact',
];

List<SocialLink> socialLinks = [
  SocialLink(
    label: 'LinkedIn',
    url: 'https://www.linkedin.com/in/hafiznordin/',
    icon: PhosphorIcons.linkedinLogo(PhosphorIconsStyle.fill),
  ),
  SocialLink(
    label: 'GitHub',
    url: 'https://github.com/zachmattopo',
    icon: PhosphorIcons.githubLogo(),
  ),
  SocialLink(
    label: 'Stack Overflow',
    url: 'https://stackoverflow.com/users/9166207/hafiz',
    icon: PhosphorIcons.stackOverflowLogo(),
  ),
];

// Section titles
const String sectionExperience = 'Experience';
const String sectionSkills = 'Skills & Technologies';

// About section strings
const String aboutSectionTitle = 'About Me';
const String aboutSummaryTitle = 'Professional Summary';
const String aboutSummary =
    'Versatile mobile developer with 7 years of experience specialising in Flutter/Dart development, with proven track record of delivering high-performance, user-centric apps serving millions of users in telecoms, HR, oil & gas, and healthcare sectors; in both startup and established enterprise environments.';

const List<Map<String, String>> aboutInfoItems = [
  {'label': 'Location', 'value': 'United Kingdom'},
  {'label': 'Availability', 'value': 'Immediate'},
  {'label': 'UK Visa Sponsorship', 'value': 'Not needed'},
  {'label': 'Visa Type', 'value': 'Dependent visa'},
];

final List<Experience> staticExperiences = [
  Experience(
    company: 'BT Group',
    position: 'Senior Software Engineer',
    location: 'Birmingham, England, UK',
    date: 'Aug 2022 - Mar 2025',
    highlights: [
      'Boosted CSAT score by 15% via collaboration with cross-functional teams (product management, QA, UX/UI design) to deliver high-quality features and projects in the EE app which serves over 10 million active users; most notably, the Data Gifting Uplift project.',
      'Maintained a crash-free rate within 99.7% by conducting thorough code reviews and ensuring performant Dart/Flutter code with clear separation of UI and business logic, supported by proper unit tests.',
      'Accelerated junior developer onboarding and reduced code-related incidents by 25% through structured mentoring of best practices, technical walkthroughs, and documentation support.',
      'Practiced Agile methodology (Scrum) to manage projects efficiently, contributing to a consistent sprint velocity.',
    ],
    urls: const [
      UrlLink(
        url: 'https://apps.apple.com/gb/app/ee-game-home-work-learn/id567457151',
        label: 'EE app on App Store',
      ),
      UrlLink(
        url: 'https://play.google.com/store/apps/details?id=uk.co.ee.myee',
        label: 'EE app on Play Store',
      ),
    ],
  ),
  Experience(
    company: 'GoGet.my',
    position: 'Senior Mobile Developer',
    location: 'Kuala Lumpur, Malaysia',
    date: 'Oct 2020 - Aug 2022',
    highlights: [
      'Developed and maintained the GoGetter app using Dart and Flutter, enhancing worker interactions with job postings on GoGet\'s part-time work platform.',
      'Pioneered the Employees Provident Fund (EPF) third-party API integration into the GoGetter app, enabling Malaysia\'s first embedded retirement savings feature for gig workers.',
      'Increased app ratings from 3.7 to 4.6 stars on Google Play Store and from 2.4 to 4.3 stars on Apple App Store by leading the implementation of In-app Review feature.',
      'Optimised app performance by troubleshooting and resolving issues, ensuring a crash-free rate above 95% across multiple iterations.',
    ],
    urls: const [
      UrlLink(
        url: 'https://apps.apple.com/my/app/goget-find-jobs/id1483160371',
        label: 'GoGetter app on App Store',
      ),
      UrlLink(
        url: 'https://play.google.com/store/apps/details?id=my.goget.gogetter',
        label: 'GoGetter app on Play Store',
      ),
    ],
  ),
  Experience(
    company: 'Arise Consulting Sdn. Bhd.',
    position: 'Mobile Application Developer',
    location: 'Kuala Lumpur, Malaysia',
    date: 'July 2019 - July 2020',
    highlights: [
      'Developed a mobile work portal app for an established oil and gas company in Malaysia, for the iOS and Android platforms with Dart and Flutter framework.',
      'Developed the frontend of the web work portal using Java, jQuery, HTML, Thymeleaf, and Spring Boot.',
    ],
  ),
  Experience(
    company: 'Trigger Next Sdn. Bhd.',
    position: 'Mobile Application Developer',
    location: 'Kuala Lumpur, Malaysia',
    date: 'January 2018 - June 2019',
    highlights: [
      'Developed and maintained an iOS chat app DotDotPlus, that integrates with 3rd party services and sensors for user notifications. Worked closely with UI/UX designers for a truly optimised app experience.',
    ],
    urls: const [
      UrlLink(
        url: 'https://apps.apple.com/id/app/dotdotplus/id1276921712',
        label: 'DotDotPlus app on App Store',
      ),
    ],
  ),
];

final List<Skill> staticSkills = [
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

// Education & certifications
const String educationSectionTitle = 'Education & Certifications';
const String educationCardTitle = 'Education';
const String degreeTitle = 'Bachelor of Engineering - Mechanical';
const String degreeInstitution = 'Vanderbilt University, Nashville TN, USA';
const String degreeDate = 'August 2011 - May 2015';
const String degreeDescription =
    'Studied Introduction to Programming with Java and Mechatronics with Arduino (C++), as part of my undergraduate\'s engineering degree.';

const String certificationsTitle = 'Certifications';

const List<Map<String, String>> certifications = [
  {
    'name': 'DevOps Fundamentals Certificate',
    'issuer': 'PeopleCert',
    'date': 'November 2020',
    'description': 'Learned to work in a DevOps environment under the full-stack approach.',
  },
  {
    'name': 'Accessibility Engagement Process Certificate',
    'issuer': 'BT Group',
    'date': 'October 2023',
    'description':
        'Ensured digital inclusion by adhering to WCAG 2.2 guidelines for accessible app content.',
  },
];

// Contact section strings and data
const String contactSectionTitle = 'Get In Touch';
const String contactCardTitle = 'Let\'s Connect';
const String contactSummary =
    'I\'m always interested in new opportunities and collaborations. Feel free to reach out!';

final List<Map<String, dynamic>> contactButtons = [
  {
    'label': 'Email',
    'subtitle': 'hafiz.nordin@icloud.com',
    'icon': Icons.email,
    'url': 'mailto:hafiz.nordin@icloud.com',
  },
  {
    'label': 'LinkedIn',
    'subtitle': 'Connect with me',
    'icon': PhosphorIcons.linkedinLogo(PhosphorIconsStyle.fill),
    'url': 'https://www.linkedin.com/in/hafiznordin/',
  },
];

const List<Map<String, String>> contactInfoItems = [
  {'label': 'Availability', 'value': 'Immediate'},
  {'label': 'Location', 'value': 'UK'},
  {'label': 'Visa sponsorship', 'value': 'Not needed'},
];
