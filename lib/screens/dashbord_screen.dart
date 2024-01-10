import 'dart:ui';
import 'package:apple_shop/bloc/basket/baset_event.dart';
import 'package:apple_shop/bloc/basket/basket_bloc.dart';
import 'package:apple_shop/bloc/category/category_bloc.dart';
import 'package:apple_shop/bloc/home/home_bloc.dart';
import 'package:apple_shop/bloc/home/home_event.dart';
import 'package:apple_shop/colors.dart';
import 'package:apple_shop/di/di.dart';
import 'package:apple_shop/screens/card_screen.dart';
import 'package:apple_shop/screens/category_screen.dart';
import 'package:apple_shop/screens/home_screen.dart';
import 'package:apple_shop/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  int SelectedBottomNavigation = 3;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: IndexedStack(
          index: SelectedBottomNavigation,
          children: getScreens(),
        ),
        bottomNavigationBar: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: BottomNavigationBar(
              onTap: (int index) {
                setState(() {
                  SelectedBottomNavigation = index;
                });
              },
              currentIndex: SelectedBottomNavigation,
              backgroundColor: Colors.transparent,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Color.fromARGB(255, 12, 116, 201),
              selectedLabelStyle: TextStyle(
                fontFamily: 'sb',
                fontSize: 12,
              ),
              unselectedLabelStyle: TextStyle(
                fontFamily: 'sb',
                fontSize: 12,
                color: Colors.black,
              ),
              items: [
                BottomNavigationBarItem(
                  icon: Image.asset('assets/images/icon_profile.png'),
                  activeIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Container(
                      child:
                          Image.asset('assets/images/icon_profile_active.png'),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: CustomColor.blue,
                            blurRadius: 15,
                            spreadRadius: -7,
                            offset: Offset(0, 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                  label: 'حساب کاربری',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset('assets/images/icon_basket.png'),
                  activeIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Container(
                      child:
                          Image.asset('assets/images/icon_basket_active.png'),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: CustomColor.blue,
                            blurRadius: 15,
                            spreadRadius: -7,
                            offset: Offset(0, 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                  label: 'سبد خرید',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset('assets/images/icon_category.png'),
                  activeIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Container(
                      child:
                          Image.asset('assets/images/icon_category_active.png'),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: CustomColor.blue,
                            blurRadius: 15,
                            spreadRadius: -7,
                            offset: Offset(0, 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                  label: 'دسته بندی',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset('assets/images/icon_home.png'),
                  activeIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Container(
                      child: Image.asset('assets/images/icon_home_active.png'),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: CustomColor.blue,
                            blurRadius: 15,
                            spreadRadius: -7,
                            offset: Offset(0, 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                  label: 'خانه',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> getScreens() {
    return <Widget>[
      profileScreen(),
      BlocProvider(
        create: ((context) {
          var bloc = locator.get<BasketBloc>();
          bloc.add(BasketFetchFromHiveEvent());
          return bloc;
        }),
        child: CardScreen(),
      ),
      BlocProvider(
        create: (context) => CategoryBloc(),
        child: CategoryScreen(),
      ),
      BlocProvider(
        create: (context) {
          var bloc = HomeBloc();
          bloc.add(HomeRequestList());
          return bloc;
        },
        child: HomeScreen(),
      ),
    ];
  }
}
