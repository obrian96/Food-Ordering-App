import 'package:flutter/material.dart';
import 'package:food_ordering_app/models/user.dart';
import 'package:food_ordering_app/util/logcat.dart';
import 'package:food_ordering_app/util/soft_utils.dart';
import 'package:food_ordering_app/widgets/user_management_card.dart';

class AdminUserManagement extends StatefulWidget {
  @override
  _AdminUserManagement createState() => _AdminUserManagement();
}

class _AdminUserManagement extends State<AdminUserManagement> {
  static const String TAG = 'admin_user_management.dart';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Management'),
        centerTitle: true,
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
        future: SoftUtils().getUserList(),
        builder: (context, snapshot) {
          switch (SoftUtils().state(snapshot)) {
            case FutureState.COMPLETE:
              return Container(
                padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    User user = snapshot.data[index];
                    return UserManagementCard(
                      userId: user.user_id,
                      userName: user.user_name,
                      userImage: user.user_image,
                      isAdmin: user.isAdmin,
                    );
                  },
                  itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                ),
              );

            case FutureState.UNKNOWN:
            case FutureState.ERROR:
              Log.e(TAG, '${snapshot.error}');
              return Container(
                child: Center(
                  child: Text('Unable to load data!'),
                ),
              );

            case FutureState.LOADING:
            default:
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
          }
        },
      ),
    );
  }
}
