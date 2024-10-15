import 'package:budget_planner/helper_sqlite.dart';
import 'package:budget_planner/models/model_category.dart';
import 'package:flutter/material.dart';

Widget CardCategory(ModelCategory modelCategory, BuildContext context,
    int dolarRate, Function() onFetchNeeded) {
  TextEditingController _controllerBudget = TextEditingController();
  TextEditingController _controllerPaid = TextEditingController();
  TextEditingController _controllerCategory = TextEditingController();

  return Card(
    color:
        modelCategory.category == "Salary" ? Colors.blue : Colors.blueGrey[50],
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text("Edit Category Name"),
                              TextField(
                                controller: _controllerCategory,
                                decoration: const InputDecoration(
                                    label: Text("Edit Category")),
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    HelperSqlite.updateCategoryName(
                                        modelCategory,
                                        _controllerCategory.text);
                                    _controllerCategory.clear();
                                    Navigator.pop(context);
                                    onFetchNeeded();
                                  },
                                  child: const Text("Save"))
                            ],
                          ),
                        );
                      });
                },
                child: Text(
                  modelCategory.category,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                  "Set the budget for ${modelCategory.category}"),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: TextField(
                                  controller: _controllerBudget,
                                  decoration: const InputDecoration(
                                      label: Text("Budget")),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    await HelperSqlite.updateCategoryBudget(
                                        modelCategory,
                                        double.parse(_controllerBudget.text));
                                    _controllerBudget.clear();
                                    Navigator.pop(context);
                                    onFetchNeeded();
                                  },
                                  child: const Text("Set"))
                            ],
                          ),
                        );
                      });
                },
                child: Text("${modelCategory.budget}"),
              ),
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Are you sure you want to delete category ${modelCategory.category}?",
                                  textAlign: TextAlign.center,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("No")),
                                      ElevatedButton(
                                          onPressed: () async {
                                            await HelperSqlite.deleteCategory(
                                                modelCategory);
                                            Navigator.pop(context);
                                            onFetchNeeded();
                                          },
                                          child: const Text("Yes"))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        });
                  },
                  icon: Icon(Icons.delete_rounded))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "${modelCategory.paid.toStringAsFixed(2)}",
                style: TextStyle(
                    color: modelCategory.paid >= modelCategory.budget - 15 &&
                            modelCategory.paid < modelCategory.budget
                        ? Colors.orange
                        : modelCategory.paid >= modelCategory.budget
                            ? Colors.red
                            : Colors.black),
              ),
              GestureDetector(
                onTap: () {
                  if (_controllerPaid.text.isNotEmpty) {
                    if (_controllerPaid.text.contains(
                      "#",
                    )) {
                      HelperSqlite.updateCategoryPaid(
                          modelCategory,
                          modelCategory.paid +
                              (double.parse(_controllerPaid.text
                                      .replaceAll("#", "")) /
                                  dolarRate));
                    } else {
                      HelperSqlite.updateCategoryPaid(
                          modelCategory,
                          modelCategory.paid +
                              double.parse(_controllerPaid.text));
                    }

                    _controllerPaid.clear();
                    onFetchNeeded();
                  }
                },
                child: const Icon(Icons.add_circle),
              ),
              GestureDetector(
                onTap: () {
                  if (_controllerPaid.text.isNotEmpty) {
                    if (_controllerPaid.text.contains(
                      "#",
                    )) {
                      HelperSqlite.updateCategoryPaid(
                          modelCategory,
                          modelCategory.paid -
                              (double.parse(_controllerPaid.text
                                      .replaceAll("#", "")) /
                                  dolarRate));
                    } else {
                      HelperSqlite.updateCategoryPaid(
                          modelCategory,
                          modelCategory.paid -
                              double.parse(_controllerPaid.text));
                    }
                    _controllerPaid.clear();
                    onFetchNeeded();
                  }
                },
                child: const Icon(Icons.remove_circle),
              ),
              SizedBox(
                width: 50,
                child: TextField(
                  controller: _controllerPaid,
                  keyboardType: TextInputType.phone,
                ),
              )
            ],
          ),
        ),
      ],
    ),
  );
}
