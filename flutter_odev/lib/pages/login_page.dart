import 'package:flutter/material.dart';
import 'package:flutter_odev/bases/user_base.dart';
import 'package:flutter_odev/common/already_have_an_account_acheck.dart';
import 'package:flutter_odev/common/custom_alert_dialog.dart';
import 'package:flutter_odev/common/custom_button.dart';
import 'package:flutter_odev/common/loading_page.dart';
import 'package:flutter_odev/services/auth_service.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'home_page.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  AuthService _authService=AuthService();
  User? _user;

  final _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  late String _username, _password;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return _isLoading==false
        ? Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 38.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Giriş Yapın",
                          style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: size.height * 0.05),
                        SvgPicture.asset(
                          "images/login.svg",
                          height: size.height * 0.3,
                        ),
                        SizedBox(height: size.height * 0.08),
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
                              if (value!.isEmpty) {
                                return "Kullanıcı adınızı girin";
                              } else if (value.length < 4) {
                                return "Kullanıcı adı çok kısa";
                              }
                                return null;
                            },
                            onSaved: (inputMail) {
                              _username = inputMail!;
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
                                Icons.mail,
                                color: Colors.white,
                              ),
                              hintText: "Kullanıcı Adınız",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 7),
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
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Şifrenizi girin";
                              } else {
                                if (value.length < 4) {
                                  return "Şifre çok kısa";
                                } else {
                                  return null;
                                }
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
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30,20,30,10),
                          child: CustomButton(
                            onPressed: () => _formSubmit(),
                            buttonText: "Giriş Yap",
                          ),
                        ),
                        SizedBox(height: size.height * 0.03),
                        AlreadyHaveAnAccountCheck(
                          isLoginPage: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        : LoadingPage();
  }

  _formSubmit() async {
    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();
      setState(() {
        _isLoading=true;
      });
      _user=await _authService.login(_username, _password);
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
          "Hatalı şifre veya kullanıcı adı tekrar deneyin",
          AlertType.error,
        );
      }
    }
  }
}
