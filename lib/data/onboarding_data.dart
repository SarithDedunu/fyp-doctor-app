import 'package:doctor_app/models/onboarding_model.dart';

class OnboardingData {
  static List<OnboardingPage> getPages() {
    return [
      OnboardingPage(
        title: "Welcome to SafeSpace\nProfessional Platform",
        description: "A secure platform for mental health professionals to manage appointments, track patient progress, and provide compassionate care to students.",
        imagePath: "assets/onboarding/welcome.png",
      ),
      OnboardingPage(
        title: "Manage Your Practice\nEfficiently",
        description: "• Schedule & manage appointments\n• Track patient mental state\n• Secure session management\n• Professional patient notes",
        imagePath: "assets/onboarding/features.png",
      ),
    ];
  }
}