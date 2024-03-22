import 'package:budget_planner/models/model_category.dart';
import 'package:budget_planner/models/model_month.dart';
import 'package:budget_planner/singletons.dart';
import 'package:sqflite/sqflite.dart';

class HelperSqlite {
  static Future<void> createTables(Database db) async {
    await db.execute("create table tbl_months (date text primary key)");
    await db.execute(
        "create table tbl_categories (category text, date text, budget double, paid double)");
  }

  static Future<void> insertMonth(ModelMonth modelMonth) async {
    await Singleton.db.insert("tbl_months", modelMonth.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<ModelMonth>> getAllMonths() async {
    final List<Map<String, dynamic>> listOfRecords =
        await Singleton.db.query("tbl_months");
    return List.generate(listOfRecords.length, (index) {
      return ModelMonth(
          date: listOfRecords[index]['date'],
          savings: listOfRecords[index]['savings']);
    });
  }

  static Future<ModelMonth?> getModelMonthByDate(String date) async {
    final result = await Singleton.db
        .rawQuery('select * from tbl_months where date=?', [date]);

    if (result.isEmpty) {
      return null;
    } else {
      return ModelMonth(date: result.first['date'] as String);
    }
  }

  static Future<void> updateMonthSavings(
      ModelMonth modelMonth, double savings) async {
    await Singleton.db.rawUpdate(
        "update tbl_months set savings = ? where date = ?",
        [savings, modelMonth.date]);
  }

  static Future<void> updateCategoryBudget(
      ModelCategory modelCategory, double budget) async {
    await Singleton.db.rawUpdate(
        "update tbl_categories set budget = ? where category = ? and date = ?",
        [budget, modelCategory.category, modelCategory.date]);
  }

  static Future<void> updateCategoryPaid(
      ModelCategory modelCategory, double paid) async {
    await Singleton.db.rawUpdate(
        "update tbl_categories set paid = ? where category = ? and date = ?",
        [paid, modelCategory.category, modelCategory.date]);
  }

  static Future<void> updateCategoryName(
      ModelCategory modelCategory, String category) async {
    await Singleton.db.rawUpdate(
        "update tbl_categories set category = ? where category = ? and date = ?",
        [category, modelCategory.category, modelCategory.date]);
  }

  static Future<List<ModelCategory>> getAllCategories(String date) async {
    final List<Map<String, dynamic>> listOfRecords = await Singleton.db
        .rawQuery("select * from tbl_categories where date = ?", [date]);
    return List.generate(listOfRecords.length, (index) {
      return ModelCategory(
        category: listOfRecords[index]['category'],
        date: listOfRecords[index]['date'],
        budget: listOfRecords[index]['budget'],
        paid: listOfRecords[index]['paid'],
      );
    });
  }

  static Future<ModelCategory?> getCategoryByDateAndCategory(
      String date, String category) async {
    final result = await Singleton.db.rawQuery(
        'select * from tbl_categories where date=? and category=?',
        [date, category]);

    if (result.isEmpty) {
      return null;
    } else {
      return ModelCategory(
          date: result.first['date'] as String,
          category: result.first['category'] as String,
          budget: result.first['budget'] as double,
          paid: result.first['paid'] as double);
    }
  }

  static Future<void> insertCategory(ModelCategory modelCategory) async {
    await Singleton.db.insert("tbl_categories", modelCategory.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> deleteCategory(ModelCategory modelCategory) async {
    await Singleton.db.delete("tbl_categories",
        where: "date = ? and category = ?",
        whereArgs: [modelCategory.date, modelCategory.category]);
  }

  static Future<void> deleteCategoriesByMonth(ModelMonth modelMonth) async {
    await Singleton.db.delete(
      "tbl_categories",
      where: "date = ?",
      whereArgs: [modelMonth.date]
    );
  }

  static Future<void> deleteMonth(ModelMonth modelMonth) async {
    await Singleton.db.delete(
      "tbl_months",
      where: "date = ?",
      whereArgs: [modelMonth.date]
    );
  }
}
