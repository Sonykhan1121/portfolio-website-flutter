//provider extension
import 'package:flutter/cupertino.dart';
import 'package:portfolio_website_flutter/features/navigation/viewmodels/navigation_controller.dart';
import 'package:provider/provider.dart';

extension ProviderExtension on BuildContext{
  NavigationController get navigationController => Provider.of<NavigationController>(this,listen:false);
}