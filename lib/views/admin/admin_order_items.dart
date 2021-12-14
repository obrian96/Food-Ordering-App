import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_ordering_app/util/soft_utils.dart';

class AdminOrderItems extends StatefulWidget {
  @override
  _AdminOrderItems createState() => _AdminOrderItems();
}

class _AdminOrderItems extends State<AdminOrderItems> {
  @override
  Widget build(context) {
    final String userId = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Items'),
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
      body: FutureBuilder(
          future: getOrderItems(),
          builder: (context, snapshot) {
            switch (SoftUtils.state(snapshot)) {
              case SoftUtils.COMPLETE:
                return Container(
                  child: Center(
                    child: Text('Order Items'),
                  ),
                );

              case SoftUtils.UNKNOWN:
              case SoftUtils.ERROR:
                return Container(
                  child: Center(
                    child: Text('Unable to load data!'),
                  ),
                );

              case SoftUtils.LOADING:
              default:
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
            }
          }),
    );
  }

  Future getOrderItems() async {
    return 0;
  }
}
