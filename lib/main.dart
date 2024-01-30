import 'package:apple_shop/data/model/card_item.dart';
import 'package:apple_shop/di/di.dart';
import 'package:apple_shop/screens/dashbord_screen.dart';
import 'package:apple_shop/screens/login_screen.dart';
import 'package:apple_shop/util/auth_manager.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(BasketItemAdapter());
  await Hive.openBox<BasketItem>('CardBox');
  await getItInit();
  runApp(const Aplication());
}

class Aplication extends StatefulWidget {
  const Aplication({super.key});

  @override
  State<Aplication> createState() => _AplicationState();
}

class _AplicationState extends State<Aplication> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: globalNavigatorKey,
      home:
          (AuthManager.ReadAuth().isEmpty) ? LoginScreen() : DashBoardScreen(),
    );
  }
}
