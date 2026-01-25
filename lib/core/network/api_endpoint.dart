class ApiEndpoint {
  static String login = '/auth/login';
  static String register = '/auth/register';

  static String notes = '/cards';

  static String projects = '/projects';

  static String tasks = '/cards';

  static String category = '/categories';

  static String userProfile = '/user/profile';
  static String changePw = '/user/password';
  static String userAvatar = '/user/avatar';

  static String analyzeNote = '/ai/suggest-project';
  static String aiCreateTasks = '/ai/create-project';
  static String aiQuickNote = '/ai/quick-note';
  static String aiSuggestFolder = '/ai/suggest-folder';

  static String area = '/areas';

  static String folders = '/folders';
  static String notifications = '/notifications';

  static const String statsMonthly = '/stats/monthly';
  static const String statsWeekly = '/stats/weekly';
  static const String statsYearly = '/stats/yearly';
}
