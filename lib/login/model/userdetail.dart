class UserDetails {
  UserDetails._privateConstructor();

  static final UserDetails _instance = UserDetails._privateConstructor();

  factory UserDetails() {
    return _instance;
  }

  static String userId = "",
      userName = "",
      userEmail = "",
      userMobile = "",
      userRoleId = "";

  static void setUserId(String val) {
    userId = val;
  }

  String getUserId() {
    return userId;
  }

  static void setUserName(String val) {
    userName = val;
  }

  String getUserName() {
    return userName;
  }

  static void setUserEmail(String val) {
    userEmail = val;
  }

  String getUserEmail() {
    return userEmail;
  }

  static void setUserMobile(String val) {
    userMobile = val;
  }

  String getUserMobile() {
    return userMobile;
  }

  static void setUserRoleId(String val) {
    userRoleId = val;
  }

  String getUserRoleId() {
    return userRoleId;
  }
}
