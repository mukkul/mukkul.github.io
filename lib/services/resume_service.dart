import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// Conditional import for web
import 'resume_service_web.dart' if (dart.library.io) 'resume_service_mobile.dart';

class ResumeService {
  static Future<void> downloadResume() async {
    try {
      if (kIsWeb) {
        // For web, download the PDF file
        await downloadResumeForWeb();
      } else {
        // For mobile, save to device
        await downloadResumeAsFile();
      }
    } catch (e) {
      print('Error downloading resume: $e');
      // Fallback to LinkedIn if download fails
      const url = 'https://www.linkedin.com/in/abhishek-vinod-singh/';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      }
    }
  }

  static Future<void> downloadResumeForWeb() async {
    try {
      if (kIsWeb) {
        // Use the web-specific implementation
        await ResumeServiceWeb.downloadResumeForWeb();
      } else {
        // Fallback for non-web platforms
        const linkedinUrl = 'https://www.linkedin.com/in/abhishek-vinod-singh/';
        await launchUrl(Uri.parse(linkedinUrl), mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      print('Error downloading resume for web: $e');
      // Fallback to LinkedIn if download fails
      const linkedinUrl = 'https://www.linkedin.com/in/abhishek-vinod-singh/';
      await launchUrl(Uri.parse(linkedinUrl), mode: LaunchMode.externalApplication);
    }
  }

  static Future<void> downloadResumeAsFile() async {
    try {
      // Copy the resume from assets to a temporary directory
      final ByteData data = await rootBundle.load('assets/resume/Abhishek_Singh_Resume.pdf');
      final List<int> bytes = data.buffer.asUint8List();
      
      final Directory tempDir = await getTemporaryDirectory();
      final File file = File('${tempDir.path}/Abhishek_Singh_Resume.pdf');
      await file.writeAsBytes(bytes);
      
      // For mobile, you might want to use a file sharing plugin
      // For web, you can create a download link
      print('Resume saved to: ${file.path}');
    } catch (e) {
      print('Error saving resume: $e');
    }
  }
} 