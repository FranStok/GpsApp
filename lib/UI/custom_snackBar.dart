import 'package:flutter/material.dart';

class CustomSnackBar extends SnackBar{
  CustomSnackBar({
    Key? key, 
    required String mesagge,
    String btnLabel="Ok",
    Duration duration=const Duration(seconds: 2),
    VoidCallback? onOk
  }):super(
    key: key,
    content: Text(mesagge),
    duration: duration,
    action: SnackBarAction(label: btnLabel, onPressed: (){
      if(onOk!=null) onOk();
    })
  );

}