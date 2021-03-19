import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gur/Utils/SizeConfig.dart';
import 'package:gur/screens/mainScreens/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gur/screens/mainScreens/home.dart';
import 'Utils/constants.dart';
import 'package:flutter/services.dart';
import 'screens/mainScreens/aboutNgo.dart';
import 'screens/authScreens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences pref = await SharedPreferences.getInstance();
  bool isLoggedIn;
  await Firebase.initializeApp();
  FirebaseAuth auth = FirebaseAuth.instance;
  User user = auth.currentUser;
  SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent);

  if (user == null)
    isLoggedIn = false;
  else
    isLoggedIn = true;

  pref.setBool('isLoggedIn', isLoggedIn);

  runApp(MyApp(isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  MyApp(this.isLoggedIn);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DSC Challenge',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: isLoggedIn == true ? Home() : Login(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

int _selectedIndex = 0;

List<Widget> _widgetOptions = <Widget>[
  HomePage(),
  AboutNgo(),
  AboutNgo(),
  Profile()
];

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    //var h = SizeConfig.screenHeight / 896;
    //var b = SizeConfig.screenWidth / 412;

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: mc,
          elevation: 10,
          selectedFontSize: SizeConfig.screenWidth * 14 / 414,
          unselectedFontSize: SizeConfig.screenWidth * 12 / 414,
          unselectedItemColor: Color(0xff130f26),
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
        body: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }
}
