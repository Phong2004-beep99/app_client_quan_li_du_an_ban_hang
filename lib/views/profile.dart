import 'package:app_client_2/controllers/auth_service.dart';
import 'package:app_client_2/providers/cart_provider.dart';
import 'package:app_client_2/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Hồ Sơ",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600),),
      scrolledUnderElevation: 0,
  forceMaterialTransparency: true,),
    body:  Column(children: [
      Consumer<UserProvider>(
        builder: (context, value, child) => 
        Card(
          child: ListTile(
            title: Text(value.name),
          subtitle:  Text(value.email),
          onTap: (){
            Navigator.pushNamed(context,"/update_profile");
          },
          trailing: Icon(Icons.edit_outlined),
          ),
        ),
      ),
      SizedBox(height: 20,),
      ListTile(title: Text("Đơn Hàng"), leading: Icon(Icons.local_shipping_outlined), onTap: (){
        Navigator.pushNamed(context, "/orders");

      },),
      Divider( thickness: 1,  endIndent:  10, indent: 10,),
      ListTile(title: Text("Giảm Giá & Ưu Đãi"), leading: Icon(Icons.discount_outlined), onTap: (){
       Navigator.pushNamed(context, "/discount");
      },),
      Divider( thickness: 1,  endIndent:  10, indent: 10,),
      ListTile(title: Text("Trợ Giúp & Hỗ Trợ"), leading: Icon(Icons.support_agent), onTap: (){
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gửi mail cho chúng tôi tại ecommerce@shop.com")));
      },),
      Divider( thickness: 1,  endIndent:  10, indent: 10,),
      ListTile(title: Text("Đăng Xuất"), leading: Icon(Icons.logout_outlined), onTap: ()async{
       await AuthService().logout();
        Provider.of<UserProvider>(context,listen: false).cancelProvider();
       Navigator.pushNamedAndRemoveUntil(context,"/login", (route)=> true);
      },),
    ],),
    );
  }
}