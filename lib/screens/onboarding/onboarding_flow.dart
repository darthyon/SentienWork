import 'package:flutter/material.dart';
import 'welcome_screen.dart';
import 'ben_introduction_screen.dart';
import 'personalize_experience_screen.dart';
import 'linkedin_mock_screen.dart';
import 'is_this_you_screen.dart';
import 'work_details_screen.dart';
import 'background_analysis_screen.dart';
import 'goal_setting_screen.dart';
import 'timeline_selection_screen.dart';
import 'app_loading_screen.dart';
import 'daily_motivation_screen.dart';
import '../main_app_screen.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _useLinkedIn = false;

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 1),
      curve: Curves.linear,
    );
  }

  void _skipToEnd() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const MainAppScreen()),
    );
  }

  void _onLinkedInSelected() {
    setState(() {
      _useLinkedIn = true;
    });
    _nextPage();
  }

  void _onManualSelected() {
    setState(() {
      _useLinkedIn = false;
    });
    // Skip LinkedIn mock screen, go to Is This You screen
    _pageController.animateToPage(
      4, // Is This You screen index
      duration: const Duration(milliseconds: 1),
      curve: Curves.linear,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Disable swipe navigation
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: [
          // 0: Welcome Screen
          WelcomeScreen(onGetStarted: _nextPage),
          
          // 1: Ben Introduction
          BenIntroductionScreen(
            onSkip: _skipToEnd,
            onGenerateTodos: _nextPage,
          ),
          
          // 2: Personalize Experience
          PersonalizeExperienceScreen(
            onSkip: _skipToEnd,
            onLinkedInSelected: _onLinkedInSelected,
            onDoLaterSelected: _onManualSelected,
          ),
          
          // 3: LinkedIn Mock (only if LinkedIn selected)
          LinkedInMockScreen(
            onSkip: _skipToEnd,
            onContinue: _nextPage,
          ),
          
          // 4: Personal Details (manual entry)
          IsThisYouScreen(
            onContinue: () => _nextPage(),
            onSkip: () => _skipToEnd(),
          ),
          WorkDetailsScreen(
            onContinue: () => _nextPage(),
            onSkip: () => _skipToEnd(),
          ),
          
          
          // 6: Background Analysis
          BackgroundAnalysisScreen(
            onSkip: _skipToEnd,
            onContinue: _nextPage,
          ),
          
          // 7: Goal Setting
          GoalSettingScreen(
            onSkip: _skipToEnd,
            onContinue: _nextPage,
          ),
          
          // 8: Timeline Selection
          TimelineSelectionScreen(
            onSkip: _skipToEnd,
            onContinue: _nextPage,
          ),
          
          // 9: App Loading
          AppLoadingScreen(
            onComplete: _nextPage,
          ),
          
          // 10: Daily Motivation
          DailyMotivationScreen(
            onContinue: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const MainAppScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
