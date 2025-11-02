import 'package:app_client_2/providers/cart_provider.dart';
import 'package:app_client_2/providers/user_provider.dart';
import 'package:app_client_2/views/cart_page.dart';
import 'package:app_client_2/views/home.dart';
import 'package:app_client_2/views/orders_page.dart';
import 'package:app_client_2/views/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeNav extends StatefulWidget {
  const HomeNav({super.key});

  @override
  State<HomeNav> createState() => _HomeNavState();
}

class _HomeNavState extends State<HomeNav> {

  @override
  void initState() {
    Provider.of<UserProvider>(context,listen: false);
    super.initState();
  }

  int selectedIndex = 0;

  List pages = [
    HomePage(),
    OrdersPage(),
    CartPage(),
    ProfilePage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (value) {
            setState(() {
              selectedIndex = value;
            });
          },
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey.shade400,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_shipping_outlined),
              label: 'Đơn hàng',
            ),
            BottomNavigationBarItem(
              icon: Consumer<CartProvider>(
                builder: (context, value, child) {
                  return Badge(
                    label: Text(value.carts.length.toString()),
                    child: Icon(Icons.shopping_cart_outlined),
                    backgroundColor: Colors.green.shade400,
                  );
                },
              ),
              label: 'Giỏ hàng',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: 'Hồ sơ',
            ),
          ],
        ),
      ),

    );
  }
}

/*
This is the home navbar of the app
 */
