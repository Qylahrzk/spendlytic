import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box userBox;
  String userEmail = '';

  int _selectedIndex = 0;

  final List<String> _routes = [
    '/home',
    '/log_expense',
    '/budget',
    '/insight',
    '/account'
  ];

  @override
  void initState() {
    super.initState();
    userBox = Hive.box('user');
    _loadUserData();
  }

  void _loadUserData() {
    final Map<dynamic, dynamic> users = userBox.toMap();
    if (users.isNotEmpty) {
      final firstKey = users.keys.first;
      setState(() {
        userEmail = firstKey;
      });
    }
  }

  void _logout() async {
    await userBox.clear();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index != 0) {
      Navigator.pushNamed(context, _routes[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.deepPurple;
    final Color softPurple = Colors.purple[50]!;
    final TextStyle headlineStyle =
        const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black);
    final TextStyle subTextStyle =
        const TextStyle(fontSize: 16, color: Colors.black54);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spendlytic'),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Container(
        color: softPurple,  // Set the soft purple background color here
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome back,', style: subTextStyle),
            const SizedBox(height: 4),
            Text(userEmail, style: headlineStyle),
            const SizedBox(height: 32),

            // Balance Summary Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              color: Colors.deepPurple[50],
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Total Balance',
                        style: TextStyle(fontSize: 16, color: Colors.black54)),
                    SizedBox(height: 8),
                    Text('RM 2,450.00',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: _summaryCard('Income', 'RM 3,000', Colors.green),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _summaryCard('Expenses', 'RM 550', Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Log'),
          BottomNavigationBarItem(icon: Icon(Icons.track_changes), label: 'Budget'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Insight'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Account'),
        ],
      ),
    );
  }

  Widget _summaryCard(String title, String value, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontSize: 14, color: Colors.black54)),
            const SizedBox(height: 4),
            Text(value,
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }
}
