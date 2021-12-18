import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_ordering_app/models/api_error.dart';
import 'package:food_ordering_app/models/api_response.dart';
import 'package:food_ordering_app/models/user_details.dart';
import 'package:food_ordering_app/services/user_services.dart';
import 'package:food_ordering_app/util/image_helper.dart';
import 'package:food_ordering_app/util/toast.dart';
import 'package:food_ordering_app/views/admin/admin_navigation_drawer.dart';
import 'package:food_ordering_app/widgets/dashboard_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  var imgArgs;

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
            return DashboardCard(
              index: index,
              name: listItems[index],
            );
          },
          itemCount: listItems.length,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.pushNamed(context, '/dishAddForm');
          showImagePickerOptions(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future showImagePickerOptions(context) async {
    return showDialog(
      context: context,
      // barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Item'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const [
                Text("Choose a new image from..."),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Gallery'),
              onPressed: () {
                Navigator.pop(context, 'Gallery');
                _handleURLButtonPress(context, ImageSourceType.gallery);
              },
            ),
            TextButton(
              child: Text('Camera'),
              onPressed: () {
                Navigator.pop(context, 'Camera');
                _handleURLButtonPress(context, ImageSourceType.camera);
              },
            ),
          ],
        );
      },
    );
  }

  void _handleURLButtonPress(context, type) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageFromGalleryEx(
          type,
          nextRoute: '/dishAddForm',
        ),
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
