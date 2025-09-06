class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  // User type based on email - in real app this would come from auth/user service
  String _userEmail = 'newuser@sentienwork.com'; // Change to 'newuser@sentienwork.com' for limited access or 'poweruser@sentienwork.com' for full access
  
  String get userEmail => _userEmail;
  bool get isNewUser => _userEmail == 'newuser@sentienwork.com';
  bool get isPowerUser => _userEmail == 'poweruser@sentienwork.com';
  
  void setUserType(String email) {
    _userEmail = email;
  }
  
  // Helper method to get current streak based on user type
  int get currentStreak => isNewUser ? 3 : 7;
}
