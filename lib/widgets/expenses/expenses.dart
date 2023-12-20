import 'package:flutter/material.dart';
import 'package:flutter_expense_tracker/models/expense.dart';
import 'package:flutter_expense_tracker/widgets/chart/chart.dart';
import 'package:flutter_expense_tracker/widgets/expenses/expenses_list.dart';
import 'package:flutter_expense_tracker/widgets/modals/add_expenses.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _reqgisteredExpenses = [
    Expense(
      title: 'Flutter course',
      amount: 20,
      date: DateTime.now(),
      category: Category.wotk,
    ),
    Expense(
      title: 'Cinema',
      amount: 10,
      date: DateTime.now(),
      category: Category.leisure,
    ),
  ];

  void _handlerModalAddExpense() {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width,
        minHeight: MediaQuery.of(context).size.height,
      ),
      builder: (context) => AddExpenses(
        storeExpense: _handlerAddExpense,
      ),
    );
  }

  void _handlerAddExpense(Expense expense) {
    setState(() {
      _reqgisteredExpenses.add(expense);
    });
  }

  void _handlerRemoveExpense(Expense expense) {
    final expenseIndex = _reqgisteredExpenses.indexOf(expense);

    setState(() {
      _reqgisteredExpenses.remove(expense);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: const Text(
          'Expense deleted.',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        action: SnackBarAction(
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          textColor: Colors.white,
          label: 'Undo',
          onPressed: () {
            // _handlerUndoRemoveExpense(expense);
            setState(() {
              _reqgisteredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // print(width);

    Widget mainContent = const Center(
      child: Text('No expenses found. Start adding some!'),
    );

    if (_reqgisteredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _reqgisteredExpenses,
        removeExpense: _handlerRemoveExpense,
      );
    }

    Widget bodyContent = Column(
      children: [
        Chart(expenses: _reqgisteredExpenses),
        // ExpensesList(expenses: _reqgisteredExpenses),
        Expanded(
          child: mainContent,
        )
      ],
    );

    if (width > 600) {
      bodyContent = Row(
        children: [
          Expanded(
            child: Chart(
              expenses: _reqgisteredExpenses,
            ),
          ),
          Expanded(
            child: mainContent,
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My expenses'),
        actions: [
          IconButton(
            onPressed: _handlerModalAddExpense,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: bodyContent,
    );
  }
}
