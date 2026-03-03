import 'package:flutter/cupertino.dart';

class NavigationController extends ChangeNotifier{
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  final List<String> menuItems = [
    "About",
    "Skills",
    "Projects",
    "Experience",
    "Contact"
  ];

  final List<Map<String, dynamic>> skillData = [
    {
      "title": "Flutter & Dart",
      "icon": "assets/icons/html_tag.png",
      "listOfSubTitle": ["Flutter Framework", "Dart Language", "Custom Widgets", "Animations", "Responsive UI"],
    },
    {
      "title": "State Management",
      "icon": "assets/icons/state_management_tag.png",
      "listOfSubTitle": ["Provider", "Riverpod", "BLoC Pattern", "GetX", "State Notifier"],
    },
    {
      "title": "Local Databases",
      "icon": "assets/icons/database_tag.png",
      "listOfSubTitle": ["SQLite", "Isar", "Hive", "SharedPreferences", "Secure Storage"],
    },
    {
      "title": "API Integration",
      "icon": "assets/icons/api_tag.png",
      "listOfSubTitle": ["REST APIs", "Dio", "HTTP Package", "JSON Serialization", "WebSockets"],
    },
    {
      "title": "Git & CI/CD",
      "icon": "assets/icons/git_tag.png",
      "listOfSubTitle": ["Git", "GitHub", "GitHub Actions", "Codemagic", "Fastlane"],
    },
  ];

  final List<Map<String, dynamic>> projectData = [
    {
      "title": "Money Mate",
      "description": "A personal finance management application built with Flutter, featuring expense tracking, category management, local database integration using Isar, and state management with Provider. Published on the Play Store.",
      "listOfTopics": ["Flutter", "Dart", "Isar", "Provider", "Play store"],
      "url": "https://github.com/Sonykhan1121/money_mate",
      "projectImagePreview": "assets/images/projects/money_mate_banner.jpg",
    },
    {
      "title": "Task Manager Pro",
      "description":
      "A productivity application with task management, reminders, categories, and analytics. Features offline-first architecture with local database sync.",
      "listOfTopics": ["Flutter", "Riverpod", "Isar", "Notifications"],
      "url": "https://github.com/sonykhan1121",
      "projectImagePreview": "assets/images/ecommerce.png",
    },
    {
      "title": "Weather Dashboard",
      "description":
      "A beautifully designed weather app displaying real-time data, forecasts, and location-based suggestions with smooth animations and transitions.",
      "listOfTopics": ["Flutter", "Dart", "OpenWeather API", "BLoC"],
      "url": "https://github.com/sonykhan1121",
      "projectImagePreview": "assets/images/ecommerce.png",
    },
    {
      "title": "Chat Application",
      "description":
      "A real-time messaging application with user authentication, group chats, media sharing, and push notifications across platforms.",
      "listOfTopics": ["Flutter", "Firebase", "WebSockets", "Provider"],
      "url": "https://github.com/sonykhan1121",
      "projectImagePreview": "assets/images/ecommerce.png",
    },
  ];

  void selectIndex(int index)
  {
    _currentIndex = index;
    notifyListeners();
  }
}