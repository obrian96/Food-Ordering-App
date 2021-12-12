import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_ordering_app/models/user_details.dart';
import 'package:food_ordering_app/util/logcat.dart';
import 'package:food_ordering_app/util/soft_utils.dart';
import 'package:food_ordering_app/views/user/user_order_history.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  static const String TAG = 'profile_page.dart';

  bool visibilityController = true;
  SharedPreferences sharedPrefs;
  Image profileImage;

  @override
  Widget build(BuildContext context) {
    final UserDetails args =
        ModalRoute.of(context).settings.arguments as UserDetails;
    if (args.isAdmin == 1) visibilityController = false;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: new Text('Profile Page'),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.white,
            ),
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        backgroundColor: Color(0xff212121),
        body: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
                future: loadProfileImage(),
                builder: (context, snapshot) {
                  switch (SoftUtils.state(snapshot)) {
                    case SoftUtils.COMPLETE:
                      return CircleAvatar(
                        radius: 50.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50.0),
                          child: SoftUtils.loadImage(snapshot.data),
                        ),
                      );

                    case SoftUtils.UNKNOWN:
                    case SoftUtils.ERROR:
                      Log.e(TAG, 'Image loading error');
                      return CircleAvatar(
                        radius: 50.0,
                        backgroundImage:
                            AssetImage('assets/profile_placeholder.png'),
                      );

                    case SoftUtils.LOADING:
                    default:
                      return CircularProgressIndicator();
                  }
                }),
            SizedBox(
              height: 20.0,
              width: 150.0,
//                  child: Divider(
//                    color: Colors.white,
//                  ),
            ),
            Text(
              args.user_name,
              style: TextStyle(
                fontFamily: 'Pacifico',
                fontSize: 30.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10.0,
              width: 150.0,
//                  child: Divider(
//                    color: Colors.white,
//                  ),
            ),
            Text(
              args.user_email,
              style: TextStyle(
                fontFamily: 'Source Sans Pro',
                color: Colors.white,
                fontSize: 13.0,
                letterSpacing: 2.5,
                //fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20.0,
              width: 150.0,
              child: Divider(
                color: Colors.white,
              ),
            ),
            Visibility(
              visible: visibilityController,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                color: Color(0xff373737),
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OrderHistoryPage()));
                  },
                  leading: Icon(
                    Icons.history,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Your orders',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Source Sans Pro',
                      fontSize: 17.0,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Card(
              color: Color(0xff373737),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              child: ListTile(
                onTap: () {
                  Navigator.pushNamed(context, '/userDetailForm');
                },
                leading: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                title: Text(
                  'Edit Profile',
                  style: TextStyle(
                      fontSize: 17.0,
                      color: Colors.white,
                      fontFamily: 'Source Sans Pro'),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                ),
              ),
            ),
            Card(
              color: Color(0xff373737),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              child: ListTile(
                onTap: () {
                  showAlertDialog(context);
                },
                leading: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                title: Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Source Sans Pro',
                    fontSize: 17.0,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }

  Future loadProfileImage() async {
    sharedPrefs = await SharedPreferences.getInstance();
    String user_image = await sharedPrefs.getString('user_image');
    Log.d(TAG, 'Image: ${user_image}');
    return user_image;
  }
}

showAlertDialog(BuildContext context) {
  // Create button
  Widget okButton = Row(
    children: [
      TextButton(
        child: Text("Yes"),
        onPressed: () {
          _logoutHandler(context);
        },
      ),
      TextButton(
        child: Text("No"),
        onPressed: () => Navigator.pop(context),
      )
    ],
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Logout"),
    content: Text("Are you sure you want to Logout?"),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

void _logoutHandler(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('user_id');
  Navigator.pushNamedAndRemoveUntil(
      context, '/home', ModalRoute.withName('/home'));
}
