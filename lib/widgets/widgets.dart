import 'package:flutter/material.dart';

const textInputDecoration=InputDecoration(
   labelStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.w300),
  focusedBorder: OutlineInputBorder(
    borderSide:BorderSide(color: Colors.black87),
),
errorBorder: OutlineInputBorder(
    borderSide:BorderSide(color: Colors.black87),
),
enabledBorder: OutlineInputBorder(
    borderSide:BorderSide(color: Colors.black87),
),
);
nextSecreen(context,page){
  Navigator.push(context, MaterialPageRoute(builder:(context) =>page));
}
nextSecreenReplacement(context,page){
  Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) =>page));
}
void showSnackBar(context,message,color){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message,style: const TextStyle(fontSize: 14,),),
    action: SnackBarAction(label: "OK", onPressed: (){},textColor: Colors.white,),
    duration: const Duration(seconds: 2),
    backgroundColor: color,
    )  
  );

}