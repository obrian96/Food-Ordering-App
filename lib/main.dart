import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_ordering_app/forms/dish_add_form.dart';
import 'package:food_ordering_app/forms/dish_edit_form.dart';
import 'package:food_ordering_app/forms/user_detail_form.dart';
import 'package:food_ordering_app/views/admin/admin_dashboard.dart';
import 'package:food_ordering_app/views/admin/admin_order_management.dart';
import 'package:food_ordering_app/views/admin/admin_restaurant_management.dart';
import 'package:food_ordering_app/views/admin/admin_user_management.dart';
import 'package:food_ordering_app/views/shared/cart_page.dart';
import 'package:food_ordering_app/views/shared/dashboard_loader.dart';
import 'package:food_ordering_app/views/shared/home_page.dart';
import 'package:food_ordering_app/views/shared/landing_page.dart';
import 'package:food_ordering_app/views/shared/login_page.dart';
import 'package:food_ordering_app/views/shared/profile_page.dart';
import 'package:food_ordering_app/views/shared/signup_page.dart';
import 'package:food_ordering_app/views/user/user_dashboard.dart';
import 'package:food_ordering_app/views/user/user_order_history.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Food Delivery App',
        routes: {
          // Launcher page
          '/': (context) => LandingPage(),
          // Home page
          '/home': (context) => HomePage(),
          // Login page
          '/login': (context) => LoginPage(),
          // Sign up page
          '/signup': (context) => SignUpPage(),
          // Dashboard
          '/dash': (context) => Dashboard(),
          '/orderHistory': (context) => OrderHistoryPage(),
          // Admin dashboard
          '/adminDash': (context) => AdminDashboard(),
          // Profile page
          '/profile': (context) => ProfileScreen(),
          // Cart page
          '/cart': (context) => CartPage(),
          '/loadDash': (context) => DashboardLoader(),
          '/dishEditForm': (context) => DishEditForm(),
          '/dishAddForm': (context) => DishAddForm(),
          '/userDetailsForm': (context) => UserDetailForm(),
          // Admin order management page
          '/adminOrderManagement': (context) => AdminOrderManagement(),
          // Admin restaurant menu management page
          '/adminRestaurantManagement': (context) =>
              AdminRestaurantManagement(),
          // Admin user management page
          '/adminUserManagement': (context) => AdminUserManagement(),
        });
  }
}
