import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ChezIslem/Database/Food/foodDB.dart';
import 'package:ChezIslem/Database/CartDatabase/cartDB.dart';
import 'package:ChezIslem/Database/CartDatabase/cartModel.dart';
import 'package:ChezIslem/Database/Food/food.dart';
import 'foodCard.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {
  final dbHelper = FoodDatabase.instance;
  final dbCartHelper = CartDatabase.instance;
  List<Map<String, dynamic>> food = [];
  List<Food> foodList = [];
  @override
  void initState() {
    super.initState();
    _queryAll();
  }
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
                left: 20.0,
                right: 20.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Text(
                    'ScanEat',
                    style: TextStyle(
                      fontSize: 30.0,
                      color: Color(0xFFE85852),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 25.0,
                left: 20.0,
                right: 20.0,
              ),
              child: TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: theme.primaryColor, width: 1.0),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    size: 28.0,
                    color: theme.primaryColor,
                  ),
                  suffixIcon: Icon(
                    Icons.filter_list,
                    size: 28.0,
                    color: theme.primaryColor,
                  ),
                  hintText: 'Find food',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 19.0,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                top: 25.0,
                left: 20.0,
                bottom: 10.0,
              ),
              child: Text(
                'Popular Food',
                style: TextStyle(fontSize: 21.0),
              ),
            ),
            SingleChildScrollView(
              child: SizedBox(
                height: 900.0,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('menu').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }

                    List<DocumentSnapshot> documents = snapshot.data!.docs;

                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Set the number of columns in the grid
                        crossAxisSpacing: 10.0, // Set the spacing between columns
                        mainAxisSpacing: 10.0, // Set the spacing between rows
                      ),
                      padding: const EdgeInsets.all(10.0),
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> data = documents[index].data() as Map<String, dynamic>;

                        return GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(data['name']),
                                content: Container(
                                  height: MediaQuery.of(context).size.height * 0.3,
                                  width: MediaQuery.of(context).size.width * 0.5,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(data['url']),
                                    ),
                                  ),
                                  child: Text('${data['price']}\$'),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      _insertCart(
                                        data['url'],
                                        data['name'],
                                        data['price'],
                                        data['rate'],
                                        data['clients'],
                                      );
                                    },
                                    child: const Text(
                                      'Add to cart',
                                      style: TextStyle(color: Color(0xFFE85852)),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                          child: Hero(
                            tag: 'detail_food$index',
                            child: FoodCard(
                              width: size.width / 2 - 30.0,
                              primaryColor: theme.primaryColor,
                              productName: data['name'],
                              productPrice: data['price'].toString(),
                              productUrl: data['url'],
                              productClients: data['clients'].toString(),
                              productRate: data['rate'].toString(),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),




            const Padding(
              padding: EdgeInsets.only(
                left: 20.0,
                bottom: 10.0,
                top: 35.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _insert(url, name, price, rate, clients) async {
    Map<String, dynamic> row = {
      FoodDatabase.columnUrl: url,
      FoodDatabase.columnName: name,
      FoodDatabase.columnPrice: price,
      FoodDatabase.columnRate: rate,
      FoodDatabase.columnClients: clients
    };
    Food food = Food.fromMap(row);
    final id = await dbHelper.insert(food);
  }

  void _insertCart(url, name, price, rate, clients) async {
    Map<String, dynamic> row = {
      CartDatabase.columnUrl: url,
      CartDatabase.columnName: name,
      CartDatabase.columnPrice: price,
      CartDatabase.columnRate: rate,
      CartDatabase.columnClients: clients
    };
    CartModel cart = CartModel.fromMap(row);
    final id = await dbCartHelper.insert(cart);
  }

  void _queryAll() async {
    final allRows = await dbHelper.queryAllRows();
    foodList = allRows.map((item) => Food.fromMap(item)).toList();
    setState(() {});
  }
}
