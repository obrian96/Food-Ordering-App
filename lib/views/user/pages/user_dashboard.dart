import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_ordering_app/models/api_error.dart';
import 'package:food_ordering_app/models/api_response.dart';
import 'package:food_ordering_app/models/dish_list.dart';
import 'package:food_ordering_app/models/user_details.dart';
import 'package:food_ordering_app/services/user_services.dart';
import 'package:food_ordering_app/views/cart_page.dart';
import 'package:food_ordering_app/views/user/navigation_drawer_widget.dart';
import 'package:food_ordering_app/views/user/pages/user_catalog_item.dart';
import 'package:food_ordering_app/widgets/msg_toast.dart';
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
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CartPage()));
        },
        child: Icon(Icons.shopping_cart),
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
    msgToast("invalid Login State!");
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
      msgToast("invalid Login State!");
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
