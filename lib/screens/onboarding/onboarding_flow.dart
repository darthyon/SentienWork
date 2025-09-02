import 'package:flutter/material.dart';
import 'welcome_screen.dart';
import 'journey_selection_screen.dart';
import 'goal_questions_screen.dart';
import 'permissions_screen.dart';
import 'daily_motivation_screen.dart';
import 'ben_introduction_screen.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  String? _selectedMode;

  void _nextPage() {
    if (_currentPage < 5) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Complete onboarding
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  void _skipToEnd() {
    // Skip directly to main app
    Navigator.of(context).pushReplacementNamed('/home');
  }

  void _onModeSelected(String mode) {
    setState(() {
      _selectedMode = mode;
    });
  }

  void _onAnswersSubmitted(Map<String, String> answers) {
    // Store answers for future use
    // TODO: Save to local storage or state management
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: [
          WelcomeScreen(onGetStarted: _nextPage),
          JourneySelectionScreen(
            onModeSelected: _onModeSelected,
            onContinue: _nextPage,
            onSkip: _skipToEnd,
            selectedMode: _selectedMode,
          ),
          GoalQuestionsScreen(
            mode: _selectedMode ?? 'guided',
            onAnswersSubmitted: _onAnswersSubmitted,
            onContinue: _nextPage,
          ),
          PermissionsScreen(
            onFinishSetup: _nextPage,
            onSkip: _skipToEnd,
          ),
          DailyMotivationScreen(onContinue: _nextPage),
          BenIntroductionScreen(
            onSkip: () => Navigator.of(context).pushReplacementNamed('/home'),
            onGenerateTodos: _nextPage,
          ),
        ],
      ),
    );
  }
}
