import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ChezIslem/Database/Food/food.dart';
import 'package:ChezIslem/Database/Food/foodDB.dart';
import '../Login/admin_login.dart';
import '../Settings/Order.dart';
import '../Settings/settingsAdmin.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final dbHelper = FoodDatabase.instance;
  List<Food> food = [];

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int index = -1;

  void _showMessageInScaffold(String message) {
    SnackBar(content: Text(message));
  }

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 3,
      child: Scaffold(
        body: TabBarView(
          children: <Widget>[
            AdminFirstPage(),
            SettingsAdmin(),
            OrderAdmin(),
          ],
        ),
        bottomNavigationBar: Material(
          color: Colors.white,
          child: TabBar(
            labelPadding: EdgeInsets.only(bottom: 10),
            labelStyle: TextStyle(fontSize: 16.0),
            indicatorColor: Colors.transparent,
            labelColor: Colors.redAccent,
            unselectedLabelColor: Colors.black54,
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.home, size: 28),
                text: 'Home',
              ),
              Tab(
                icon: Icon(Icons.settings, size: 28),
                text: 'Menu',
              ),
              Tab(
                icon: Icon(Icons.food_bank_outlined, size: 28),
                text: 'Order',
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class AdminFirstPage extends StatefulWidget {
  const AdminFirstPage({Key? key}) : super(key: key);

  @override
  State<AdminFirstPage> createState() => _AdminFirstPageState();
}

class _AdminFirstPageState extends State<AdminFirstPage> {
  final dbHelper = FoodDatabase.instance;
  List<Food> food = [];

  int index = -1;

  void _showMessageInScaffold(String message) {
    SnackBar(content: Text(message));
  }

  void _queryAll() async {
    final allRows = await dbHelper.queryAllRows();
    food.clear();
    allRows.forEach((row) => food.add(Food.fromMap(row)));
    setState(() {});
  }


  void _update(id, url, name, price, rate, clients) async {
    Food person = Food(id, url, name, price, rate, clients);
    final rowsAffected = await dbHelper.update(person);
  }

  void _insert(url, name, price, rate, clients) async {
    Map<String, dynamic> row = {
      FoodDatabase.columnUrl: url,
      FoodDatabase.columnName: name,
      FoodDatabase.columnPrice: price,
      FoodDatabase.columnRate: rate,
      FoodDatabase.columnClients: clients,
    };

    Food food = Food.fromMap(row);

    final id = await dbHelper.insert(food);

    // Add the item to Firestore
    FirebaseFirestore.instance.collection('menu').add({
      'url': url,
      'name': name,
      'price': price,
      'rate': rate,
      'clients': clients,
    });

    _showMessageInScaffold('inserted row id: $id');
  }


  void _delete(id) async {
    final rowsDeleted = await dbHelper.delete(id);
  }

  @override
  void initState() {
    super.initState();
    _queryAll();
  }

  List<DropdownMenuItem<String>> get dropdownImages {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(
          value: "assets/images/Spaghetti.jpeg", child: Text("Spaghetti")),
      const DropdownMenuItem(
          value: "assets/images/Burger.jpeg", child: Text("Burger")),
      const DropdownMenuItem(
          value: "assets/images/Pizza.jpeg", child: Text("Pizza")),
      const DropdownMenuItem(
          value: "assets/images/Fries.jpeg", child: Text("Fries")),
      const DropdownMenuItem(
          value: "assets/images/Poutine.jpeg", child: Text("Poutine")),
      const DropdownMenuItem(
          value: "assets/images/Wings.jpeg", child: Text("Chicken Wings")),
      const DropdownMenuItem(
          value: "assets/images/Rice.jpeg", child: Text("Fried Rice")),
      const DropdownMenuItem(
          value: "assets/images/Rolls.jpeg", child: Text("Spring rolls")),
      const DropdownMenuItem(
          value: "assets/images/BatSoup.jpeg", child: Text("Bat Soup")),
    ];
    return menuItems;
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController clientsController = TextEditingController();
  String? selectedValue = "assets/images/Spaghetti.jpeg";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        /*--------------------------App Bar--------------------------*/
          appBar: AppBar(
            title: const Text('Admin'),
            backgroundColor: Colors.redAccent,
          ),
          /*--------------------------App Bar--------------------------*/

          /*---------------------------Body---------------------------*/
          body: SingleChildScrollView(
            reverse: true,
            child: Column(
              children: [
                SizedBox(
                  width: 350,
                  child: TextFormField(
                    controller: nameController,
                    cursorColor: Colors.redAccent,
                    decoration: const InputDecoration(
                        hintText: 'Name',
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.redAccent))),
                  ),
                ),
                SizedBox(
                  width: 350,
                  child: TextField(
                    controller: priceController,
                    cursorColor: Colors.redAccent,
                    decoration: const InputDecoration(
                      hintText: 'Price',
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent)),
                    ),
                  ),
                ),
                SizedBox(
                  width: 350,
                  child: TextField(
                    controller: rateController,
                    cursorColor: Colors.redAccent,
                    decoration: const InputDecoration(
                      hintText: 'Rate',
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent)),
                    ),
                  ),
                ),
                SizedBox(
                  width: 350,
                  child: TextField(
                    controller: clientsController,
                    cursorColor: Colors.redAccent,
                    decoration: const InputDecoration(
                      hintText: 'Clients',
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent)),
                    ),
                  ),
                ),
                DropdownButton(
                  hint: const Text('Select Image'),
                  value: selectedValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue = newValue!;
                    });
                  },
                  items: dropdownImages,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 165,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(Colors.redAccent),
                        ),
                        onPressed: () {
                          String url = selectedValue!;
                          String name = nameController.text;
                          double price = double.parse(priceController.text);
                          double rate = double.parse(rateController.text);
                          int clients = int.parse(clientsController.text);
                          _insert(url, name, price, rate, clients);
                          _queryAll();
                          nameController.clear();
                          priceController.clear();
                          rateController.clear();
                          clientsController.clear();
                        },
                        child: const Text('ADD'),
                      ),
                    ),
                    SizedBox(
                      width: 165,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(Colors.redAccent),
                        ),
                        onPressed: () {
                          String url = selectedValue!;
                          String name = nameController.text;
                          double price = double.parse(priceController.text);
                          double rate = double.parse(rateController.text);
                          int clients = int.parse(clientsController.text);
                          if (index != -1) {
                            // check if an item is selected
                            int foodId = food[index].foodId!;
                            _update(foodId, url, name, price, rate, clients);
                            _queryAll();
                            nameController.clear();
                            priceController.clear();
                            rateController.clear();
                            clientsController.clear();
                            setState(() {
                              index = -1; // reset the index after updating
                            });
                          } else {
                            _showMessageInScaffold(
                                'Please select an item to update');
                          }
                        },
                        child: const Text('UPDATE'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 350,
                  child: Divider(
                    thickness: 2,
                    color: Colors.redAccent,
                  ),
                ),
                ListTile(
                    title: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AdminLogin())
                        );
                      },
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
          )
        /*---------------------------Body---------------------------*/
      ),
    );
  }
}
