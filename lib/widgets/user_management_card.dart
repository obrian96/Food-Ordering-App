import 'package:flutter/material.dart';
import 'package:food_ordering_app/util/soft_utils.dart';
import 'package:food_ordering_app/util/toast.dart';

class UserManagementCard extends StatelessWidget {
  static const String TAG = 'user_management_card.dart';

  final String userId, userName, userImage;
  final int isAdmin;

  UserManagementCard(
      {this.userId, this.userName, this.userImage, this.isAdmin});

  @override
  Widget build(context) {
    return Container(
      padding: const EdgeInsets.all(2),
      height: 120,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: InkWell(
          splashColor: Colors.grey[200],
          borderRadius: BorderRadius.circular(8.0),
          onTap: () async {
            await _changeUserRole(context, userId);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 100,
                height: 100,
                margin: const EdgeInsets.all(5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: SoftUtils().loadImage(userImage),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$userName',
                        style: const TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      Text('Role: ${isAdmin == 1 ? 'Admin' : 'User'}'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _changeUserRole(context, userId) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: const Text('Roles'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const [
                Text("Change this user to..."),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Admin'),
              onPressed: () async {
                Navigator.pop(context, 1);
                await _handleSubmit(context, 1);
              },
            ),
            TextButton(
              child: Text('User'),
              onPressed: () async {
                Navigator.pop(context, 0);
                await _handleSubmit(context, 0);
              },
            ),
          ],
        );
      },
    );
  }

  Future _handleSubmit(context, isAdmin) async {
    bool done = await SoftUtils().changeUserRole(userId, isAdmin);
    if (done) {
      Navigator.pushReplacementNamed(context, '/adminUserManagement');
    } else {
      toast('Role update failed!', Colors.red);
    }
  }
}
