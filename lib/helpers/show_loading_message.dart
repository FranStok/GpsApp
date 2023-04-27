import 'package:flutter/material.dart';

showLoadingMessage(BuildContext context){
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Espere por favor"),
        content: SizedBox(
          height: 80,
          width: 100,
          child: Column(
            children: const [
              Text("Calculando ruta"),
              SizedBox(height: 20),
              CircularProgressIndicator(strokeWidth: 3, color: Colors.black)
            ],
          ),
        ),
      )
  );
  return;
}


