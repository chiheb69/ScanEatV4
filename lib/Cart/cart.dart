import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ChezIslem/header.dart';
import 'package:ChezIslem/Database/CartDatabase/cartDB.dart';
import 'package:ChezIslem/Database/CartDatabase/cartModel.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> with TickerProviderStateMixin {
  final dbHelper = CartDatabase.instance;

  TabController? _tabController;
  List<CartModel> foodList = [];

  @override
  void initState() {
    this._tabController = TabController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );
    super.initState();
    _queryAll();
  }

  void _queryAll() async {
    final allRows = await dbHelper.queryAllRows();
    foodList = allRows.map((item) => CartModel.fromMap(item)).toList();
    setState(() {});
  }

  void _delete(id) async {
    final rowsDeleted = await dbHelper.delete(id);
    _queryAll();
    setState(() {}); // Add this line to trigger a UI update
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _queryAll();
  }

  void _clearCart() {
    // Clear the local cart list
    foodList.clear();
  }

  void _insert(url, name, price, rate, clients) async {
    Map<String, dynamic> row = {
      CartDatabase.columnUrl: url,
      CartDatabase.columnName: name,
      CartDatabase.columnPrice: price,
      CartDatabase.columnRate: rate,
      CartDatabase.columnClients: clients
    };
    CartModel cart = CartModel.fromMap(row);
    final id = await dbHelper.insert(cart);
    await FirebaseFirestore.instance.collection('cartItems').add({
      'url': url,
      'name': name,
      'price': price,
      'rate': rate,
      'clients': clients,
    });
  }

  Widget renderAddList() {
    return ListView.builder(
      itemCount: foodList.length,
      itemBuilder: (BuildContext context, int index) {
        Color primaryColor = Theme
            .of(context)
            .primaryColor;
        return Container(
          margin: EdgeInsets.only(bottom: 10.0),
          child: GestureDetector(
            onTap: () {},
            child: Hero(
              tag: 'detail_food$index',
              child: Card(
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(foodList[index].url!),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(foodList[index].name!),
                                IconButton(
                                    onPressed: () =>
                                        _delete(foodList[index].cartId),
                                    icon: Icon(Icons.delete_outline)),
                              ],
                            ),
                            Text('${foodList[index].price}\$'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Icon(Icons.remove),
                                Container(
                                  color: primaryColor,
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 3.0,
                                    horizontal: 12.0,
                                  ),
                                  child: Text(
                                    '${foodList[index].rate!.toString()} stars',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.add,
                                  color: primaryColor,
                                ),
                              ],
                            ),
                          ],
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
    );
  }

  Widget renderTracking() {
    return ListView.builder(
      itemCount: foodList.length,
      itemBuilder: (BuildContext context, int index) {
        Color primaryColor = Theme
            .of(context)
            .primaryColor;
        return Container(
          margin: const EdgeInsets.only(bottom: 10.0),
          child: GestureDetector(
            onTap: () {},
            child: Hero(
              tag: 'detail_food$index',
              child: Card(
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(foodList[index].url!),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(foodList[index].name!),
                                Text(
                                  'Tracking Item',
                                  style: TextStyle(color: primaryColor),
                                ),
                              ],
                            ),
                            Text('${foodList[index].price}\$'),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'View Detail',
                                textAlign: TextAlign.end,
                              ),
                            )
                          ],
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
    );
  }

  Widget renderDoneOrder() {
    return ListView.builder(
      itemCount: foodList.length,
      itemBuilder: (BuildContext context, int index) {
        Color primaryColor = Theme
            .of(context)
            .primaryColor;
        return Container(
          margin: const EdgeInsets.only(bottom: 10.0),
          child: GestureDetector(
            onTap: () {},
            child: Hero(
              tag: 'detail_food$index',
              child: Card(
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(foodList[index].url!),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(vertical: 5.0),
                              // child: Text(cart['name']),
                            ),
                            Text('${foodList[index].price}\$'),
                            Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    // Text(cart['rate']),
                                    Text(
                                      'Give your review',
                                      style: TextStyle(
                                        color: primaryColor,
                                      ),
                                    ),
                                  ],
                                ))
                          ],
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
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery
        .of(context)
        .size;

    return SafeArea(
      child: Column(
        children: <Widget>[
          CustomHeader(
            title: 'Cart Food',
            quantity: foodList.length,
            internalScreen: false,
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 10.0,
            ),
            child: TabBar(
              controller: this._tabController,
              indicatorColor: theme.primaryColor,
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: Colors.black87,
              unselectedLabelColor: Colors.black87,
              tabs: <Widget>[
                Tab(text: 'Add Cart'),
                Tab(text: 'Tracking Order'),
                Tab(text: 'Done Order'),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: TabBarView(
                controller: this._tabController,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Expanded(
                        child: this.renderAddList(),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 35.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: theme.primaryColor,
                        ),
                        child: TextButton(
                          onPressed: () {
                            // Call the method to insert into Firebase
                            _insertIntoFirebase();
                          },
                          child: Text(
                            'CHECKOUT',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Expanded(
                        child: this.renderTracking(),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 65.0),
                        padding: const EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 35.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: theme.primaryColor,
                        ),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.location_searching,
                                size: 20.0,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'View Tracking Order',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 10.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  this.renderDoneOrder(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _insertIntoFirebase() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String name = '';
        String tableNumber = '';

        return AlertDialog(
          title: Text('Enter Name and Table Number'),
          content: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Name'),
                onChanged: (value) {
                  name = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Table Number'),
                onChanged: (value) {
                  tableNumber = value;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _insertItemsIntoFirebase(name, tableNumber);

                // Automatically trigger the delete operation
                _deleteItems();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _deleteItems() {
    // Iterate through the foodList and call _delete for each item
    for (var item in foodList) {
      _delete(item.cartId);
    }
  }

  bool checkoutSuccessful = false;
  void _insertItemsIntoFirebase(String name, String tableNumber) async {
    // Create a list to hold all items for the current order
    List<Map<String, dynamic>> orderItems = [];

    for (var item in foodList) {
      // Add each item to the orderItems list
      orderItems.add({
        'url': item.url,
        'itemName': item.name,
        'price': item.price,
        'rate': item.rate,
        'clients': item.clients,
      });
    }

    // Add all items to the 'orders' collection under the same document
    await FirebaseFirestore.instance.collection('orders').add({
      'name': name,
      'tableNumber': tableNumber,
      'orderItems': orderItems, // Add the list of items to the document
    }).then((value) {
      // Clear the cart after successful checkout
      _clearCart();
      setState(() {});
    });
  }



}