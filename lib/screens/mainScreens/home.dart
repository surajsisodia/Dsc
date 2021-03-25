import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gur/dialogboxes/dialogBoxSearch.dart';
import 'package:gur/dialogboxes/dialogBoxDonate.dart';
import 'package:gur/drawer.dart';
import 'package:gur/screens/chatSection/messageScreen.dart';
import 'package:gur/screens/mainScreens/aboutNgo.dart';
import 'package:location/location.dart';
import '../../Utils/SizeConfig.dart';
import '../../Utils/constants.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var b = SizeConfig.screenWidth / 414;
    var h = SizeConfig.screenHeight / 896;
    bool isSearch = false;
    List headingItems = [
      'User Summary',
      'User Summary',
      'Global Summary',
      'Global Summary'
    ];
    List images = [
      'images/2.png',
      'images/3.png',
      'images/4.png',
      'images/5.png',
      'images/6.png',
      'images/7.png',
      'images/8.png',
      'images/9.png',
      'images/2.png',
      'images/3.png',
      'images/4.png',
      'images/5.png',
      'images/6.png',
      'images/7.png',
      'images/8.png',
      'images/9.png',
    ];

    List midItems = [
      'Amount Donated',
      'No. of times donated',
      'Total amount donated',
      'Total donations'
    ];
    List summaryItems = ['140 Kg', '7', '2000 Kg', '1900'];
    List quoteItems = [
      'Remember that the happiest people are not those getting more, but those giving more.',
      'Since you get more joy out of giving joy to others, you should put a good deal of thought into the happiness that you are able to give.',
      'We must give more in order to get more. It is the generous giving of ourselves that produces the generous harvest.',
      'We make a living by what we get. We make a life by what we give.',
      'No one is useless in this world who lightens the burdens of another.',
      'It is every man’s obligation to put back into the world at least the equivalent of what he takes out of it.',
      'The meaning of life is to find your gift. The purpose of life is to give it away.',
      'I have found that among its other benefits, giving liberates the soul of the giver.'
    ];

    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerCode(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(children: [
          Column(children: [
            Container(
              height: h * 60,
              padding: EdgeInsets.symmetric(horizontal: b * 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: b * 4,
                    spreadRadius: 0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Builder(
                    builder: (BuildContext context) {
                      return InkWell(
                        onTap: () {
                          _scaffoldKey.currentState.openDrawer();
                        },
                        child: Container(
                          height: h * 30,
                          width: b * 30,
                          child: SvgPicture.asset(
                            'images/Chart.svg',
                            allowDrawingOutsideViewBox: true,
                            width: h * 20,
                            height: b * 20,
                          ),
                        ),
                      );
                    },
                  ),
                  Spacer(),
                  Text(
                    'Home',
                    style: txtS(mc, 20, FontWeight.w600),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return MessageScreen(
                            FirebaseAuth.instance.currentUser.uid);
                      }));
                    },
                    child: Container(
                      height: h * 30,
                      width: b * 30,
                      child: SvgPicture.asset(
                        'images/SendColor.svg',
                        allowDrawingOutsideViewBox: true,
                        width: h * 20,
                        height: b * 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(physics: BouncingScrollPhysics(), children: [
                sh(20),
                InkWell(
                  onTap: () {
                    setState(() {
                      dialogBoxSearch(context);
                      isSearch = !isSearch;
                      print('serach');
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: b * 20),
                    padding: EdgeInsets.symmetric(vertical: h * 12),
                    decoration: BoxDecoration(
                      color: Color(0xfff0f0f0),
                      borderRadius: BorderRadius.circular(b * 49),
                    ),
                    child: Image.asset('images/search.png', width: b * 133),
                  ),
                ),
                sh(20),
                Container(
                  width: b * 375,
                  height: h * 140,
                  margin: EdgeInsets.only(left: b * 10),
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: images.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return Container(
                        width: b * 170,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                            image: AssetImage(images[index]),
                            fit: BoxFit.fill,
                          ),
                          borderRadius: BorderRadius.circular(b * 6),
                        ),
                      );
                    },
                  ),
                ),
                sh(24),
                Container(
                  width: b * 375,
                  height: h * 90,
                  padding: EdgeInsets.only(left: b * 13.5),
                  color: Color(0xfffff2e1),
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: 4,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: b * 6.5, vertical: h * 11),
                        padding: EdgeInsets.symmetric(horizontal: b * 10),
                        width: b * 168,
                        height: h * 122,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Color(0xffffddb1),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(b * 6),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              headingItems[index],
                              style: txtS(textColor, 14, FontWeight.w600),
                            ),
                            Text(
                              midItems[index],
                              style:
                                  txtS(Color(0xff28797c), 10, FontWeight.w400),
                            ),
                            Text(
                              summaryItems[index],
                              style: txtS(mc, 14, FontWeight.w400),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                sh(20),
                CarouselSlider(
                  options: CarouselOptions(
                    viewportFraction: 0.8,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                    height: h * 130,
                    autoPlay: true,
                  ),
                  items: quoteItems.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(vertical: h * 10),
                          padding: EdgeInsets.symmetric(horizontal: b * 40),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Text(
                            '$i',
                            textAlign: TextAlign.center,
                            style: txtS(textColor, 14, FontWeight.w500),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                sh(10),
                Padding(
                  padding: EdgeInsets.only(left: b * 20),
                  child: Text(
                    'NGOs Near Me',
                    style: txtS(textColor, 16, FontWeight.w600),
                  ),
                ),
                sh(2),
                Container(
                  width: b * 375,
                  margin: EdgeInsets.only(left: b * 13.5),
                  height: h * 120,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: 15,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              return AboutNgo();
                            }),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: b * 6.5, vertical: h * 9),
                          width: b * 102,
                          height: h * 101,
                          decoration: BoxDecoration(
                            color: gc,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                offset: Offset(0, 0),
                              ),
                            ],
                            image: DecorationImage(
                              image: AssetImage('images/ill1.png'),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(b * 6),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                sh(20),
                InkWell(
                  onTap: () {
                    dialogBoxDonate(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: b * 20, right: b * 20),
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                      vertical: h * 15,
                    ),
                    width: b * 374,
                    decoration: BoxDecoration(
                      color: mc,
                      boxShadow: [
                        BoxShadow(
                          color: mc.withOpacity(0.2),
                          blurRadius: 8,
                          spreadRadius: 2,
                          offset: Offset(0, 4),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(b * 46),
                    ),
                    child: Text(
                      'Donate',
                      style: txtS(Colors.white, 16, FontWeight.w700),
                    ),
                  ),
                ),
                sh(140),
              ]),
            ),
          ]),
        ]),
      ),
    );
  }

  void dialogBoxContact(BuildContext context) {
    var b = SizeConfig.screenWidth / 414;
    var h = SizeConfig.screenHeight / 896;

    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding:
              EdgeInsets.only(top: h * 0, left: b * 20, right: b * 20),
          child: Container(
            height: h * 335,
            decoration: BoxDecoration(
              color: Color(0xfff1f1f1),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(b * 30),
                topLeft: Radius.circular(b * 30),
                topRight: Radius.circular(b * 30),
              ),
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: EdgeInsets.fromLTRB(b * 25, h * 27, b * 60, h * 19),
                child: Text(
                  'You Have accepted request from Person',
                  style: txtS(textColor, 20, FontWeight.w500),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(b * 25, h * 0, b * 0, h * 37),
                child: Text(
                  'Share your Contact',
                  style: txtS(textColor, 14, FontWeight.w700),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: b * 25),
                padding: EdgeInsets.symmetric(horizontal: b * 16),
                height: h * 40,
                width: 212 * b,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(b * 10),
                ),
                child: TextField(
                  // controller: titleController,
                  style: txtS(textColor, 15, FontWeight.w500),
                  decoration: dec('Name'),
                ),
              ),
              sh(17),
              Container(
                margin: EdgeInsets.only(left: b * 25),
                padding: EdgeInsets.symmetric(horizontal: b * 16),
                height: h * 40,
                width: 212 * b,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(b * 10),
                ),
                child: TextField(
                  keyboardType: TextInputType.number,
                  // controller: titleController,
                  style: txtS(textColor, 15, FontWeight.w500),
                  decoration: dec('Phone Number'),
                ),
              ),
              sh(28),
              InkWell(
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: b * 25),
                  height: h * 40,
                  width: 212 * b,
                  decoration: BoxDecoration(
                    color: mc,
                    borderRadius: BorderRadius.circular(b * 10),
                  ),
                  child: Text(
                    'Send',
                    style: txtS(Colors.white, 14, FontWeight.w500),
                  ),
                ),
              ),
            ]),
          ),
        );
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      curve: Curves.fastOutSlowIn,
      duration: Duration(milliseconds: 250),
    );
  }

  InputDecoration dec(String txt) {
    return InputDecoration(
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      hintText: txt,
      hintStyle: TextStyle(
        color: Color(0xffb9b9b9),
        fontSize: SizeConfig.screenWidth * 14 / 412,
        fontWeight: FontWeight.w400,
      ),
      isDense: true,
      contentPadding:
          EdgeInsets.symmetric(vertical: SizeConfig.screenHeight * 11 / 896),
    );
  }

  SizedBox sh(double h) {
    return SizedBox(height: SizeConfig.screenHeight * h / 896);
  }

  TextStyle txtS(Color col, double siz, FontWeight wg) {
    return TextStyle(
      color: col,
      fontWeight: wg,
      fontSize: SizeConfig.screenWidth * siz / 414,
    );
  }
}
