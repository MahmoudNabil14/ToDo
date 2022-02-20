import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {

  static late final SharedPreferences sharedPreferences;

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<void> saveDate(String key , dynamic value)async {
    if (value is String) sharedPreferences.setString(key, value);
    if (value is int) sharedPreferences.setInt(key, value);
    if (value is double) sharedPreferences.setDouble(key, value);
    else{
      if (value is bool) sharedPreferences.setBool(key, value);
    }
  }

  static dynamic getData(String key){
     return sharedPreferences.get(key);
  }

  static Future<bool> removeData(String key)async{
    return await sharedPreferences.remove(key);
  }

}