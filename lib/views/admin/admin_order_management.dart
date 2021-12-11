import 'package:flutter/material.dart';
import 'package:food_ordering_app/widgets/card_view.dart';

class AdminOrderManagement extends StatefulWidget {
  @override
  _AdminOrderManagementState createState() => _AdminOrderManagementState();
}

class _AdminOrderManagementState extends State<AdminOrderManagement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Management'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return CardView(
              name: 'Name',
              description: 'Description',
              price: '10',
              image: 'profile_placeholder.png',
            );
          },
          itemCount: 5,
        ),
      ),
    );
  }
}
