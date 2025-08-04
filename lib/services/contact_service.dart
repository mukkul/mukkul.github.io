class ContactFormData {
  final String name;
  final String email;
  final String message;

  ContactFormData({
    required this.name,
    required this.email,
    required this.message,
  });
}

class ContactService {
  static Future<bool> submitContactForm(ContactFormData data) async {
    try {
      // In a real app, you would send this data to your backend
      // For now, we'll just simulate a successful submission
      print('Contact form submitted:');
      print('Name: ${data.name}');
      print('Email: ${data.email}');
      print('Message: ${data.message}');
      
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      return true;
    } catch (e) {
      print('Error submitting contact form: $e');
      return false;
    }
  }

  static Future<void> sendEmail({
    required String to,
    required String subject,
    required String body,
  }) async {
    // In a real app, you might use a service like SendGrid or EmailJS
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: to,
      query: 'subject=$subject&body=$body',
    );
    
    // This would open the default email client
    // await launchUrl(emailUri);
  }
} 