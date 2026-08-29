import 'package:flutter/material.dart';

import '../models/repository_item.dart';

const featuredProjects = <FeaturedProject>[
  FeaturedProject(
    title: 'Money Mate',
    kicker: 'PERSONAL FINANCE',
    description:
        'A focused Flutter experience for tracking transactions, organizing money, and keeping everyday finances clear.',
    tags: ['Flutter', 'Dart', 'Finance', 'Local data'],
    icon: Icons.account_balance_wallet_rounded,
    url: 'https://github.com/Sonykhan1121/money_mate',
    colors: [0xFF31D6A6, 0xFF137F73],
  ),
  FeaturedProject(
    title: 'Hand Gesture Detector',
    kicker: 'COMPUTER VISION',
    description:
        'A production-minded Flutter extension with custom gesture mappings, efficient state handling, and richer detection output.',
    tags: ['Flutter', 'TFLite', 'Gestures', 'Package'],
    icon: Icons.pan_tool_alt_rounded,
    url: 'https://github.com/Sonykhan1121/flutter-hand-gesture-detector',
    colors: [0xFF8B7CFF, 0xFF4A43A8],
  ),
  FeaturedProject(
    title: 'BD SIM Validator',
    kicker: 'DART PACKAGE',
    description:
        'A reusable validator and operator detector for Bangladeshi mobile numbers across GP, Robi, Banglalink, Teletalk, and Airtel.',
    tags: ['Dart', 'Validation', 'Open source', 'API'],
    icon: Icons.sim_card_rounded,
    url: 'https://github.com/Sonykhan1121/bd_sim_validator',
    colors: [0xFF4CC9F0, 0xFF1764A8],
  ),
  FeaturedProject(
    title: 'Deshi10',
    kicker: 'ANDROID ECOMMERCE',
    description:
        'A native Android shopping app with product discovery, cart management, account flows, and payment-oriented experiences.',
    tags: ['Android', 'Java', 'Ecommerce', 'Payments'],
    icon: Icons.shopping_cart_rounded,
    url: 'https://github.com/Sonykhan1121/Android-Ecommerce-app',
    colors: [0xFFFFB86C, 0xFFB85B30],
  ),
  FeaturedProject(
    title: 'Our Admin Panel',
    kicker: 'WINDOWS DESKTOP',
    description:
        'A Flutter-based Windows administration surface for uploading and managing portfolio content from a desktop workflow.',
    tags: ['Flutter', 'Windows', 'Admin', 'Desktop'],
    icon: Icons.desktop_windows_rounded,
    url: 'https://github.com/Sonykhan1121/OurAdminPanel',
    colors: [0xFF55A8FF, 0xFF3359B8],
  ),
  FeaturedProject(
    title: 'Face Recognition',
    kicker: 'ON-DEVICE ML',
    description:
        'Flutter and TensorFlow Lite experiments focused on face detection and recognition workflows for mobile applications.',
    tags: ['Flutter', 'TFLite', 'ML', 'Mobile'],
    icon: Icons.face_retouching_natural_rounded,
    url:
        'https://github.com/Sonykhan1121/Face-recognition-with-Tflite-and-flutter',
    colors: [0xFFFF7A9A, 0xFF9D3F75],
  ),
];

const projectDemos = <ProjectDemo>[
  ProjectDemo(
    title: 'Gesture-Controlled Mobile Stand',
    kicker: 'COMPUTER VISION + IOT',
    description:
        'A Flutter controller that turns hand gestures into touch-free camera movement, recording, zoom, face detection, and object-follow actions.',
    duration: '1:12',
    thumbnail: 'assets/images/projects/demos/gesture_mobile_stand.jpg',
    thumbnailAlignment: Alignment.center,
    url:
        'https://www.linkedin.com/feed/update/urn:li:activity:7478326601756123136/',
    tags: ['Flutter', 'Gestures', 'Computer vision'],
  ),
  ProjectDemo(
    title: 'Face Recognition AI in Action',
    kicker: 'LIVE PRODUCT DEMO',
    description:
        'A fast, card-free attendance flow that recognizes a face, records attendance, and synchronizes the result to the cloud.',
    duration: '0:55',
    thumbnail: 'assets/images/projects/demos/face_recognition_ai.jpg',
    url:
        'https://www.linkedin.com/feed/update/urn:li:activity:7414153747473526784/',
    tags: ['ML Kit', 'TensorFlow Lite', 'Cloud sync'],
  ),
  ProjectDemo(
    title: 'Smart Face Attendance System',
    kicker: 'END-TO-END SHOWCASE',
    description:
        'An offline-first Flutter attendance system with real-time recognition, mobile punch-in/out, cloud sync, and a REST-powered admin workflow.',
    duration: '1:13',
    thumbnail: 'assets/images/projects/demos/smart_attendance.jpg',
    url:
        'https://www.linkedin.com/feed/update/urn:li:activity:7400496353233203200/',
    tags: ['Flutter', 'SQLite', 'REST API'],
  ),
];

const currentTeam = <TeamMember>[
  TeamMember(
    name: 'Zubayar Ahmed',
    role: 'Full Stack Web Developer',
    image: 'assets/images/team/zubayar-ahmed.jpg',
  ),
  TeamMember(
    name: 'Pias',
    role: 'UI/UX Designer',
    image: 'assets/images/team/pias.jpg',
  ),
  TeamMember(
    name: 'Dolon Mondol',
    role: 'Software Developer',
    image: 'assets/images/team/dolon-mondol.jpg',
  ),
  TeamMember(
    name: 'Shuvo',
    role: 'Software Developer',
    image: 'assets/images/team/shuvo.jpg',
  ),
  TeamMember(
    name: 'Mir Sultan',
    role: 'SQA',
    image: 'assets/images/team/mir-sultan.jpg',
  ),
  TeamMember(
    name: 'Obaidul Haque',
    role: 'Backend Developer',
    image: 'assets/images/team/obaidul-haque.jpg',
  ),
];

const teamLeader = TeamMember(
  name: 'Zhang Geng',
  role: 'Company Leadership',
  image: 'assets/images/team/zhang-geng.jpg',
);

const repositories = <RepositoryItem>[
  RepositoryItem(
    name: 'Sonykhan1121',
    description:
        'The source for my GitHub developer profile, technical story, selected work, and activity presentation.',
    language: 'Other',
    category: 'Profile',
    url: 'https://github.com/Sonykhan1121/Sonykhan1121',
    updated: 'Aug 2026',
  ),
  RepositoryItem(
    name: 'neetcode-submissions',
    description:
        'My NeetCode problem-solving submissions and algorithm practice in Java.',
    language: 'Java',
    category: 'Problem solving',
    url: 'https://github.com/Sonykhan1121/neetcode-submissions',
    updated: 'Aug 2026',
  ),
  RepositoryItem(
    name: 'flutter-hand-gesture-detector',
    description:
        'A custom, production-ready hand-detection extension with advanced gesture mappings and optimized state management.',
    language: 'Dart',
    category: 'Package',
    url: 'https://github.com/Sonykhan1121/flutter-hand-gesture-detector',
    updated: 'Jul 2026',
  ),
  RepositoryItem(
    name: 'money_mate',
    description:
        'An easy-to-use Flutter app for tracking, managing, and organizing personal finances.',
    language: 'Dart',
    category: 'Mobile app',
    url: 'https://github.com/Sonykhan1121/money_mate',
    updated: 'Apr 2026',
  ),
  RepositoryItem(
    name: 'portfolio-website-flutter',
    description:
        'This responsive portfolio—built from scratch with Flutter for the web.',
    language: 'Dart',
    category: 'Web',
    url: 'https://github.com/Sonykhan1121/portfolio-website-flutter',
    updated: 'Mar 2026',
  ),
  RepositoryItem(
    name: 'Android-Ecommerce-app',
    description:
        'Deshi10: product browsing, cart management, account flows, and secure-payment experiences on Android.',
    language: 'Java',
    category: 'Mobile app',
    url: 'https://github.com/Sonykhan1121/Android-Ecommerce-app',
    updated: 'Feb 2026',
  ),
  RepositoryItem(
    name: 'bd_sim_validator',
    description:
        'A Dart package that validates Bangladeshi phone numbers and detects their mobile operator.',
    language: 'Dart',
    category: 'Package',
    url: 'https://github.com/Sonykhan1121/bd_sim_validator',
    updated: 'Feb 2026',
  ),
  RepositoryItem(
    name: 'OurAdminPanel',
    description:
        'A Flutter Windows admin panel for uploading and managing portfolio content.',
    language: 'Dart',
    category: 'Desktop',
    url: 'https://github.com/Sonykhan1121/OurAdminPanel',
    updated: 'Aug 2025',
  ),
  RepositoryItem(
    name: 'Problem-soving-with-Cplusplus',
    description:
        'A collection of C++ problem-solving exercises, algorithms, and competitive-programming practice.',
    language: 'C++',
    category: 'Problem solving',
    url: 'https://github.com/Sonykhan1121/Problem-soving-with-Cplusplus',
    updated: 'Jul 2025',
  ),
  RepositoryItem(
    name: 'Flutter-Apps-',
    description:
        'A growing collection of Flutter application experiments and reusable implementation patterns.',
    language: 'Dart',
    category: 'Learning',
    url: 'https://github.com/Sonykhan1121/Flutter-Apps-',
    updated: 'Jun 2025',
  ),
  RepositoryItem(
    name: 'THT-Desktop-App',
    description:
        'Desktop application work for operational workflows at THT-Space.',
    language: 'C++',
    category: 'Desktop',
    url: 'https://github.com/Sonykhan1121/THT-Desktop-App',
    updated: 'Apr 2025',
  ),
  RepositoryItem(
    name: 'Flutter-Full-Stack-Development',
    description:
        'Full-stack Flutter learning work spanning interfaces, application logic, services, and data.',
    language: 'Dart',
    category: 'Learning',
    url: 'https://github.com/Sonykhan1121/Flutter-Full-Stack-Development',
    updated: 'Apr 2025',
  ),
  RepositoryItem(
    name: 'HTML-CSS',
    description:
        'Responsive interface and layout practice using semantic HTML and modern CSS.',
    language: 'HTML',
    category: 'Web',
    url: 'https://github.com/Sonykhan1121/HTML-CSS',
    updated: 'Apr 2025',
  ),
  RepositoryItem(
    name: 'Learning-Shopify-A-to-Z',
    description:
        'Structured Shopify and Liquid learning material with source code, supporting files, and documentation.',
    language: 'Liquid',
    category: 'Web',
    url: 'https://github.com/Sonykhan1121/Learning-Shopify-A-to-Z',
    updated: 'Mar 2025',
  ),
  RepositoryItem(
    name: 'Working-with-Faces-Tflite-',
    description:
        'Flutter experiments for on-device face workflows powered by TensorFlow Lite.',
    language: 'Dart',
    category: 'Machine learning',
    url: 'https://github.com/Sonykhan1121/Working-with-Faces-Tflite-',
    updated: 'Mar 2025',
  ),
  RepositoryItem(
    name: 'Face-recognition-with-Tflite-and-flutter',
    description:
        'A mobile face-recognition prototype combining Flutter and TensorFlow Lite.',
    language: 'C++',
    category: 'Machine learning',
    url:
        'https://github.com/Sonykhan1121/Face-recognition-with-Tflite-and-flutter',
    updated: 'Mar 2025',
  ),
  RepositoryItem(
    name: 'Flutter-Firebase-By-CLI',
    description:
        'A concise reference for configuring and using Firebase in Flutter through the command-line workflow.',
    language: 'Dart',
    category: 'Learning',
    url: 'https://github.com/Sonykhan1121/Flutter-Firebase-By-CLI',
    updated: 'Feb 2025',
  ),
  RepositoryItem(
    name: 'Flutter-API-Integration',
    description:
        'API-integration patterns and experiments for Flutter applications.',
    language: 'C++',
    category: 'Learning',
    url: 'https://github.com/Sonykhan1121/Flutter-API-Integration',
    updated: 'Feb 2025',
  ),
  RepositoryItem(
    name: 'Learning-Flutter-',
    description:
        'Progressive Flutter learning projects covering widgets, application structure, and native integrations.',
    language: 'C++',
    category: 'Learning',
    url: 'https://github.com/Sonykhan1121/Learning-Flutter-',
    updated: 'Jan 2025',
  ),
  RepositoryItem(
    name: 'ProblemSolving_py',
    description:
        'Python solutions for programming challenges, core algorithms, and data structures.',
    language: 'Python',
    category: 'Problem solving',
    url: 'https://github.com/Sonykhan1121/ProblemSolving_py',
    updated: 'Dec 2024',
  ),
  RepositoryItem(
    name: 'Python-Projects',
    description:
        'Small Python projects created to explore practical programming concepts and automation.',
    language: 'Python',
    category: 'Learning',
    url: 'https://github.com/Sonykhan1121/Python-Projects',
    updated: 'Aug 2024',
  ),
  RepositoryItem(
    name: 'MySql_practice',
    description:
        'SQL exercises for relational data modeling, querying, and database fundamentals.',
    language: 'Other',
    category: 'Data',
    url: 'https://github.com/Sonykhan1121/MySql_practice',
    updated: 'Jul 2024',
  ),
  RepositoryItem(
    name: 'AddItem',
    description:
        'An Android item-management feature created for the Gentle Park application.',
    language: 'Kotlin',
    category: 'Mobile app',
    url: 'https://github.com/Sonykhan1121/AddItem',
    updated: 'Jan 2024',
  ),
  RepositoryItem(
    name: 'GentlePark',
    description:
        'A Kotlin Android application developed as part of the Gentle Park product workflow.',
    language: 'Kotlin',
    category: 'Mobile app',
    url: 'https://github.com/Sonykhan1121/GentlePark',
    updated: 'Jan 2024',
  ),
  RepositoryItem(
    name: 'BangladeshApp',
    description:
        'A native Android app presenting Bangladesh-focused content and mobile UI patterns.',
    language: 'Kotlin',
    category: 'Mobile app',
    url: 'https://github.com/Sonykhan1121/BangladeshApp',
    updated: 'Dec 2023',
  ),
  RepositoryItem(
    name: 'BD-GK-Quiz-App',
    description:
        'A Kotlin quiz app for practicing Bangladesh general-knowledge questions.',
    language: 'Kotlin',
    category: 'Mobile app',
    url: 'https://github.com/Sonykhan1121/BD-GK-Quiz-App',
    updated: 'Dec 2023',
  ),
  RepositoryItem(
    name: 'LoginSignupApp',
    description:
        'A focused Android implementation of account registration and sign-in flows.',
    language: 'Kotlin',
    category: 'Mobile app',
    url: 'https://github.com/Sonykhan1121/LoginSignupApp',
    updated: 'Dec 2023',
  ),
  RepositoryItem(
    name: 'RecycleViewDesign',
    description:
        'Native Android UI experiments focused on RecyclerView layout and interaction patterns.',
    language: 'Kotlin',
    category: 'Learning',
    url: 'https://github.com/Sonykhan1121/RecycleViewDesign',
    updated: 'Dec 2023',
  ),
  RepositoryItem(
    name: 'Splash_Screen',
    description:
        'A reusable Android splash-screen implementation written in Kotlin.',
    language: 'Kotlin',
    category: 'Learning',
    url: 'https://github.com/Sonykhan1121/Splash_Screen',
    updated: 'Dec 2023',
  ),
  RepositoryItem(
    name: 'Android_Development',
    description:
        'A foundation repository for native Android development exercises in Kotlin.',
    language: 'Kotlin',
    category: 'Learning',
    url: 'https://github.com/Sonykhan1121/Android_Development',
    updated: 'Dec 2023',
  ),
  RepositoryItem(
    name: 'StudentManagementSystem_JavaSwing',
    description: 'A desktop student-management system built with Java Swing.',
    language: 'Java',
    category: 'Desktop',
    url: 'https://github.com/Sonykhan1121/StudentManagementSystem_JavaSwing',
    updated: 'Sep 2023',
  ),
  RepositoryItem(
    name: 'Mcq_question_answer',
    description:
        'A Python MCQ program that accepts answers and calculates the final score.',
    language: 'Python',
    category: 'Learning',
    url: 'https://github.com/Sonykhan1121/Mcq_question_answer',
    updated: 'Jul 2023',
  ),
];
