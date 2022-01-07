import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_odev/bases/user_base.dart';
import 'package:flutter_odev/common/already_have_an_account_acheck.dart';
import 'package:flutter_odev/common/custom_alert_dialog.dart';
import 'package:flutter_odev/common/custom_button.dart';
import 'package:flutter_odev/common/loading_page.dart';
import 'package:flutter_odev/pages/home_page.dart';
import 'package:flutter_odev/services/auth_service.dart';
import 'package:flutter_odev/services/storage_service.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  User? _user;
  AuthService _authService = AuthService();
  bool _isLoading = false;
  File? image;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();
  late String _username, _password, _passwordConfirm;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return _isLoading == false
        ? Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                  child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    SizedBox(height: size.height * 0.05),
                    Text(
                      "Kaydolun",
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () async {
                          return showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.19,
                                  child: Column(
                                    children: <Widget>[
                                      ListTile(
                                        leading: Icon(
                                          Icons.camera_alt,
                                        ),
                                        title: Text("Kameradan Çek"),
                                        onTap: () {
                                          _takePicFromCamera();
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.image),
                                        title: Text("Galeriden Seç"),
                                        onTap: () {
                                          _chooseFromGallery();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              });
                        },
                        child: image != null
                            ? CircleAvatar(
                                backgroundColor: Colors.black,
                                radius: size.width * 0.205,
                                child: CircleAvatar(
                                  radius:
                                      MediaQuery.of(context).size.width * 0.2,
                                  backgroundImage: FileImage(
                                    image!,
                                  ),
                                ),
                              )
                            : SvgPicture.asset(
                                "images/pic.svg",
                                height: size.height * 0.2,
                              ),
                      ),
                    ),
                    image != null
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Profil Resminiz",
                              style: TextStyle(fontSize: 18),
                            ),
                          )
                        : SizedBox(),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(29),
                      ),
                      child: TextFormField(
                        controller: _usernameController,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 4) {
                            return "Kullanıcı adı girin";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (inputName) {
                          _username = inputName!;
                        },
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 2.5),
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          errorStyle: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                          icon: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          hintText: "Kullanıcı Adınız",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(29),
                      ),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 4) {
                            return "Şifrenizi girin";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (inputPass) {
                          _password = inputPass!;
                        },
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 2.5),
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          errorStyle: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                          icon: Icon(
                            Icons.lock,
                            color: Colors.white,
                          ),
                          hintText: "Şifreniz",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(29),
                      ),
                      child: TextFormField(
                        controller: _passwordConfirmController,
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Şifrenizi tekrar girin";
                          } else {
                            if (value.length >= 4) {
                              if (value == _passwordController.text) {
                                return null;
                              } else {
                                return "Şifreler uyuşmuyor";
                              }
                            } else {
                              return "Şifreniz çok kısa";
                            }
                          }
                        },
                        onSaved: (inputPass) {
                          _passwordConfirm = inputPass!;
                        },
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 2.5),
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          errorStyle: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                          icon: Icon(
                            Icons.lock,
                            color: Colors.white,
                          ),
                          hintText: "Şifrenizi Tekrar Girin",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
                      child: CustomButton(
                        onPressed: () => _formSubmit(),
                        buttonText: "Kaydol",
                      ),
                    ),
                    SizedBox(height: size.height * 0.015),
                    AlreadyHaveAnAccountCheck(
                      isLoginPage: false,
                    ),
                  ],
                ),
              )),
            ),
          )
        : LoadingPage();
  }

  _formSubmit() async {
    if (image == null) {
      await customAlertDialog(context, "Resim Yok!",
          "Profil resminiz olmadan kayıt olamazsınız", AlertType.error);
    } else {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        setState(() {
          _isLoading = true;
        });
        _user = await _authService.signUp(_username, _password, image!);
        if (_user != null) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomePage()),
              (Route<dynamic> route) => false);
        } else {
          setState(() {
            _isLoading = false;
          });
          await customAlertDialog(
            context,
            "HATA!",
            "Bu kullanıcı adı sistemimizde mevcut başka kullacı adı girin veya giriş yapın",
            AlertType.error,
          );
        }
      }
    }
  }

  void _takePicFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final newImage =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 30);
    setState(() {
      image = File(newImage!.path);
    });
    Navigator.pop(context);
  }

  void _chooseFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final newImage =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 30);
    setState(() {
      image = File(newImage!.path);
    });
    Navigator.pop(context);
  }
}
