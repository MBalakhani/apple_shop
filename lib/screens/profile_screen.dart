import 'package:apple_shop/colors.dart';
import 'package:apple_shop/screens/login_screen.dart';
import 'package:apple_shop/util/auth_manager.dart';
import 'package:flutter/material.dart';

class profileScreen extends StatelessWidget {
  const profileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEEEEEE),
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              Padding(
                padding:
                    EdgeInsets.only(top: 10, left: 44, right: 44, bottom: 32),
                child: Container(
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'حساب کاربری',
                            style: TextStyle(
                              fontFamily: 'SM',
                              fontSize: 16,
                              color: CustomColor.blue,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Image.asset('assets/images/icon_apple_blue.png'),
                      ],
                    ),
                  ),
                ),
              ),
              Text(
                'محمد بالاخانی',
                style: TextStyle(
                  fontFamily: 'Sb',
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 5),
              Text(
                '09109744498',
                style: TextStyle(
                  fontFamily: 'sm',
                  fontSize: 10,
                ),
              ),
              SizedBox(height: 30),
              Wrap(
                spacing: 30,
                runSpacing: 30,
                children: [
                  // Categoryitem(),
                  // Categoryitem(),
                  // Categoryitem(),
                  // Categoryitem(),
                  // Categoryitem(),
                  // Categoryitem(),
                  // Categoryitem(),
                  // Categoryitem(),
                  // Categoryitem(),
                  // Categoryitem(),
                ],
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  AuthManager.logout();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return LoginScreen();
                      },
                    ),
                  );
                },
                child: Text(
                  'خروج از حساب کاربری',
                  style: TextStyle(fontFamily: 'dana', color: Colors.red),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'اپل شاپ',
                style: TextStyle(
                  fontFamily: 'sm',
                  fontSize: 10,
                  color: CustomColor.grey,
                ),
              ),
              Text(
                'v-1.0.00',
                style: TextStyle(
                  fontFamily: 'sm',
                  fontSize: 10,
                  color: CustomColor.grey,
                ),
              ),
              Text(
                'instagram.com/MBalakhani',
                style: TextStyle(
                  fontFamily: 'sm',
                  fontSize: 10,
                  color: CustomColor.grey,
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class Categoryitem extends StatelessWidget {
  const Categoryitem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 56,
              width: 56,
              decoration: ShapeDecoration(
                  color: Colors.green,
                  shadows: [
                    BoxShadow(
                      color: Colors.green,
                      blurRadius: 30,
                      spreadRadius: -10,
                      offset: Offset(0, 15),
                    )
                  ],
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  )),
            ),
            Icon(
              Icons.mouse,
              color: Colors.white,
              size: 30,
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'همه',
          style: TextStyle(
            fontFamily: 'SB',
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
