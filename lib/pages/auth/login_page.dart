import 'package:chat_app_flutter/pages/auth/register_page.dart';
import 'package:chat_app_flutter/services/auth_service.dart';
import 'package:chat_app_flutter/services/database_service.dart';
import 'package:chat_app_flutter/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../helpers/helper_functions.dart';
import '../home_page.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  String email="",password="";
 final formKey=GlobalKey<FormState>();
 AuthServuce authServuce=AuthServuce();
 bool _isLoading=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body:_isLoading?Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,)):
       SingleChildScrollView(
        child: Padding(
          padding:const EdgeInsets.symmetric(horizontal: 20.0,vertical: 80.0),
          child: Form(
            key: formKey,
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment:CrossAxisAlignment.center,
            // ignore: prefer_const_literals_to_create_immutables
            children:<Widget>[
              const Text('Hello'
              ,style: TextStyle(fontSize: 40,fontWeight:FontWeight.bold),),
              const SizedBox(height: 10,),
              // ignore: prefer_const_constructors
              Center(
                child: const Text('Login now to see what they are doing',
                style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400),),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Image.asset("assets/Login.png"),
              ),
              TextFormField(
                decoration: textInputDecoration.copyWith(
                  labelText:'Email',
                  prefixIcon: Icon(Icons.email,
                  color: Theme.of(context).primaryColor,)
                ),
                validator: (value) {
                  return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)?null:"Please enter a valid email";
                },
                onChanged: (value) {
                  setState(() {
                    email=value;
                  });
                },
              ),
              const SizedBox(height: 10,),
                TextFormField(
                  obscureText: true,
                decoration: textInputDecoration.copyWith(
                  labelText:'Password',
                  prefixIcon: Icon(Icons.lock,
                  color: Theme.of(context).primaryColor,)
                ),
                validator: (value) {
                  if(value!.length<6){
                    return "Password should be minimum of 6 characters";
                  }else{
                    return null;
                  }
                },
                 onChanged: (value) {
                  setState(() {
                    password=value;
                  });
                },
              ),
             const SizedBox(height: 20,),
            SizedBox(
              width: double.infinity,
              // ignore: sort_child_properties_last
              child: ElevatedButton(child: const Text('Sign In',
              style:TextStyle(color: Colors.white,fontSize: 16) ,),
              onPressed: (){
                logIn();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                )),),
            ),
            const SizedBox(height: 10,),
            Text.rich(TextSpan(text: "Don't have an account? ",
            style:const TextStyle(fontSize: 14,color: Colors.black),
              children:<TextSpan>[
               TextSpan(
                  text: "Resgister here",
                  style:const TextStyle(fontSize: 14,decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()..onTap=() {
                    nextSecreen(context,const RegisterPage());
                  },
                ),
              ], )
              
            )
            ],)),
        ),
      ),
    );
  }
  logIn()async{
if(formKey.currentState!.validate()){
  setState(() {
     _isLoading=true;
  });
  await authServuce.logIn(email, password).then((value) async {
    if(value==true){
      //saving the SF state
     QuerySnapshot snapshot=await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getUSerData(email);
     await HelperFunctions.saveUserLoggedInStatus(true);
      await HelperFunctions.saveUserEmailSF(email);
      await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullName']);
      nextSecreenReplacement(context, const HomePage());
    }else {
      setState(() {
        showSnackBar(context, value, Colors.red);
        _isLoading=false;
      });
    }
  });
}
  }
}