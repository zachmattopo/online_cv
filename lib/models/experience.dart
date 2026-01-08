class UrlLink {
  final String url;
  final String label;

  const UrlLink({
    required this.url,
    required this.label,
  });
}

class Experience {
  final String company;
  final String position;
  final String location;
  final String date;
  final List<String> highlights;
  final List<UrlLink> urls;

  const Experience({
    required this.company,
    required this.position,
    required this.location,
    required this.date,
    required this.highlights,
    this.urls = const [],
  });
}

final List<Experience> experiences = [
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
