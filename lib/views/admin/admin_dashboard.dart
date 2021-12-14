import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_ordering_app/Forms/dish_add_form.dart';
import 'package:food_ordering_app/models/api_error.dart';
import 'package:food_ordering_app/models/api_response.dart';
import 'package:food_ordering_app/models/dish_list.dart';
import 'package:food_ordering_app/models/user_details.dart';
import 'package:food_ordering_app/services/user_services.dart';
import 'package:food_ordering_app/util/toast.dart';
import 'package:food_ordering_app/views/admin/admin_catalog_item.dart';
import 'package:food_ordering_app/views/admin/admin_navigation_drawer.dart';
import 'package:food_ordering_app/widgets/dashboard_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final List<String> listItems = [
    'Order Management',
    'Restaurant Menu Management',
    'User Management',
  ];

  @override
  Widget build(context) {
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      backgroundColor: Color(0xfff5f5f5),
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            constraints: BoxConstraints.expand(width: 80),
            icon: Icon(Icons.account_circle_rounded),
            iconSize: 30,
            onPressed: () {
              _profileHandler(context);
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return SimpleCardView(
              index: index,
              name: listItems[index],
            );
          },
          itemCount: listItems.length,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => DishAddForm()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

void _profileHandler(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String _userId = (prefs.getString("user_id") ?? "");
  if (_userId == "") {
    Navigator.pushReplacementNamed(context, '/home');
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
