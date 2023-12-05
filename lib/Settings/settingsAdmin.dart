import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsAdmin extends StatefulWidget {
  const SettingsAdmin({Key? key});

  @override
  State<SettingsAdmin> createState() => _SettingsAdminState();
}

class _SettingsAdminState extends State<SettingsAdmin> {

  void _deleteOrder(String menuId) async {
    await FirebaseFirestore.instance.collection('menu').doc(menuId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
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
                stream: FirebaseFirestore.instance.collection('menu').snapshots(),
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
                      final menu = documents[index];
                      final menuId = menu.id; // Get the document ID
                      final name = menu['name'];
                      final price = menu['price'];
                      final url = menu['url']; // Assuming you have a field named 'imgUrl'

                      return Card(
                        child: ListTile(
                          title: Text(name),
                          subtitle: Text('Price: $price'),
                          leading: Container(
                            width: 50, // Set the width of the image container
                            height: 50, // Set the height of the image container
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(url), // Use the imgUrl from the document
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              // Call the method to delete the order
                              _deleteOrder(menuId);
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
