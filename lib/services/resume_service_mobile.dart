import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class ResumeServiceMobile {
  static Future<void> downloadResumeForMobile() async {
    try {
      // Copy the resume from assets to a temporary directory
      final ByteData data = await rootBundle.load('assets/resume/Abhishek_Singh_Resume.pdf');
      final List<int> bytes = data.buffer.asUint8List();
      
      final Directory tempDir = await getTemporaryDirectory();
      final File file = File('${tempDir.path}/Abhishek_Singh_Resume.pdf');
      await file.writeAsBytes(bytes);
      
      // For mobile, you might want to use a file sharing plugin
      // For now, we'll just save it to the temp directory
      print('Resume saved to: ${file.path}');
    } catch (e) {
      print('Error saving resume: $e');
      rethrow;
    }
  }
} 