import 'package:flutter/material.dart';
import 'package:ChezIslem/Database/Food/foodDB.dart';
import 'package:ChezIslem/Database/Food/food.dart';
import 'package:ChezIslem/auth.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final dbHelper = FoodDatabase.instance;
  List<Food> placeHolder = [];

  @override
  void initState() {
    super.initState();
    _queryAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFFE85852),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Common',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFFE85852),
              ),
            ),
            const SizedBox(height: 16),
            const ListTile(
              leading: Icon(Icons.language),
              title: Text('Language'),
              subtitle: Text('English'),
            ),
            const Divider(
              thickness: 0.5,
              color: Colors.grey,
            ),
            const ListTile(
              leading: Icon(Icons.account_tree_rounded),
              title: Text('Version'),
              subtitle: Text('Version 1'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Account',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFFE85852),
              ),
            ),
            const SizedBox(height: 16),
            const ListTile(
              leading: Icon(Icons.phone),
              title: Text('Phone Number'),
              subtitle: Text('28 421 521'),

            ),
            const Divider(
              thickness: 0.5,
              color: Colors.grey,
            ),
            const ListTile(
              leading: Icon(Icons.mail),
              title: Text('Email'),
              subtitle: Text('ScanEat@gmail.com'),
            ),
            const SizedBox(height: 16),
            const Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            ListTile(
                title: TextButton(
              onPressed: signOut,
              child: const Text(
                'Sign Out',
                style: TextStyle(
                  color: Color(0xFFE85852),
                  fontSize: 18,
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Future<void> signOut() async {
    await Auth().signOut();
  }

  void _queryAll() async {
    final allRows = await dbHelper.queryAllRows();
    placeHolder = allRows.map((item) => Food.fromMap(item)).toList();
    setState(() {});
  }
}
