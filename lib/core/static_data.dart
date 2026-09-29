import '../models/education.dart';
import '../models/experience.dart';
import '../models/journey_stop.dart';
import '../models/project.dart';
import '../models/skill.dart';
import '../models/social_link.dart';
import 'package:flutter/material.dart';

// App-level static strings and data consolidated here
const String appTitle = 'Hafiz Nordin | Online CV';
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
  'Journey',
  'Projects',
  'Stack',
  'Plain CV',
];

// Hero copy for the globe page. `**double asterisks**` mark bold runs.
const String heroTagline = 'Senior Software Engineer. Eight years shipping iOS, Android and Flutter apps.';
const String heroLede =
    'Self-taught developer with a mechanical engineering degree from Vanderbilt, USA. Born and raised in Malaysia, now in the UK: **available for work, no sponsorship needed**. Scroll to follow the route backwards, or jump to any stop below.';

// Where Hafiz is now, for the live clock in the nav and hero.
const String homeCity = 'Aberdeen';
const StopZone homeZone = StopZone.uk;

const List<SocialLink> socialLinks = [
  SocialLink(
    label: 'LinkedIn',
    url: 'https://www.linkedin.com/in/hafiznordin/',
  ),
  SocialLink(
    label: 'GitHub',
    url: 'https://github.com/zachmattopo',
  ),
  SocialLink(
    label: 'Stack Overflow',
    url: 'https://stackoverflow.com/users/9166207/hafiz',
  ),
];

// Section titles
const String sectionExperience = 'Experience';
const String sectionProjects = 'Projects';
const String sectionSkills = 'Skills & Technologies';

// About section strings
const String aboutSectionTitle = 'About Me';
const String aboutSummaryTitle = 'Professional Summary';
const String aboutSummary =
    'Senior Mobile Engineer with 8 years of experience delivering iOS and Android apps across telecoms, HR, oil and gas, and healthcare. Shipped Flutter features for BT/EE\'s 10M+ user app, improving customer satisfaction by 15% while sustaining 99.7% crash-free performance, and helped raise GoGetter\'s store ratings to 4.6 on Google Play and 4.3 on the App Store. Expertise includes Flutter, Dart, Firebase, BLoC/Cubit, REST APIs, offline-first design, app security, accessibility, and high-quality cross-functional delivery. More recently, has expanded into agentic AI development through hands-on work with Claude, Copilot, OpenCode, and local LLMs to build modern software products independently. Available for work in the UK with no sponsorship required.';

const List<Map<String, String>> aboutInfoItems = [
  {'label': 'Location', 'value': 'United Kingdom'},
  {'label': 'Availability', 'value': 'Immediate'},
  {'label': 'UK Visa Sponsorship', 'value': 'Not needed'},
  {'label': 'Visa Type', 'value': 'Dependant visa'},
  {'label': 'Languages', 'value': 'English (Proficient), Malay (Proficient), Spanish (Beginner)'},
  {'label': 'References', 'value': 'Available upon request'},
];

final List<Experience> staticExperiences = [
  Experience(
    company: 'Independent (Non-salaried)',
    position: 'Independent Software Developer & Professional Development',
    location: 'Aberdeen, Scotland, UK',
    date: 'Jan 2026 - Present',
    highlights: [
      'Built WhereToFuel, a real-time UK fuel-price finder using Flutter, Firebase and Node.js/TypeScript, with Firestore geospatial queries, Hive cache, scheduled Cloud Functions, Firebase App Check and security rules.',
      'Designed and developed the Movement to Work campaign website for Jobcentre Plus Aberdeen using Dart/Jaspr, semantic HTML and Tailwind CSS; configured automated GitHub Pages deployment through GitHub Actions.',
      'Continued structured professional development in agentic AI-assisted engineering, using Claude Code, GitHub Copilot, OpenCode and local LLMs while independently reviewing outputs and applying engineering judgement.',
    ],
  ),
  Experience(
    company: 'BT Group',
    position: 'Senior Software Engineer',
    location: 'Birmingham, England, UK',
    date: 'Aug 2022 - Mar 2025',
    logoPath: 'assets/images/logo_bt.png',
    highlights: [
      'Boosted CSAT score by 15% via collaboration with cross-functional teams (product management, QA, UX/UI design) to deliver high-quality features and projects in the EE app which serves over 10 million active users; most notably, the Data Gifting Uplift project.',
      'Maintained a crash-free rate within 99.7% by conducting thorough code reviews and ensuring performant Dart/Flutter code with clear separation of UI and business logic, supported by proper unit tests.',
      'Accelerated junior developer onboarding and reduced code-related incidents by 25% through structured mentoring of best practices, technical walkthroughs, and documentation support.',
      'Practiced Agile methodology (Scrum) to manage projects efficiently, contributing to a consistent sprint velocity.',
    ],
    urls: const [
      UrlLink(
        url: 'https://apps.apple.com/gb/app/ee-mobile-broadband-tech/id567457151',
        label: 'EE app on App Store',
      ),
      UrlLink(
        url: 'https://play.google.com/store/apps/details?id=uk.co.ee.myee',
        label: 'EE app on Play Store',
      ),
      UrlLink(url: 'https://www.bt.com/', label: 'Company website'),
    ],
  ),
  Experience(
    company: 'GoGet.my',
    position: 'Senior Mobile Developer',
    location: 'Kuala Lumpur, Malaysia',
    date: 'Oct 2020 - Aug 2022',
    logoPath: 'assets/images/logo_goget.png',
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
      UrlLink(
        url:
            'https://techtrp.com/news/2022/03/07/goget-becomes-the-first-gig-work-platform-to-provide-gig-workers-access-to-epf-via-app/',
        label: 'EPF feature in The Rakyat Post',
      ),
      UrlLink(url: 'https://goget.my/', label: 'Company website'),
    ],
  ),
  Experience(
    company: 'MIMOS Berhad',
    position: 'Professional Consultant',
    location: 'Kuala Lumpur, Malaysia',
    date: 'July 2020 - Sep 2020',
    logoPath: 'assets/images/logo_mimos.png',
    highlights: [
      'Studied the mobile appointment system\'s SRS and SDD to understand requirements for MyJanjiTemu KKM, a greenfield Flutter appointment-booking app built for the Malaysian Ministry of Health (KKM), later absorbed into the MySejahtera app.',
      'Implemented core screens per wireframe design and system requirements, including the app landing page, profile & reminder notification page, appointment listing page, hamburger expanded menu, \'ID tempahan\' widget, and \'Batal/Sahkan kehadiran\' widget.',
      'Built additional features including the create new appointment page, appointment details page, pre-booking disclaimer page, date-time picker widget (shared across booking and listing pages), and a redesigned appointment card widget UI.',
      'Developed a custom global snack bar widget for in-app notifications and a \'no internet connection\' global alert dialog, alongside a pagination feature for the appointments listing page.',
      'Implemented and integrated the appointments REST API, and carried out bug fixes throughout the development cycle.',
    ],
    urls: const [
      UrlLink(url: 'https://www.mimos.my/', label: 'Company website'),
    ],
  ),
  Experience(
    company: 'Arise Consulting Sdn. Bhd.',
    position: 'Mobile Application Developer',
    location: 'Kuala Lumpur, Malaysia',
    date: 'July 2019 - July 2020',
    logoPath: 'assets/images/logo_arise.png',
    highlights: [
      'Developed a mobile work portal app for an established oil and gas company in Malaysia, for the iOS and Android platforms with Dart and Flutter framework.',
      'Developed the frontend of the web work portal using Java, jQuery, HTML, Thymeleaf, and Spring Boot.',
    ],
    urls: const [
      UrlLink(url: 'https://www.arise-consulting.net/en/index.php', label: 'Company website'),
    ],
  ),
  Experience(
    company: 'Trigger Next Sdn. Bhd.',
    position: 'Mobile Application Developer',
    location: 'Kuala Lumpur, Malaysia',
    date: 'January 2018 - June 2019',
    logoPath: 'assets/images/logo_triggernext.png',
    highlights: [
      'Built and maintained DotDotPlus, an iOS social messaging chat app, using Swift (99%) and Objective-C (1%) using MVC architecture in Xcode.',
      'Integrated Socket.IO to enable real-time messaging between mobile clients and server, and connected 3rd-party services and device sensors to power user notifications.',
      'Collaborated closely with UI/UX designers to deliver a polished user experience aligned with Apple\'s Human Interface Guidelines.',
      'Implemented local data persistence with SQLite and integrated REST/JSON web services for backend communication.',
      'Leveraged key open-source libraries (Alamofire, SQLite, Kingfisher, Socket.IO Swift client) to accelerate development and improve app reliability.',
      'Owned features end-to-end across the full mobile development lifecycle: research, design, development, debugging, testing, and deployment.',
      'Worked within an Agile team, participating in sprint planning, daily scrums, and retrospectives.',
    ],
    urls: const [
      UrlLink(
        url: 'https://apps.apple.com/id/app/dotdotplus/id1276921712',
        label: 'DotDotPlus app on App Store',
      ),
      UrlLink(url: 'https://www.triggernext.com/home', label: 'Company website'),
    ],
  ),
  Experience(
    company: 'Intel Technology',
    position: 'Package Failure Analysis Engineer',
    location: 'Penang, Malaysia',
    date: 'August 2015 - July 2017',
    logoPath: 'assets/images/logo_intel.png',
    highlights: [
      'Led root cause investigations for factory excursion issues across Intel\'s global manufacturing sites, saving the company millions of dollars in potential yield loss.',
      'Identified the pick-and-place process as the root cause of unit damage across all factory modules, saving RM10 million per quarter in assembled units previously subject to yield loss.',
      'Delivered fast, high-quality analytical data on PGAT factory excursions using FESEM, FIB, CSAM, IRLC, and X-ray, enabling rapid root cause identification and corrective action.',
      'Developed recipes and Best Known Methods (BKMs) to streamline failure analysis, fault isolation, and root cause investigation processes.',
      'Collaborated proactively with factory modules to drive process yield improvement and eliminate recurring defect modes.',
      'Trained and certified LYA technicians to independently handle factory excursion issues without disrupting daily production output.',
      'Liaised cross-functionally with international teams across the USA and Japan, strengthening communication and coordination in a multinational manufacturing environment.',
    ],
    urls: const [
      UrlLink(url: 'https://www.intel.com/', label: 'Company website'),
    ],
  ),
  Experience(
    company: 'Vanderbilt Information Technology',
    position: 'Tech Hub Undergraduate Student Worker',
    location: 'Nashville, Tennessee, USA',
    date: 'April 2014 - May 2015',
    logoPath: 'assets/images/logo_vanderbilt.png',
    highlights: [
      'Delivered IT customer service to students, staff, and affiliates of the university with 86% CSAT.',
      'Daily routine involved communication with clients to troubleshoot IT problems regarding student and staff\'s university accounts, software applications and general Mac/Windows hardware issues.',
    ],
    urls: const [
      UrlLink(url: 'https://it.vanderbilt.edu/', label: 'Department website'),
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
      'iOS',
      'Android',
      'Swift',
      'REST API',
      'Local database (SQL & NoSQL)',
      'State management (BLoC / Stateful / etc.)',
      'Geolocation',
      'Real-time comms (WebSocket)',
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
      'Xcode',
      'Postman',
      'GitHub Actions CI/CD',
      'Agentic AI Coding',
      'Claude Code',
      'GitHub Copilot',
      'OpenCode',
      'Local LLMs',
      'Firebase Firestore',
      'Firebase Cloud Functions',
      'Firebase Remote Config',
      'Firebase App Check',
      'Firebase Crashlytics',
      'Firebase Performance Monitoring',
    ],
  ),
  Skill(
    name: 'Web Frameworks',
    level: 'Advanced',
    icon: Icons.language,
    technologies: [
      'Jaspr (Dart web framework)',
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
    name: 'Monitoring, CMS & CI/CD',
    level: 'Intermediate',
    icon: Icons.analytics,
    technologies: [
      'Adobe Experience Manager (AEM)',
      'Dynatrace',
      'Codemagic CI/CD',
    ],
  ),
];

final List<Project> staticProjects = [
  Project(
    name: 'WhereToFuel',
    description:
        'A real-time UK fuel price finder for Android, iOS, and Web (Flutter); powered by the government\'s Fuel Finder API and a Firebase backend.',
    period: 'Jan 2026 - Present',
    highlights: [
      'Architecture: Feature-first CLEAN architecture, flutter_bloc (Cubit) state management, get_it DI, go_router routing.',
      'Backend: Firebase Cloud Functions (Node.js/TypeScript, scheduled-only) polling the GOV.UK Fuel Finder API; Firestore with append-only price history and nightly daily-aggregate compaction.',
      'Client data: Direct Firestore geohash range queries; offline-first Hive cache (NoSQL db) with TTL-aligned stale-while-revalidate. Postcode geocoding via Postcodes.io (Hive-cached 30 days).',
      'Security: Firebase App Check (Play Integrity, App Attest, and reCAPTCHA); API credentials in Google Cloud Secret Manager; Firestore security rules enforcing read-only station data and user-scoped preference writes.',
      'Other: GDPR analytics consent gating; Firebase Remote Config for force-update enforcement and runtime map tile provider selection.',
    ],
    url: 'https://wheretofuel.co.uk',
    imagePath: 'assets/images/wtf_icon.png',
  ),
  Project(
    name: 'Movement To Work',
    description:
        'A Movement to Work campaign promotion website used in Jobcentre Plus Aberdeen (part of the UK government\'s Department for Work & Pensions), sharing my own first-hand experience as a participant through employment support, activities, outcomes, and Jobcentre Plus signposting.',
    period: 'Jul 2026',
    highlights: [
      'Developed with Dart and Jaspr as a statically pre-rendered website.',
      'Styled with Tailwind CSS v4 via jaspr_tailwind, using custom OKLCH design tokens and Stack Sans typography.',
      'Configured automated static deployment to GitHub Pages with GitHub Actions.',
      'Implemented progressive, CSS-only scroll-driven animations including hero parallax, a desktop horizontal content scrub, animated timelines, and interaction feedback.',
      'Designed for accessibility with semantic HTML, descriptive image and link labels, 44px minimum CTA targets, and full prefers-reduced-motion support.',
    ],
    url: 'https://zachmattopo.github.io/movement_to_work',
    imagePath: 'assets/images/mtw_logo.png',
    darkImagePath: 'assets/images/mtw_logo_dark.png',
  ),
];

// Education & certifications
const String educationSectionTitle = 'Education & Certifications';
const String educationCardTitle = 'Education';

const List<Education> educations = [
  Education(
    qualification: 'Bachelor of Engineering - Mechanical',
    institution: 'Vanderbilt University',
    location: 'Nashville TN, USA',
    date: 'August 2011 - May 2015',
    grade: 'Eng. CGPA 3.51 / Overall CGPA 3.22',
    description:
        'Studied Introduction to Programming with Java and Mechatronics with Arduino (C++), as part of my undergraduate\'s engineering degree.',
  ),
  Education(
    qualification: 'Science Stream',
    institution: 'MARA Junior Science College Pengkalan Chepa',
    location: 'Kelantan, Malaysia',
    date: 'Jan 2009 - Dec 2010',
    grade: 'CGPA 3.88 / 4.00',
    description:
        'Graduated with straight 9A+\'s in SPM (GCSE equivalent). Won the Outstanding Student Achievement Award from MARA in 2011. Awarded Malaysian government\'s full scholarship for tertiary education overseas at Vanderbilt University.',
  ),
];

const String certificationsTitle = 'Certifications';

const List<Map<String, String>> certifications = [
  {
    'name': 'Movement to Work Certificate',
    'issuer': 'Department for Work and Pensions (DWP)',
    'date': 'July 2026',
    'description':
        'A 2-week work experience placement as part of the government\'s Movement to Work programme for young people. Developed a website as the end-of-programme project to promote Movement to Work (see Projects).',
  },
  {
    'name': 'Accessibility Engagement Process Certificate',
    'issuer': 'BT Group',
    'date': 'October 2023',
    'description':
        'Ensured digital inclusion by adhering to WCAG 2.2 guidelines for accessible app content.',
  },
  {
    'name': 'Python For Beginner',
    'issuer': 'PEOPLElogy Berhad',
    'date': 'Feb 2021',
    'description':
        'Completed an introductory Python programming course covering core syntax, data structures, logic, and problem-solving fundamentals.',
  },
  {
    'name': 'DevOps Fundamentals Certificate',
    'issuer': 'PeopleCert',
    'date': 'November 2020',
    'description': 'Learned to work in a DevOps environment under the full-stack approach.',
  },
];

// Contact section strings and data
const String contactSectionTitle = 'Get In Touch';
const String contactCardTitle = 'Let\'s Connect';
const String contactSummary =
    'I\'m always interested in new opportunities and collaborations. Feel free to reach out!';

const List<Map<String, String>> contactButtons = [
  {
    'label': 'Email',
    'subtitle': 'hafiz.nordin@icloud.com',
    'url': 'mailto:hafiz.nordin@icloud.com',
  },
  {
    'label': 'LinkedIn',
    'subtitle': 'linkedin.com/in/hafiznordin',
    'url': 'https://www.linkedin.com/in/hafiznordin/',
  },
  {
    'label': 'Book a call',
    'subtitle': 'calendly.com/hafiz-nordin',
    'url': 'https://calendly.com/hafiz-nordin',
  },
];

const List<Map<String, String>> contactInfoItems = [
  {'label': 'Availability', 'value': 'Immediate'},
  {'label': 'Location', 'value': 'UK'},
  {'label': 'Visa sponsorship', 'value': 'Not needed'},
];

// Section copy for the globe page.
const String projectsTitle = 'Projects';
const String projectsSubtitle = 'Two shipped side projects, both written in Dart.';
const String stackTitle = 'Stack';
const String stackSubtitle = 'What I reach for, grouped by how well I know it.';
const String plainCvTitle = 'Plain CV';
const String plainCvSubtitle = 'Everything above, without the globe.';
const String contactTitle = 'Let’s talk.';
const String contactSubtitle = 'Available now in the UK, no visa sponsorship needed.';

/// The career globe, most recent stop first.
final List<JourneyStop> journeyStops = [
  JourneyStop(
    id: 'aberdeen',
    city: 'Aberdeen',
    region: 'Scotland, UK',
    code: 'ABZ',
    lat: 57.1497,
    lon: -2.0943,
    zone: StopZone.uk,
    year: '2026',
    subhead: 'Independent software developer, Jan 2026 → now.',
    summary:
        'Shipping independent work since January 2026: **WhereToFuel**, a real-time UK fuel-price finder in Flutter and Firebase, and the **Movement to Work campaign site** for Jobcentre Plus Aberdeen in Dart and Jaspr. Alongside both, structured practice in **agentic AI engineering** with Claude, Copilot, OpenCode and local LLMs, every output reviewed by hand.',
    facts: const {
      'status': 'available immediately',
      'uk_visa_sponsorship': 'not needed',
      'shipped': ['WhereToFuel', 'Movement to Work site'],
      'stack': ['Flutter', 'Firebase', 'TypeScript', 'Jaspr'],
    },
    roles: [staticExperiences[0]],
  ),
  JourneyStop(
    id: 'birmingham',
    city: 'Birmingham',
    region: 'England, UK',
    code: 'BHX',
    lat: 52.4862,
    lon: -1.8904,
    zone: StopZone.uk,
    year: '2022',
    subhead: 'Senior Software Engineer at BT Group, Aug 2022 → Mar 2025.',
    summary:
        'Shipped Flutter features to the **EE app’s 10M+ active users** with product, QA and design, most notably the **Data Gifting Uplift**, and lifted customer satisfaction **15%**. Held a **99.7% crash-free rate** through code review and tested, cleanly separated code, and **cut code-related incidents 25%** by mentoring junior developers.',
    facts: const {
      'csat': '+15%',
      'crash_free_rate': '99.7%',
      'incidents': '-25%',
      'stack': ['Flutter', 'Dart', 'BLoC', 'Scrum'],
    },
    roles: [staticExperiences[1]],
  ),
  JourneyStop(
    id: 'kuala-lumpur',
    city: 'Kuala Lumpur',
    region: 'Malaysia',
    code: 'KUL',
    lat: 3.139,
    lon: 101.6869,
    zone: StopZone.malaysia,
    year: '2018',
    subhead: 'Four roles, Jan 2018 → Aug 2022, from Swift to Flutter.',
    summary:
        'At GoGet, built Malaysia’s **first embedded retirement-savings (EPF) feature for gig workers** and lifted app ratings from **3.7 to 4.6 on Google Play and 2.4 to 4.3 on the App Store**. Before that: the Ministry of Health’s MyJanjiTemu app at MIMOS, an oil and gas work portal at Arise, and the DotDotPlus iOS messenger at Trigger Next.',
    facts: const {
      'play_store_rating': '3.7 → 4.6',
      'app_store_rating': '2.4 → 4.3',
      'crash_free_rate': '>95%',
      'roles': 4,
    },
    roles: [staticExperiences[2], staticExperiences[3], staticExperiences[4], staticExperiences[5]],
  ),
  JourneyStop(
    id: 'penang',
    city: 'Penang',
    region: 'Malaysia',
    code: 'PEN',
    lat: 5.2946,
    lon: 100.2627,
    zone: StopZone.malaysia,
    year: '2015',
    subhead: 'Package Failure Analysis Engineer at Intel, Aug 2015 → Jul 2017.',
    summary:
        'Before software, hardware. Traced unit damage across every factory module to the pick-and-place process, **saving RM10 million a quarter** in yield loss. Led root-cause investigations for factory excursions across Intel’s global sites with **FESEM, FIB, CSAM, IRLC and X-ray**, wrote Best Known Methods, and trained technicians to run excursions on their own.',
    facts: const {
      'saved_per_quarter': 'RM10M',
      'tools': ['FESEM', 'FIB', 'CSAM', 'X-ray'],
      'worked_with': ['Malaysia', 'USA', 'Japan'],
    },
    roles: [staticExperiences[6]],
  ),
  JourneyStop(
    id: 'nashville',
    city: 'Nashville',
    region: 'Tennessee, USA',
    code: 'BNA',
    lat: 36.1447,
    lon: -86.8027,
    zone: StopZone.usCentral,
    year: '2011',
    subhead: 'B.E. Mechanical Engineering, Vanderbilt University, 2011 → 2015.',
    summary:
        'Arrived on a **full Malaysian government scholarship** and left with a mechanical engineering degree (**engineering CGPA 3.51**). First code here: Java, and Arduino C++ for mechatronics. Also worked the university’s Tech Hub help desk, fixing accounts, software and hardware at **86% customer satisfaction**.',
    facts: const {
      'degree': 'B.E. Mechanical',
      'eng_cgpa': 3.51,
      'tech_hub_csat': '86%',
      'first_code': ['Java', 'Arduino C++'],
    },
    roles: [staticExperiences[7]],
    schooling: [educations[0]],
  ),
  JourneyStop(
    id: 'kelantan',
    city: 'Kelantan',
    region: 'Malaysia',
    code: 'KBR',
    lat: 6.1636,
    lon: 102.2829,
    zone: StopZone.malaysia,
    year: '2009',
    subhead: 'Science stream, MARA Junior Science College (MRSM) Pengkalan Chepa, 2009 → 2010.',
    summary:
        'Where it started. Graduated with **straight 9A+ in SPM** (the GCSE equivalent), won MARA’s **Outstanding Student Achievement Award** in 2011, and earned the government scholarship that took me to Vanderbilt.',
    facts: const {
      'spm': '9A+',
      'cgpa': '3.88 / 4.00',
      'award': 'MARA Outstanding Student Achievement, 2011',
    },
    schooling: [educations[1]],
  ),
];
