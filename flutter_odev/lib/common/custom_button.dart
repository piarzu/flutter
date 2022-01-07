import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  final Color textColor;
  final double radius;
  final double height;
  final double width;
  final Widget? buttonIcon;
  final VoidCallback onPressed;

  const CustomButton(
      {Key? key,
        required this.buttonText,
        this.buttonColor: Colors.blue,
        this.textColor: Colors.white,
        this.radius: 15,
        this.height:50,
        this.width:200,
        required this.onPressed,
        this.buttonIcon,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: SizedBox(
        height: height,
        child: RaisedButton(
          onPressed: onPressed,
          color: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(radius),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              buttonIcon!=null?buttonIcon!:SizedBox(),
              Text(
                buttonText,
                style: TextStyle(color: textColor),
              ),
              Opacity(opacity: 0,child: buttonIcon,),
            ],
          ),
        ),
      ),
    );
  }
}
