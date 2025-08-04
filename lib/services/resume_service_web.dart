import 'dart:html' as html;
import 'package:flutter/services.dart';

class ResumeServiceWeb {
  static Future<void> downloadResumeForWeb() async {
    try {
      // Load the PDF file from assets
      final ByteData data = await rootBundle.load('assets/resume/Abhishek_Singh_Resume.pdf');
      final List<int> bytes = data.buffer.asUint8List();
      
      // Create a blob URL for the PDF
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      
      // Create a download link and trigger download
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', 'Abhishek_Singh_Resume.pdf')
        ..click();
      
      // Clean up the blob URL
      html.Url.revokeObjectUrl(url);
    } catch (e) {
      print('Error downloading resume for web: $e');
      rethrow;
    }
  }
} 