class ApiConfig {
  final String apiBaseUrl = "parish-connect.onrender.com";
  final String apiBasePath = "/api/v1";

  // AUTH
  final String loginUrl = "/login";
  final String signupUrl = "/signup";
  final String checkAuthUrl = "/check";
  final String verifyEmailUrl = "/verify";
  final String resetPasswordUrl = "/reset";
  final String updateProfileUrl = "/update-profile";

  // SCC
  final String getSCCRecordsUrl = "/scc/records";
  final String getSCCRecordDetailsUrl = "/scc/record";
  final String addSCCRecordsUrl = "/scc/add-record";

  // PARISH
  final String addParishRecordsUrl = "/parish/add-record";
  final String getParishRecordsUrl = "/parish/records";

}
