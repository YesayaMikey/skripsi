import 'package:app_skripsi/firebase_options.dart';
import 'package:app_skripsi/pages/INPUT/jurnalinput.dart';
import 'package:app_skripsi/pages/INPUT/productinput.dart';
import 'package:app_skripsi/pages/mainpage.dart';
import 'package:app_skripsi/pages/productlist/productlist.dart';
import 'package:app_skripsi/pages/splashScreenPage.dart';
import 'package:app_skripsi/service/login_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: LoginPage(),
      home: FutureBuilder(
          future: FirebaseAuth.instance.authStateChanges().first,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              if (snapshot.hasData) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  Navigator.pushReplacementNamed(context, MainPage.path);
                });
                return SizedBox();
              } else {
                return LoginPage();
              }
            }
          }),
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        // When navigating to the "/second" route, build the SecondScreen widget.
        MainPage.path: (context) => const MainPage(),
        LoginPage.path: (context) => const LoginPage(),
        Productlist.path: (context) => const Productlist(),
        ProductInput.path: (context) => const ProductInput(),
        jurnal.path: (context) => const jurnal(selectProduct: ""),
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key? key,
  }) : super(key: key);
  static String path = "/loginpage";
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController controller = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  bool isLoadingLogin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pempek CHG login Page'),
      ),
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: 20,
              ),
              Text('PCHG Login page'),
              // TextField(
              //   decoration: InputDecoration(
              //       hintText: 'input username', border: OutlineInputBorder()),
              //   controller: controller,
              // ),
              // TextField(
              //   decoration: InputDecoration(
              //     hintText: 'input password',
              //     border: OutlineInputBorder(),
              //   ),
              //   controller: controller2,
              // ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainPage(),
                      ),
                    );

                    Navigator.pushReplacementNamed(context, MainPage.path);
                  },
                  child: Text('login')),

              ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isLoadingLogin = true;
                    });
                    await Loginservice().signInWithGoogle();
                    // debugPrint("user ada ga? ${userCredential.user}");
                    Loginservice().handleSignIn(context);

                    setState(() {
                      isLoadingLogin = false;
                    });

                    // Navigator.pushReplacementNamed(context, MainPage.path);
                  },
                  child: Text('sign in with google')),
              SizedBox(
                height: 20,
              ),
              isLoadingLogin ? CircularProgressIndicator() : SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
