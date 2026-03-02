import 'package:flutter/material.dart';
import 'package:portfolio_website_flutter/features/home/presentation/views/home_page.dart';
import 'package:provider/provider.dart';
import 'features/navigation/presentation/views/responsive_nav_bar.dart';
import 'features/navigation/viewmodels/navigation_controller.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>NavigationController()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: ResponsiveNavBar()
    );
  }
}

