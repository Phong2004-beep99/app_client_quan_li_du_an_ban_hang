import 'package:app_client_2/contants/payment.dart';
import 'package:app_client_2/controllers/db_service.dart';
import 'package:app_client_2/controllers/mail_service.dart';
import 'package:app_client_2/models/orders_model.dart';
import 'package:app_client_2/providers/cart_provider.dart';
import 'package:app_client_2/providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  TextEditingController _couponController = TextEditingController();

  int discount = 0;
  int toPay = 0;
  String discountText = "";

  bool paymentSuccess=false;
  Map<String,dynamic> dataOfOrder={};

    discountCalculator(int disPercent, int totalCost) {
    discount = (disPercent * totalCost) ~/ 100;
  setState(() {});
  }

  Future<void> initPaymentSheet(int cost) async {
    try {
      final user = Provider.of<UserProvider>(context, listen: false);
      // 1. create payment intent on the server
      final data = await createPaymentIntent(name: user.name,address: user.address,
      amount:  (cost*100).toString());
      print("Data from createPaymentIntent: $data"); // Đã thêm ở bước 1

      // 2. initialize the payment sheet
     await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Set to true for custom flow
          customFlow: false,
          // Main params
          merchantDisplayName: 'Flutter Stripe Store Demo',
          paymentIntentClientSecret: data['client_secret'],
          // Customer keys
          customerEphemeralKeySecret: data['ephemeralKey'],
          customerId: data['id'],
          // Extra options
          style: ThemeMode.dark,
        ),
      );
     
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
      rethrow;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Thanh toán",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        scrolledUnderElevation: 0,
        forceMaterialTransparency: true,
      ),
      body: SingleChildScrollView(
        child: Consumer<UserProvider>(
          builder: (context, userData, child) => Consumer<CartProvider>(
            builder: (context, cartData, child) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Chi tiết giao hàng",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    Container(
                       padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(children: [
                         SizedBox(
                           width: MediaQuery.of(context).size.width * .65,
                           child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text(userData.name,style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),),
                           Text(userData.email),       
                           Text(userData.address),       
                           Text(userData.phone),       
                             ],
                           ),
                         ),
                         Spacer(),
                         IconButton(onPressed: (){
                          Navigator.pushNamed(context,"/update_profile");
                         }, icon: Icon(Icons.edit_outlined))   
                              ],),
                    ),
                       SizedBox(
                          height: 20,
                        ),
                        Text("Có mã giảm giá?"),
                         Row(
                          children: [
                            SizedBox(
                              width: 200,
                              child: TextFormField(
                                textCapitalization: TextCapitalization
                                    .characters, // capitalize first letter of each word
                                controller: _couponController,
                                decoration: InputDecoration(
                                  labelText: "Mã giảm giá",
                                  hintText: "Nhập mã giảm giá để được giảm thêm",
                                  border: InputBorder.none,
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                ),
                              ),
                            ),
                            TextButton(
                                onPressed: () async {
                                  QuerySnapshot querySnapshot =
                                      await DbService().verifyDiscount(
                                          code: _couponController.text
                                              .toUpperCase());

                                  if (querySnapshot.docs.isNotEmpty) {
                                    QueryDocumentSnapshot doc =
                                        querySnapshot.docs.first;
                                    String code = doc.get('code');
                                    int percent = doc.get('discount');

                                    // access other fields as needed
                                    print('Mã giảm giá: $code');
                                    discountText =
                                        "đã áp dụng giảm giá $percent%.";
                                    discountCalculator(
                                        percent, cartData.totalCost);
                                  } else {
                                    print('Không tìm thấy mã giảm giá');
                                    discountText = "Không tìm thấy mã giảm giá";
                                  }
                                  setState(() {});
                                },
                                child: Text("Áp dụng"))
                          ],
                        ),
                          SizedBox(
                          height: 8,
                        ),
                        discountText == "" ? Container() : Text(discountText),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(),
                        SizedBox(
                          height: 10,
                        ),
                          Text(
                          "Tổng số lượng sản phẩm: ${cartData.totalQuantity}",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "Tổng phụ: ${cartData.totalCost}đ",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Divider(),
                        Text(
                          "Giảm giá thêm: -  $discountđ",
                          style: TextStyle(fontSize: 16),
                        ),
                        Divider(),
                        Text(
                          "Tổng thanh toán: ${cartData.totalCost - discount}đ",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                     
                  ],
                ),
              );
            },
          ),
        ),
        
      ),
      bottomNavigationBar: Container(
         height: 60,
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(child: Text("Tiến hành thanh toán"), onPressed: ()async{
          final user = Provider.of<UserProvider>(context, listen: false);
            if (user.address == "" ||
                user.phone == "" ||
                user.name == "" ||
                user.email == "") {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Vui lòng điền thông tin giao hàng của bạn.")));
              return;
            }

            await initPaymentSheet(
                Provider.of<CartProvider>(context, listen: false).totalCost -
                    discount);

try{
  await Stripe.instance.presentPaymentSheet();

  final cart = Provider.of<CartProvider>(context, listen: false);

              User? currentUser = FirebaseAuth.instance.currentUser;
              List products = [];

              for (int i = 0; i < cart.products.length; i++) {
                products.add({
                  "id": cart.products[i].id,
                  "name": cart.products[i].name,
                  "image": cart.products[i].image,
                  "single_price": cart.products[i].new_price,
                  "total_price":
                      cart.products[i].new_price * cart.carts[i].quantity,
                  "quantity": cart.carts[i].quantity
                });
              }

              // ORDER STATUS
              // PAID - paid money by user
              // SHIPPED - item shipped
              // CANCELLED - item cancelled
              // DELIVERED - order delivered

              Map<String, dynamic> orderData = {
                "user_id": currentUser!.uid,
                "name": user.name,
                "email": user.email,
                "address": user.address,
                "phone": user.phone,
                "discount": discount,
                "total": cart.totalCost - discount,
                "products": products,
                "status": "PAID",
                "created_at": DateTime.now().millisecondsSinceEpoch
              };

  dataOfOrder=orderData;


  // creating new order
 await DbService().createOrder(data: orderData);

//  reduce the quantity of product on firestore
   for (int i = 0; i < cart.products.length; i++) {
    DbService().reduceQuantity(productId: cart.products[i].id, quantity: cart.carts[i].quantity);
   }

  // clear the cart for the user
 await DbService().emptyCart();

  paymentSuccess=true;

//  close the checkout page
Navigator.pop(context);

     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  "Thanh toán thành công",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.green,
              ));

}catch(e){
     print("payment sheet error : $e");
              print("payment sheet failed");
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  "Thanh toán thất bại",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.redAccent,
              ));
}

if(paymentSuccess){
  MailService().sendMailFromGmail(user.email, OrdersModel.fromJson(dataOfOrder, ""));
}


        },style: ElevatedButton.styleFrom(backgroundColor: Colors.blue,foregroundColor: Colors.white),),
      ),
    );
  }
}
