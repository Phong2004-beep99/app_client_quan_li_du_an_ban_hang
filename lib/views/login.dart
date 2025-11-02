import 'package:app_client_2/controllers/auth_service.dart';
import 'package:app_client_2/controllers/db_service.dart';
import 'package:app_client_2/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(children: [
            SizedBox(
              height: 120,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Đăng nhập",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
                  ),
                  Text("Bắt đầu với tài khoản của bạn"),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * .9,
                      child: TextFormField(
                        validator: (value) =>
                            value!.isEmpty ? "Email không được để trống." : null,
                        controller: _emailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text("Email"),
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width * .9,
                child: TextFormField(
                  validator: (value) => value!.length < 8
                      ? "Mật khẩu phải có ít nhất 8 ký tự."
                      : null,
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Mật khẩu"),
                  ),
                )),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (builder) {
                            return AlertDialog(
                                title: Text("Quên mật khẩu"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Nhập email của bạn"),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      controller: _emailController,
                                      decoration: InputDecoration(
                                          label: Text("Email"),
                                          border: OutlineInputBorder()),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Hủy")),
                                  TextButton(
                                      onPressed: () async {
                                        if (_emailController.text.isEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "Email không được để trống")));
                                          return;
                                        }
                                        await AuthService()
                                            .resetPassword(
                                                _emailController.text)
                                            .then((value) {
                                          if (value == "Mail Sent") {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        "Liên kết đặt lại mật khẩu đã được gửi đến email của bạn")));
                                            Navigator.pop(context);
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                value,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              backgroundColor:
                                                  Colors.red.shade400,
                                            ));
                                          }
                                        });
                                      },
                                      child: Text("Gửi")),
                                ]);
                          });
                    },
                    child: Text("Quên mật khẩu")),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width * .9,
                child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        AuthService()
                            .loginWithEmail(
                                _emailController.text, _passwordController.text)
                            .then((value) async {
                          if (value == "Login Successful") {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Đăng nhập thành công")));
                            Provider.of<UserProvider>(context, listen: false).loadUserData();
                            final userEmail = FirebaseAuth.instance.currentUser?.email;
                              if (userEmail != null) {
                                final userData = await DbService().getUserDataByEmail(userEmail);
                                if (userData != null) {
                                  // Cập nhật UserProvider
                                  Provider.of<UserProvider>(context, listen: false).setUser(
                                    name: userData['name'],
                                    email: userData['email'],
                                  );
                                }
                              }
                              Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                value,
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.red.shade400,
                            ));
                          }
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white),
                    child: Text(
                      "Đăng nhập",
                      style: TextStyle(fontSize: 16),
                    ))),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Chưa có tài khoản?"),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/signup");
                    },
                    child: Text("Đăng ký"))
              ],
            )
          ]),
        ),
      ),
    );
  }
}