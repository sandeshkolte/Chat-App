import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String userLoginKey = "ISLOGGEDIN";
  static String userEmailKey = "USERMAILKEY";
  static String msgkey = "MSGKEY";

  static Future<bool?> saveUserLoggedIn(bool isLoggedIn) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setBool(userLoginKey, isLoggedIn);
  }

  static Future<bool?> saveUserEmail(String email) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(userEmailKey, email);
  }

  static Future<bool?> getUserLoggedIn() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(userLoginKey);
  }

  static Future<String?> getUserEmail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(userEmailKey);
  }

//For new message to show on list
  // static Future<bool?> saveMessage(String msg) async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   return pref.setString(msgkey, msg);
  // }

  // static Future<String?> getMsg() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   return pref.getString(msgkey);
  // }
}
