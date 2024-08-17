import 'package:budget_planner/components/card_category.dart';
import 'package:budget_planner/helper_sharedpreferences.dart';
import 'package:budget_planner/helper_sqlite.dart';
import 'package:budget_planner/models/model_category.dart';
import 'package:budget_planner/models/model_month.dart';
import 'package:flutter/material.dart';

class ScreenCategories extends StatefulWidget {
  final ModelMonth modelMonth;

  const ScreenCategories({required this.modelMonth});

  @override
  _ScreenCtegories createState() => _ScreenCtegories();
}

class _ScreenCtegories extends State<ScreenCategories> {
  List<ModelCategory> _list = [];
  TextEditingController _controllerNewCategory = TextEditingController();
  TextEditingController _controllerNewCategoryBudget = TextEditingController();
  TextEditingController _controllerDolarRate = TextEditingController();
  int _dolarRate = 0;

  @override
  void initState() {
    super.initState();

    addCategories();
    fetchDolarRate();
  }

  void fetchDolarRate() {
    HelperSharedPreferences.getDolarRate().then((value) => {
          setState(
            () {
              _dolarRate = value;
            },
          )
        });
  }

  Future<void> addCategories() async {
    await HelperSqlite.getAllCategories(widget.modelMonth.date)
        .then((value) async {
      if (value.isEmpty) {
        List<ModelMonth> listOfMonths = await HelperSqlite.getAllMonths();

        ModelCategory? modelCategory;
        if (listOfMonths.length >= 2) {
          modelCategory = await HelperSqlite.getCategoryByDateAndCategory(
              listOfMonths[listOfMonths.length - 2].date, "Car");
        }

        await HelperSqlite.insertCategory(ModelCategory(
            category: "Car",
            date: widget.modelMonth.date,
            budget: (200 +
                    (modelCategory == null
                        ? 0
                        : (modelCategory.budget - modelCategory.paid)))
                .roundToDouble(),
            paid: 0));

        if (listOfMonths.length >= 2) {
          modelCategory = await HelperSqlite.getCategoryByDateAndCategory(
              listOfMonths[listOfMonths.length - 2].date, "Home");
        }

        await HelperSqlite.insertCategory(ModelCategory(
            category: "Home",
            date: widget.modelMonth.date,
            budget: (120 +
                    (modelCategory == null
                        ? 0
                        : (modelCategory.budget - modelCategory.paid)))
                .roundToDouble(),
            paid: 0));

        if (listOfMonths.length >= 2) {
          modelCategory = await HelperSqlite.getCategoryByDateAndCategory(
              listOfMonths[listOfMonths.length - 2].date, "Shopping");
        }
        await HelperSqlite.insertCategory(ModelCategory(
            category: "Shopping",
            date: widget.modelMonth.date,
            budget: (80 +
                    (modelCategory == null
                        ? 0
                        : (modelCategory.budget - modelCategory.paid)))
                .roundToDouble(),
            paid: 0));

        if (listOfMonths.length >= 2) {
          modelCategory = await HelperSqlite.getCategoryByDateAndCategory(
              listOfMonths[listOfMonths.length - 2].date, "Givings");
        }
        await HelperSqlite.insertCategory(ModelCategory(
            category: "Givings",
            date: widget.modelMonth.date,
            budget: (50 +
                    (modelCategory == null
                        ? 0
                        : (modelCategory.budget - modelCategory.paid)))
                .roundToDouble(),
            paid: 0));

        if (listOfMonths.length >= 2) {
          modelCategory = await HelperSqlite.getCategoryByDateAndCategory(
              listOfMonths[listOfMonths.length - 2].date, "Outdoor Activities");
        }
        await HelperSqlite.insertCategory(ModelCategory(
            category: "Outdoor Activities",
            date: widget.modelMonth.date,
            budget: (80 +
                    (modelCategory == null
                        ? 0
                        : (modelCategory.budget - modelCategory.paid)))
                .roundToDouble(),
            paid: 0));

        if (listOfMonths.length >= 2) {
          modelCategory = await HelperSqlite.getCategoryByDateAndCategory(
              listOfMonths[listOfMonths.length - 2].date, "Food");
        }
        await HelperSqlite.insertCategory(ModelCategory(
            category: "Food",
            date: widget.modelMonth.date,
            budget: (200 +
                    (modelCategory == null
                        ? 0
                        : (modelCategory.budget - modelCategory.paid)))
                .roundToDouble(),
            paid: 0));

            if (listOfMonths.length >= 2) {
          modelCategory = await HelperSqlite.getCategoryByDateAndCategory(
              listOfMonths[listOfMonths.length - 2].date, "Health & Gym");
        }
        await HelperSqlite.insertCategory(ModelCategory(
            category: "Health & Gym",
            date: widget.modelMonth.date,
            budget: (100 +
                    (modelCategory == null
                        ? 0
                        : (modelCategory.budget - modelCategory.paid)))
                .roundToDouble(),
            paid: 0));

        if (listOfMonths.length >= 2) {
          modelCategory = await HelperSqlite.getCategoryByDateAndCategory(
              listOfMonths[listOfMonths.length - 2].date, "Business");
        }
        await HelperSqlite.insertCategory(ModelCategory(
            category: "Business",
            date: widget.modelMonth.date,
            budget: (100 +
                    (modelCategory == null
                        ? 0
                        : (modelCategory.budget - modelCategory.paid)))
                .roundToDouble(),
            paid: 0));
      }
    });

    await HelperSqlite.getAllCategories(widget.modelMonth.date)
        .then((value) => {
              setState(() => _list = value),
            });
  }

  List<Widget> widgetsOfCategories(BuildContext context) {
    List<Widget> list = [];
    for (var element in _list) {
      list.add(CardCategory(element, context, _dolarRate, () {
        HelperSqlite.getAllCategories(widget.modelMonth.date).then((value) => {
              setState(() => _list = value),
            });
      }));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.modelMonth.date),
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
                          const Text("Set Dolar Rate"),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: TextField(
                              controller: _controllerDolarRate,
                              decoration: const InputDecoration(
                                  label: Text("Dolar Rate")),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _dolarRate =
                                        int.parse(_controllerDolarRate.text);
                                  });
                                  HelperSharedPreferences.setDolarRate(
                                      int.parse(_controllerDolarRate.text));
                                  _controllerDolarRate.clear();
                                  Navigator.pop(context);
                                },
                                child: const Text("Set")),
                          )
                        ],
                      ),
                    );
                  });
            },
            child: Text("${_dolarRate}"),
          ),
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text("Add a Category"),
                            TextField(
                              controller: _controllerNewCategory,
                              decoration: const InputDecoration(
                                  label: Text("New Category")),
                            ),
                            TextField(
                              controller: _controllerNewCategoryBudget,
                              keyboardType: TextInputType.number,
                              decoration:
                                  const InputDecoration(label: Text("Budget")),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                      onPressed: () async {
                                        await HelperSqlite.insertCategory(
                                            ModelCategory(
                                                category:
                                                    _controllerNewCategory.text,
                                                date: widget.modelMonth.date,
                                                budget: double.parse(
                                                    _controllerNewCategoryBudget
                                                        .text),
                                                paid: 0));

                                        _controllerNewCategory.clear();
                                        _controllerNewCategoryBudget.clear();

                                        Navigator.pop(context);

                                        HelperSqlite.getAllCategories(
                                                widget.modelMonth.date)
                                            .then((value) {
                                          setState(() {
                                            _list = value;
                                          });
                                        });
                                      },
                                      child: const Text("Add")),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    });
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: widgetsOfCategories(context),
        ),
      ),
    );
  }
}
