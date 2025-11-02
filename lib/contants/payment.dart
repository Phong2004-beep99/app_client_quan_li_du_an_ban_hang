
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import  'package:http/http.dart' as http;

Future createPaymentIntent({required String name,
  required String address,

  required String amount}) async{

  final url = Uri.parse('https://api.stripe.com/v1/payment_intents');
  final secretKey=dotenv.env["STRIPE_SECRET_KEY"]!;
  final body={
    'amount': amount,
    'currency': "inr",
    'automatic_payment_methods[enabled]': 'true',
    'description': "Shop Payment",
    'shipping[name]': name,
    'shipping[address][line1]': address,
    'shipping[address][country]': "IN"
  };

  try { // Thêm try-catch để xử lý lỗi mạng hoặc lỗi từ Stripe API
    final response= await http.post(url,
        headers: {
          "Authorization": "Bearer $secretKey", // VẪN SỬ DỤNG SECRET KEY TRONG CLIENT - **CỰC KỲ NGUY HIỂM**
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body
    );

    print(body);

    if(response.statusCode==200){
      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      // **Quan trọng: Trả về jsonResponse thay vì chỉ json, để có toàn bộ response từ Stripe**
      return jsonResponse;
    }
    else{
      print("error in calling payment intent - status code: ${response.statusCode}");
      print("response body: ${response.body}"); // In thêm response body để debug
      return null; // Trả về null khi có lỗi
    }
  } catch (e) {
    print("Exception in createPaymentIntent: $e"); // In lỗi exception nếu có
    return null; // Trả về null khi có exception
  }
}