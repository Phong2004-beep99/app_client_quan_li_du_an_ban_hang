import 'package:app_client_2/controllers/db_service.dart';
import 'package:app_client_2/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    final user=Provider.of<UserProvider>(context,listen: false);
    _nameController.text = user.name;
    _emailController.text = user.email;
    _addressController.text = user.address;
    _phoneController.text = user.phone;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cập nhật hồ sơ"),
          scrolledUnderElevation: 0,
  forceMaterialTransparency: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key:  formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      labelText: "Tên",
                      hintText: "Tên",
                      border: OutlineInputBorder()),
                  validator: (value) =>
                      value!.isEmpty ? "Tên không được để trống." : null,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _emailController,
                  readOnly: true,
                  decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "Email",
                      border: OutlineInputBorder()),
                  validator: (value) =>
                      value!.isEmpty ? "Email không được để trống." : null,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  maxLines: 3,
                  controller: _addressController,
                  decoration: InputDecoration(
                      labelText: "Địa chỉ",
                      hintText: "Địa chỉ",
                      border: OutlineInputBorder()),
                  validator: (value) =>
                      value!.isEmpty ? "Địa chỉ không được để trống." : null,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                      labelText: "Số điện thoại",
                      hintText: "Số điện thoại",
                      border: OutlineInputBorder()),
                  validator: (value) =>
                      value!.isEmpty ? "Số điện thoại không được để trống." : null,
                ),
                SizedBox(height: 10,),
                 SizedBox(
                    height: 60,
                    width: MediaQuery.of(context).size.width * .9,
                    child: ElevatedButton(
                      
                      
                        onPressed: ()async {
                          if(formKey.currentState!.validate()){
                            var data={
                              "name":_nameController.text,
                              "email":_emailController.text,
                              "address":_addressController.text,
                              "phone":_phoneController.text
                            };
await DbService().updateUserData(extraData: data);
Navigator.pop(context);
ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hồ sơ đã được cập nhật")));

                          }
                          
                        },
                        style:  ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white
                        ),
                        child: Text(
                          "Cập nhật hồ sơ",
                          style: TextStyle(fontSize: 16),
                        ))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
