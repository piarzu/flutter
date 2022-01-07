import 'package:flutter/material.dart';
import 'package:flutter_odev/pages/register_page.dart';


class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool isLoginPage;
   AlreadyHaveAnAccountCheck({
    Key? key,
    required this.isLoginPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          isLoginPage ? "Hesabınız Yok Mu? " : "Hesabınız Var Mı? ",
          style: TextStyle(color: Colors.black87,fontSize: 15),
        ),
        GestureDetector(
          onTap: isLoginPage?()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterPage())):()=>Navigator.pop(context),
          child: Text(
            isLoginPage ? "  Kayıt Olun" : " Giriş Yapın",
            style: TextStyle(
              color: Colors.blue.shade600,
              fontWeight: FontWeight.bold,
              fontSize: 17
            ),
          ),
        )
      ],
    );
  }
}
