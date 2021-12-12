import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_ordering_app/models/api_error.dart';
import 'package:food_ordering_app/models/api_response.dart';
import 'package:food_ordering_app/models/dish_list.dart';
import 'package:food_ordering_app/models/user_details.dart';
import 'package:food_ordering_app/services/user_services.dart';
import 'package:food_ordering_app/views/user/user_catalog_item.dart';
import 'package:food_ordering_app/views/user/user_navigation_drawer.dart';
import 'package:food_ordering_app/util/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  DishList futDishList;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DishList args = ModalRoute.of(context).settings.arguments as DishList;
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      backgroundColor: Color(0xfff5f5f5),
      appBar: AppBar(
        title: new Text("Food Ordering App"),
        actions: [
          IconButton(
            constraints: BoxConstraints.expand(width: 80),
            icon: Icon(Icons.account_circle_rounded),
            iconSize: 30,
            // Text('View Profile', textAlign: TextAlign.center),
            onPressed: () {
              _profileHandler(context);
            },
          ),
        ],
      ),
      body: CatalogList(dishList: args),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/cart');
        },
        child: Icon(Icons.shopping_cart),
      ),
    );
  }
}

void _profileHandler(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String userId = (prefs.getString("user_id") ?? "");
  if (userId == "") {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/home',
      ModalRoute.withName('/home'),
    );
    toast("invalid Login State!");
  } else {
    UserServices userServices = new UserServices();
    ApiResponse apiResponse = await userServices.details(userId);
    if ((apiResponse.apiError as ApiError) == null) {
      Navigator.pushNamed(
        context,
        '/profile',
        arguments: (apiResponse.data as UserDetails),
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

class CatalogList extends StatelessWidget {
  final DishList dishList;

  CatalogList({Key key, this.dishList});

  @override
  Widget build(BuildContext context) {
    return (dishList == null)
        ? "Nothing to show".text.xl3.make().centered()
        : ListView.builder(
            shrinkWrap: true,
            itemCount: dishList.length,
            itemBuilder: (context, index) {
              return CatalogItemUser(dish: dishList.getIndex(index));
            },
          );
  }
}
