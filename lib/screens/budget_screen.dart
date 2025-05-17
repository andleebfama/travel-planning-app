import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BudgetPlanScreen extends StatefulWidget {
  const BudgetPlanScreen({super.key}); // ✅ cleaner and equivalent
  @override
  State<BudgetPlanScreen> createState() => _BudgetPlanScreenState();
}


class _BudgetPlanScreenState extends State<BudgetPlanScreen> {
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _expenseTitleController = TextEditingController();
  final TextEditingController _expenseAmountController = TextEditingController();

  double _totalBudget = 0.0;
  final List<Map<String, dynamic>> _expenses = [];
  double get totalSpent =>
      _expenses.fold(0.0, (sum, item) => sum + item['amount']);
  double get remainingBudget => _totalBudget - totalSpent;

  void _addExpense() {
    final title = _expenseTitleController.text.trim();
    final amount = double.tryParse(_expenseAmountController.text.trim());

    if (title.isNotEmpty && amount != null && amount > 0) {
      setState(() {
        _expenses.add({
          'title': title,
          'amount': amount,
          'date': DateTime.now(),
        });
        _expenseTitleController.clear();
        _expenseAmountController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields with valid data.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Simple Budget Tracker",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 2, 168, 152),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Total Budget Card with fixed width
                      SizedBox(
  width: 500, // Fixed width of 500 pixels
  child: Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _budgetController,
            decoration: InputDecoration(
              labelText: "Enter Total Budget",
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                _totalBudget = double.tryParse(value) ?? 0.0;
              });
            },
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Budget: \$${_totalBudget.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text("Spent: \$${totalSpent.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 16, color: Colors.red)),
              Text("Left: \$${remainingBudget.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 16, color: Colors.green)),
            ],
          ),
        ],
      ),
    ),
  ),
),
SizedBox(height: 20),

// Expense Input Section
SizedBox(
  width: 500,
  child: Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _expenseTitleController,
            decoration: InputDecoration(
              labelText: "Expense Title",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: _expenseAmountController,
            decoration: InputDecoration(
              labelText: "Expense Amount",
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _addExpense,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 10, 10, 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text("Add Expense", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    ),
  ),
),
SizedBox(height: 20),

// Expense List
if (_expenses.isNotEmpty)
  SizedBox(
    width: 500,
    child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: _expenses.map((expense) {
            return ListTile(
              leading: Icon(Icons.monetization_on, color: Colors.teal),
              title: Text(expense['title']),
              subtitle: Text(DateFormat('MMM dd, yyyy').format(expense['date'])),
              trailing: Text(
                "\$${expense['amount'].toStringAsFixed(2)}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }).toList(),
        ),
      ),
    ),
  ),

                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      home: BudgetPlanScreen(),
    ));
