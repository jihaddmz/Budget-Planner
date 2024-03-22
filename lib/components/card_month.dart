import 'package:budget_planner/models/model_month.dart';
import 'package:flutter/material.dart';

Widget CardMonth(ModelMonth modelMonth, Function()? onTap,
    Function()? onLongPress, Function(ModelMonth) onDeleteClick) {
  return GestureDetector(
    onTap: onTap,
    onLongPress: onLongPress,
    child: Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: [
            Center(
              child: Text(modelMonth.date),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        onDeleteClick(modelMonth);
                      },
                      icon: const Icon(Icons.delete)),
                  Text("${modelMonth.savings.toStringAsFixed(2)} \$")
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}
