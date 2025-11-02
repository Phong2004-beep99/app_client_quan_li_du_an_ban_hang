import 'package:app_client_2/controllers/auth_service.dart';
import 'package:app_client_2/firebase_options.dart';
import 'package:app_client_2/providers/cart_provider.dart';
import 'package:app_client_2/providers/user_provider.dart';
import 'package:app_client_2/views/cart_page.dart';
import 'package:app_client_2/views/checkout_page.dart';
import 'package:app_client_2/views/discount_page.dart';
import 'package:app_client_2/views/home_nav.dart';
import 'package:app_client_2/views/login.dart';
import 'package:app_client_2/views/orders_page.dart';
import 'package:app_client_2/views/signup.dart';
import 'package:app_client_2/views/specific_products.dart';
import 'package:app_client_2/views/update_profile.dart';
import 'package:app_client_2/views/view_product.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';

void main() async {
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
await dotenv.load(fileName: ".env");
  Stripe.publishableKey=dotenv.env["STRIPE_PUBLISH_KEY"]!;
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();
runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) =>  UserProvider(),),
        ChangeNotifierProvider(create: (context) =>  CartProvider(),),
      ],
      child: MaterialApp(
        title: 'eCommerce App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        routes: {
          "/":(context)=> CheckUser(),
          "/login": (context)=> LoginPage(),
          "/home": (context)=> HomeNav(),
          "/signup": (context)=> SingupPage(),
          "/update_profile":(context)=> UpdateProfile(),
          "/discount": (context)=> DiscountPage(),
          "/specific": (context)=> SpecificProducts(),
          "/view_product":(context)=> ViewProduct(),
          "/cart": (context)=> CartPage(),
          "/checkout":(context)=> CheckoutPage(),
          "/orders":(context)=> OrdersPage(),
          "/view_order":(context)=> ViewOrder(),
        },
       
      ),
    );
  }
}


class CheckUser extends StatefulWidget {
  const CheckUser({super.key});

  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {

  @override
  void initState() {
    AuthService().isLoggedIn().then((value) {
      if (value) {
        Navigator.pushReplacementNamed(context, "/home");
      } else {
        Navigator.pushReplacementNamed(context, "/login");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body:  Center(child: CircularProgressIndicator(),),);
  }
}
