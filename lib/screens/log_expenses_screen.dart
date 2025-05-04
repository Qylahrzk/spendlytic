import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class LogExpensesScreen extends StatefulWidget {
  const LogExpensesScreen({super.key});

  @override
  State<LogExpensesScreen> createState() => _LogExpensesScreenState();
}

class _LogExpensesScreenState extends State<LogExpensesScreen> {
  final Box _expenseBox = Hive.box('expenses');
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String _selectedCategory = 'General';
  final List<String> _categories = ['General', 'Food', 'Transportation', 'Shopping'];

  int _currentIndex = 1; // Set to 1 because Log Expenses is active

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Navigate to corresponding screen
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        // Already on Log Expenses
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/budget_track');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/review_insights');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/account');
        break;
    }
  }

  void _addExpense(String title, double amount, String category) {
    final expense = {
      'title': title,
      'amount': amount,
      'category': category,
      'date': DateTime.now().toIso8601String(),
    };
    _expenseBox.add(expense);
    if (kDebugMode) print('Added expense: $expense');
  }

  void _clearExpenses() {
    setState(() {
      _expenseBox.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All expenses have been cleared!')),
    );
  }

  void _showAddExpenseDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Expense'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
              ),
              DropdownButton<String>(
                value: _selectedCategory,
                isExpanded: true,
                items: _categories
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final title = _titleController.text.trim();
                final amountText = _amountController.text.trim();
                if (title.isNotEmpty && amountText.isNotEmpty) {
                  try {
                    final amount = double.parse(amountText);
                    _addExpense(title, amount, _selectedCategory);
                    _titleController.clear();
                    _amountController.clear();
                    Navigator.of(context).pop();
                  } catch (_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Invalid amount entered!')),
                    );
                  }
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickReceiptImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final inputImage = InputImage.fromFilePath(image.path);
      // ignore: deprecated_member_use
      final textDetector = GoogleMlKit.vision.textRecognizer();
      final recognizedText = await textDetector.processImage(inputImage);

      String scannedText = recognizedText.text;
      if (kDebugMode) print('Scanned Text: $scannedText');
      _showScannedTextDialog(scannedText);
    }
  }

  void _showScannedTextDialog(String scannedText) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Scanned Receipt'),
          content: SingleChildScrollView(child: Text(scannedText)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _processScannedText(scannedText);
                Navigator.of(context).pop();
              },
              child: const Text('Add Expense'),
            ),
          ],
        );
      },
    );
  }

  void _processScannedText(String text) {
    final title = _extractTitleFromText(text);
    final amount = _extractAmountFromText(text);

    if (title != null && amount != null) {
      _addExpense(title, amount, 'General');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to extract title/amount.')),
      );
    }
  }

  String? _extractTitleFromText(String text) {
    final lines = text.split('\n');
    return lines.isNotEmpty ? lines[0].trim() : null;
  }

  double? _extractAmountFromText(String text) {
    final regex = RegExp(r'RM\s?\d+(\.\d{1,2})?');
    final match = regex.firstMatch(text);
    if (match != null) {
      final cleanMatch = match.group(0)?.replaceAll(RegExp(r'[^\d.]'), '');
      return cleanMatch != null ? double.tryParse(cleanMatch) : null;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50], // Soft purple background
      appBar: AppBar(
        title: const Text('Spendlytic - Expenses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings screen (implement if needed)
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header and action buttons (dustbin & camera) in the same Row for alignment
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Log Expenses',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: _clearExpenses,
                    ),
                    IconButton(
                      icon: const Icon(Icons.camera_alt),
                      onPressed: _pickReceiptImage,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _expenseBox.listenable(),
              builder: (context, Box box, _) {
                if (box.isEmpty) {
                  return const Center(child: Text('No expenses logged yet.'));
                }
                return ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    final expense = box.getAt(index);
                    if (expense is Map) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 4,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(expense['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            '${expense['category']} - ${DateFormat.yMMMd().format(DateTime.parse(expense['date']))}',
                          ),
                          trailing: Text('RM ${expense['amount'].toStringAsFixed(2)}'),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddExpenseDialog,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Log'),
          BottomNavigationBarItem(icon: Icon(Icons.track_changes), label: 'Budget'),
          BottomNavigationBarItem(icon: Icon(Icons.insights), label: 'Insights'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Account'),
        ],
      ),
    );
  }
}
