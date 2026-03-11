import 'package:url_launcher/url_launcher.dart';

class UrlLauncherService {
  static Future<void> launchExternal(String url) async {
    final uri = Uri.parse(url);
    await _launch(uri);
  }

  // ✅ Dedicated mailto method - handles encoding properly
  static Future<void> launchEmail({
    required String email,
    String? subject,
    String? body,
  }) async {
    final uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        if (subject != null) 'subject': subject,
        if (body != null) 'body': body,
      },
    );
    await _launch(uri);
  }

  static Future<void> _launch(Uri uri) async {
    if (!await canLaunchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}