import 'package:shared_preferences/shared_preferences.dart';

class HelperSharedPreferences {
  static late SharedPreferences instance;

  static Future<void> setDolarRate(int rate) async {
    await instance.setInt("dolar_rate", rate);
  }

  static Future<int> getDolarRate() async {
    return instance.getInt("dolar_rate") ?? 0;
  }

  static Future<double> getSalary() async {
    return instance.getDouble("salary") ?? 0;
  }

  static Future<void> setSalary(double value) async {
    await instance.setDouble("salary", value);
  }

  static Future<void> addCategory(String category) async {
    List<String> result = await getAllCategories();
    result.add(category);
    await instance.setStringList('categories', result);
  }

  static Future<List<String>> getAllCategories() async {
    return instance.getStringList('categories') ?? [];
  }
}
