import 'dart:math';

import 'package:budget_planner/components/card_month.dart';
import 'package:budget_planner/helper_sharedpreferences.dart';
import 'package:budget_planner/helper_sqlite.dart';
import 'package:budget_planner/models/model_category.dart';
import 'package:budget_planner/models/model_month.dart';
import 'package:budget_planner/screen_categories.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScreenMonths extends StatefulWidget {
  @override
  _ScreenMonths createState() => _ScreenMonths();
}

class _ScreenMonths extends State<ScreenMonths> {
  List<ModelMonth> _list = [];
  TextEditingController _controllerSalary = TextEditingController();
  double _salary = 0;

  @override
  void initState() {
    super.initState();

    initializeMonths();
    fetchSalary();
  }

  Future<void> initializeMonths() async {
    await addMonth();
    await fetchAllMonths();
  }

  Future<void> fetchSalary() async {
    HelperSharedPreferences.getSalary().then(
      (value) {
        setState(() {
          _salary = value;
        });
      },
    );
  }

  Future<void> fetchAllMonths() async {
    await HelperSqlite.getAllMonths().then((value) {
      setState(() {
        _list = value.reversed.toList();
      });
    });
  }

  Future<void> addMonth() async {
    DateTime dateTime = DateTime.now();
    var formattedDate = DateFormat.yMMMM().format(dateTime);
    // formattedDate = formattedDate.replaceFirst(" ", " 15 ");

    DateTime nextDateTime = dateTime.add(const Duration(days: 31));
    var nextFormattedDate = DateFormat.yMMMM().format(nextDateTime);
    // nextFormattedDate = nextFormattedDate.replaceFirst(" ", " 15 ");

    formattedDate = "$formattedDate - $nextFormattedDate";

    await HelperSqlite.getModelMonthByDate(formattedDate).then((value) async {
      if (value == null) {
        // this month hasn't been added before, so add it to the database
        await HelperSqlite.insertMonth(ModelMonth(date: formattedDate));
      }
    });
  }

  List<Widget> widgetsOfMonths(BuildContext context) {
    List<Widget> list = [];
    for (var element in _list) {
      list.add(CardMonth(element, () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return ScreenCategories(
            modelMonth: element,
          );
        }));
      }, () async {
        List<ModelCategory>? list =
            await HelperSqlite.getAllCategories(element.date);
        if (list != null) {
          if (list.isNotEmpty) {
            double savings = 0;
            double paids = 0;
            for (var category in list) {
              paids += category.paid;
            }
            savings = await HelperSharedPreferences.getSalary() - paids;
            await HelperSqlite.updateMonthSavings(element, savings);
            setState(() {
              element.savings = savings;
            });
          }
        }
      }, (modelMonth) {
        // on delete click

        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                elevation: 0,
                title: const Text(
                  "Attention!",
                  textAlign: TextAlign.center,
                ),
                content: const Text(
                    "Are you sure you want to delete this month?",
                    textAlign: TextAlign.center),
                actionsAlignment: MainAxisAlignment.spaceEvenly,
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("No")),
                  ElevatedButton(
                      onPressed: () async {
                        await deleteMonth(modelMonth);
                        Navigator.pop(context);
                      },
                      child: const Text("Yes")),
                ],
              );
            });
      }));
    }
    return list;
  }

  Future<void> deleteMonth(ModelMonth modelMonth) async {
    await HelperSqlite.deleteCategoriesByMonth(modelMonth);
    await HelperSqlite.deleteMonth(modelMonth);

    setState(() {
      _list.remove(modelMonth);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Budget Planner"),
        actions: [
          GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("Set Your Salary"),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: TextField(
                              controller: _controllerSalary,
                              decoration:
                                  const InputDecoration(label: Text("Salary")),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _salary =
                                        double.parse(_controllerSalary.text);
                                  });
                                  HelperSharedPreferences.setSalary(
                                      double.parse(_controllerSalary.text));
                                  _controllerSalary.clear();
                                  Navigator.pop(context);
                                },
                                child: const Text("Set")),
                          )
                        ],
                      ),
                    );
                  });
            },
            child: Text("${_salary}"),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          children: widgetsOfMonths(context),
        ),
      ),
    );
  }
}
