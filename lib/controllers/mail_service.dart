import 'package:app_client_2/models/orders_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class MailService{

  // creating smtp server for gmail
   final gmailSmtp = gmail(dotenv.env["GMAIL_MAIL"]!, dotenv.env["GMAIL_PASSWORD"]!);
// send mail to the user using smtp
  sendMailFromGmail(String receiver, OrdersModel order) async {
   final message = Message()
    ..from = Address(dotenv.env["GMAIL_MAIL"]!, 'Không trả lời')
    ..recipients.add(receiver)
    ..subject = 'Hóa đơn đặt hàng'
    ..html = """
<body style=" font-family: Verdana, Geneva, Tahoma, sans-serif">
   <h1 style="text-align: center;">Hóa đơn đặt hàng</h1>

   <table style="width: 100%; border-collapse: collapse; font-family: Arial, sans-serif; margin:   10px auto; max-width: 1000px;">
      <thead>
        <tr style="background-color: #f2f2f2; color: #333; text-align: left;">
           <th style="padding: 8px; border-bottom: 2px solid #ddd;">Hình ảnh</th>
           <th style="padding: 8px; border-bottom: 2px solid #ddd;">Sản phẩm</th>
           <th style="padding: 8px; border-bottom: 2px solid #ddd;">Giá</th>
           <th style="padding: 8px; border-bottom: 2px solid #ddd;">Số lượng</th>
           <th style="padding: 8px; border-bottom: 2px solid #ddd;">Tổng cộng</th>
        </tr>
      </thead>

      <tbody>
      ${order.products.map((product) => """
<tr style="border-bottom: 1px solid #ddd; padding:  8px;">
           <td> <img src="${product.image}" alt="" style="width: 100px;"></td>
           <td style="padding: 8px;">${product.name}</td>
           <td style="padding: 8px;">${product.single_price}đ</td>
           <td style="padding: 8px;">${product.quantity}</td>
           <td style="padding: 8px;">${product.total_price}đ</td>
        </tr>
""").join("")}
   </tbody>
    
   </table>
   
   <br>

   <!-- discount and total will be in center -->
    <div class="total" style="width: 100%;   margin:   10px auto; max-width: 1000px;">
      <!-- <hr> -->

      <p style="text-align: right;  font-size: 16px; font-weight: 400;">Giảm giá: - ${order.discount}đ</p>
      <p style="text-align: right;  font-size: 20px; font-weight: 800;">Tổng cộng: ${order.total}đ</p>
    </div>
   <p style="text-align: center; font-size: 14px; color: #666;">Cảm ơn bạn đã mua sắm với chúng tôi!</p>
</body>
""";

   try {
    final sendReport = await send(message, gmailSmtp);
    print('Message sent: $sendReport');
   } on MailerException catch (e) {
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
   }
  }
}
