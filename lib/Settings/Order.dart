import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderAdmin extends StatefulWidget {
  const OrderAdmin({Key? key});

  @override
  State<OrderAdmin> createState() => _OrderAdminState();
}

class _OrderAdminState extends State<OrderAdmin> {

  void _deleteOrder(String orderId) async {
    await FirebaseFirestore.instance.collection('orders').doc(orderId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OrderAdmin'),
        backgroundColor: const Color(0xFFE85852),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('orders').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  // Process the data from the snapshot
                  final List<DocumentSnapshot> documents = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      final order = documents[index];
                      final orderId = order.id; // Get the document ID
                      final name = order['name'];
                      final tableNumber = order['tableNumber'];
                      final orderItems = order['orderItems'];

                      return Card(
                        child: ListTile(
                          title: Text('Name: $name, Table Number: $tableNumber'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: orderItems.map<Widget>((item) {
                              final itemName = item['itemName'];
                              final price = item['price'];
                              return Text('Item: $itemName, Price: $price');
                            }).toList(),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              // Call the method to delete the order
                              _deleteOrder(orderId);
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
