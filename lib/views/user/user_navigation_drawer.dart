import 'package:flutter/material.dart';
import 'package:food_ordering_app/models/api_error.dart';
import 'package:food_ordering_app/models/api_response.dart';
import 'package:food_ordering_app/models/user_details.dart';
import 'package:food_ordering_app/services/user_services.dart';
import 'package:food_ordering_app/util/toast.dart';
import 'package:food_ordering_app/views/shared/cart_page.dart';
import 'package:food_ordering_app/views/shared/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: LayoutBuilder(
          builder: (context, constraint) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraint.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      DrawerHeader(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              "assets/app-logo-62-removebg-preview-square.png",
                            ),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        child: null,
                      ),
                      ListTile(
                        leading: Icon(Icons.home),
                        title: Text("Home"),
                        onTap: () {
                          Navigator.pop(context);
                          // Navigator.of(context).push(MaterialPageRoute(
                          //   builder: (context) => Dashboard(),
                          // ));
                        },
                      ),
                      ListTile(
                        title: Text(
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
                          Navigator.pushNamed(context, '/orderHistory');
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.account_circle_rounded),
                        title: Text("View Profile"),
                        onTap: () {
                          _profileHandler(context);
                          // Navigator.of(context).push(MaterialPageRoute(
                          //   builder: (context) => ProfileScreen(),
                          // ));
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
      ),
    );
  }
}

void _profileHandler(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String _userId = (prefs.getString("user_id") ?? "");
  if (_userId == "") {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/home',
      ModalRoute.withName('/home'),
    );
    toast("invalid Login State!");
  } else {
    UserServices userServices = new UserServices();
    ApiResponse _apiResponse = await userServices.details(_userId);
    if ((_apiResponse.apiError as ApiError) == null) {
      Navigator.pushNamed(
        context,
        '/profile',
        arguments: (_apiResponse.data as UserDetails),
      );
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
        ModalRoute.withName('/home'),
      );
      toast("invalid Login State!");
    }
  }
}
