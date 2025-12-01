class ApiConfig {
  final String apiBaseUrl = "futru-scc-server.onrender.com/api/v1";

  // AUTH
  final String loginUrl = "/login";
  final String signupUrl = "/signup";
  final String checkAuthUrl = "/check";
  final String verifyEmailUrl = "/verify";
  final String resetPasswordUrl = "/reset";
  final String updateProfileUrl = "/update-profile";

  // SCC
  final String getSCCRecordsUrl = "/records";
  final String getSCCRecordDetailsUrl = "/record";
  final String addSCCRecordsUrl = "/add-record";

}