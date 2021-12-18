import 'package:flutter/material.dart';
import 'package:food_ordering_app/models/api_error.dart';
import 'package:food_ordering_app/models/api_response.dart';
import 'package:food_ordering_app/models/dish.dart';
import 'package:food_ordering_app/models/server_response.dart';
import 'package:food_ordering_app/services/rest_services.dart';
import 'package:food_ordering_app/util/image_helper.dart';
import 'package:food_ordering_app/util/logcat.dart';
import 'package:food_ordering_app/util/soft_utils.dart';
import 'package:food_ordering_app/util/toast.dart';
import 'package:velocity_x/src/flutter/padding.dart';

class DishEditForm extends StatefulWidget {
  @override
  _DishEditFormState createState() => _DishEditFormState();
}

class _DishEditFormState extends State<DishEditForm> {
  TextEditingController dishName = new TextEditingController();
  TextEditingController dishPrice = new TextEditingController();
  TextEditingController adminId = new TextEditingController();

  int isAvailable;
  String availabilityGroup = '';
  String valueChoose;
  List listItem = ['starter', 'main course', 'dessert', 'snack', 'beverage'];
  String _image;
  Dish dish;

  static const String TAG = 'dish_edit_form.dat';

  void _handleURLButtonPress(BuildContext context, var type) async {
    final args = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageFromGalleryEx(type, dish: dish),
      ),
    );
    if (args[0]) {
      setState(() {
        dish = args[1];
        Log.i(TAG, '${dish.dishImage}');
      });
    }
  }

  @override
  void initState() {
    super.initState();
    SoftUtils()
        .getUserId()
        .then((value) => setState(() => adminId.text = value));
  }

  @override
  Widget build(BuildContext context) {
    dish = ModalRoute.of(context).settings.arguments as Dish;
    _image = dish.dishImage;
    dishName.text = dish.dishName;
    dishPrice.text = '${dish.dishPrice}';
    isAvailable = dish.isAvailable;
    availabilityGroup = isAvailable == 1 ? 'Available' : 'Not Available';
    valueChoose = '${dish.dishType}';
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Color(0xff409439),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Edit Dish"),
        centerTitle: true,
        // actions: [IconButton(icon: Icon(Icons.search), onPressed: () {})],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: SoftUtils().loadImage(
                    _image,
                    width: 150.0,
                    height: 150.0,
                    fit: BoxFit.fitHeight,
                    placeholder: 'assets/food.png',
                  ),
                ).p16(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 14, 0),
                  child: SizedBox(
                    width: 100,
                    height: 60,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.flip_camera_ios, size: 20),
                      label: Text(
                        'Edit Image',
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () {
                        showImagePickerOptions();
                      },
                    ),
                  ),
                ),
              ],
            ),
            Card(
              child: TextField(
                controller: dishName,
                style: TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xffEEEEEE),
                  labelText: "Dish name",
                ),
                onChanged: (value) {},
              ),
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 24.0),
            ),
            Card(
              child: TextField(
                controller: dishPrice,
                style: TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xffEEEEEE),
                  labelText: "Dish Price",
                ),
                onChanged: (value) {},
              ),
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 24.0),
            ),
            Row(
              children: [
                SizedBox(
                  width: 40.0,
                ),
                Text("Available "),
                Radio(
                    value: 'Available',
                    groupValue: availabilityGroup,
                    onChanged: (val) {
                      setState(() {
                        availabilityGroup = val;
                        isAvailable = 1;
                      });
                    }),
                SizedBox(
                  width: 50.0,
                ),
                Text("Not Available"),
                Radio(
                    value: 'Not Available',
                    groupValue: availabilityGroup,
                    onChanged: (val) {
                      setState(() {
                        availabilityGroup = val;
                        isAvailable = 0;
                      });
                    }),
              ],
            ),
            Card(
              child: DropdownButton(
                hint: Text("Select Dish Type"),
                dropdownColor: Colors.white,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 36,
                isExpanded: true,
                underline: SizedBox(),
                style: TextStyle(color: Colors.black, fontSize: 15),
                value: valueChoose,
                onChanged: (newValue) {
                  setState(() {
                    valueChoose = newValue;
                  });
                },
                items: listItem.map((valueItem) {
                  return DropdownMenuItem(
                    value: valueItem,
                    child: Text(valueItem),
                  );
                }).toList(),
              ),
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 24.0),
            ),
            // SizedBox(
            //   height: 5.0,
            // ),
            // Card(
            //   child: TextField(
            //     controller: adminId,
            //     style: TextStyle(
            //       color: Colors.black,
            //     ),
            //     decoration: InputDecoration(
            //       filled: true,
            //       fillColor: Color(0xffEEEEEE),
            //       labelText: "admin ID",
            //     ),
            //     onChanged: (value) {},
            //   ),
            //   margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 24.0),
            // ),
            Card(
              color: Colors.blueAccent,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 24.0),
              child: ListTile(
                onTap: () {
                  // showAlertDialog(context);
                  Log.i(TAG, '${dish.dishImage}');
                  _handleDishEdit(context, dish);
                },
                title: Center(
                  child: Text(
                    'SAVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'SourceSansPro',
                      fontSize: 17.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Log.i(TAG, '${dish.dishImage}');
          // _handleDishEdit(context, dish);
          showAlertDialog(context, dish.dishId);
        },
        backgroundColor: Colors.redAccent,
        child: Icon(Icons.delete),
      ),
    );
  }

  void _handleDishEdit(context, Dish dish) async {
    RestServices restServices = new RestServices();
    ApiResponse _apiResponse = await restServices.editDish(
      dish.dishImage,
      dishName.text,
      int.parse(dishPrice.text),
      isAvailable,
      valueChoose,
      dish.dishId,
      adminId.text,
    );

    print(_apiResponse.apiError);
    if ((_apiResponse.apiError as ApiError) == null) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/loadDash',
        ModalRoute.withName('/loadDash'),
        arguments: 1,
      );
    } else {
      toast("Dish Editing Failed!", Colors.red);
    }
  }

  Future showImagePickerOptions() async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Image'),
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
}

showAlertDialog(context, dishId) {
  // Create button
  Widget okButton = Row(
    children: [
      TextButton(
        child: Text("Yes"),
        onPressed: () {
          _deleteDish(context, dishId);
        },
      ),
      TextButton(
        child: Text("No"),
        onPressed: () {
          Navigator.pop(context);
        },
      )
    ],
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Delete"),
    content: Text("Are you sure you want to Delete?"),
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

void _deleteDish(context, dishId) async {
  ApiResponse apiResponse = await SoftUtils().deleteDish(dishId);
  const String TAG = 'dish_edit_form.dart';
  if (apiResponse != null && apiResponse.apiError == null) {
    Log.d(TAG, '${(apiResponse.data as ServerResponse).message}');
    toast('${(apiResponse.data as ServerResponse).message}', Colors.green);
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/loadDash',
      ModalRoute.withName('/loadDash'),
      arguments: 1,
    );
  } else {
    Log.e(TAG, '${(apiResponse.apiError as ApiError).error}');
    toast('${(apiResponse.apiError as ApiError).error}');
  }
}
