import 'package:flutter/material.dart';
import 'package:food_ordering_app/views/user/pages/order_history.dart';
import 'package:food_ordering_app/views/user/pages/user_dashboard.dart';

import '../cart_page.dart';
import '../profile_page.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: LayoutBuilder(
        builder: (context, constraint) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: <Widget>[
                    DrawerHeader(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  "assets/app-logo-62-removebg-preview-square.png"),
                              fit: BoxFit.cover)),
                      margin: EdgeInsets.all(0.0),
                    ),
                    ListTile(
                      leading: Icon(Icons.home),
                      title: Text("Home"),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Dashboard(),
                        ));
                      },
                    ),
                    new ListTile(
                      title: new Text(
                        'User Actions',
                        style: TextStyle(color: Colors.black54),
                      ),
                      dense: true,
                    ),
                    ListTile(
                      leading: Icon(Icons.shopping_cart),
                      title: Text("Cart"),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CartPage(),
                        ));
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.money),
                      title: Text("Your Orders"),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => OrderHistoryPage(),
                        ));
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.account_box),
                      title: Text("View Profile"),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProfileScreen(),
                        ));
                      },
                    ),
                    const Expanded(child: SizedBox()),
                    const Divider(height: 1.0, color: Colors.grey),
                    ListTile(
                      leading: Icon(Icons.exit_to_app),
                      title: Text("Logout"),
                      onTap: () {
                        showAlertDialog(context);
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
