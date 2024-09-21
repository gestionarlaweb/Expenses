import 'package:flutter/material.dart';

import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Casa',
      amount: 100.00,
      date: DateTime.now(),
      category: Category.casa,
    ),
    Expense(
      title: 'Ocio',
      amount: 100.00,
      date: DateTime.now(),
      category: Category.ocio,
    ),
    Expense(
      title: 'Alimentación',
      amount: 800.00,
      date: DateTime.now(),
      category: Category.comida,
    ),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true, // Impotant perque no agafi l'area de la cámara
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    // clearSnackBars() eliminar todos los snackbars que estén actualmente
    // mostrados en la pantalla
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Gastos eliminados !'),
        action: SnackBarAction(
            label: 'Deshacer',
            onPressed: () {
              setState(() {
                _registeredExpenses.insert(expenseIndex, expense);
              });
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // print(MediaQuery.of(context).size.width); // vertical  392.72727272727275   - horizontal 801
    // print(MediaQuery.of(context).size.height); // vertical  826.9090909090909   - horizontal 368

    final width = MediaQuery.of(context).size.width;

    Widget mainContent = const Center(
      child: Text('No hay gastos !'),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Gastos App'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: width < 600 
        ? Column(
            children: [
              Chart(expenses: _registeredExpenses),
              Expanded(
                child: mainContent,
              ),
            ],
          )
        : Row(children: [
            Expanded(
              child: Chart(expenses: _registeredExpenses),
            ),
            Expanded(
              child: mainContent,
            ),
          ]),
    );
  }
}
