import 'package:app_skripsi/main.dart';
import 'package:app_skripsi/pages/INPUT/productinput.dart';
import 'package:app_skripsi/pages/Pperform.dart';
import 'package:app_skripsi/pages/productlist/productlist.dart';
import 'package:app_skripsi/service/login_service.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  static String path = "/mainpage";

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // @override
  // void initState() {
  //   final logoutLogInService = Loginservice();
  //   logoutLogInService.checkUserStatus(context);
  //   // TODO: implement initState
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(200, 20),
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  //to set border radius to button
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, ProductInput.path);
              },
              child: const Text('Product Input'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(200, 20),
                backgroundColor: Color.fromARGB(255, 255, 128, 0),
                shape: RoundedRectangleBorder(
                  //to set border radius to button
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, Pperform.path);
              },
              child: const Text('Product Performance'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(200, 20),
                backgroundColor: Color.fromARGB(255, 255, 98, 0),
                shape: RoundedRectangleBorder(
                  //to set border radius to button
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, Productlist.path);
              },
              child: const Text('Product List'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(200, 20),
                backgroundColor: Color.fromARGB(255, 255, 98, 0),
                shape: RoundedRectangleBorder(
                  //to set border radius to button
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () async {
                final logoutLogInService = Loginservice();
                await logoutLogInService.handleSignOutGoogle(context);
              },
              child: const Text('log out'),
            ),
          ],
        ),
      ),
    );
  }
}
