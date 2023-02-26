import 'package:chat_app_flutter/helpers/helper_functions.dart';
import 'package:chat_app_flutter/pages/home_page.dart';
import 'package:chat_app_flutter/services/auth_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey=GlobalKey<FormState>();
  String email="",password="",fullName="";
  bool _isLoading=false;
  AuthServuce authServuce=AuthServuce();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body:_isLoading? Center(
         child: CircularProgressIndicator(
          color: Theme.of(context).primaryColor,
         ),
       ): SingleChildScrollView(
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
                padding: const EdgeInsets.symmetric(vertical:20),
                child: Image.asset("assets/Register.png",
                height: 250.0,),
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
              ), const SizedBox(height: 10,),
                TextFormField(
                decoration: textInputDecoration.copyWith(
                  labelText:'Full Name',
                  prefixIcon: Icon(Icons.person,
                  color: Theme.of(context).primaryColor,)
                ),
                validator: (value) {
                  if(value!.isNotEmpty){
                    return null;
                  }else{
                    return "Name cannot be empty";
                  }
                },
                 onChanged: (value) {
                  setState(() {
                    fullName=value;
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
                register();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                )),),
            ),
            const SizedBox(height: 10,),
            Text.rich(TextSpan(text: "Already have an account? ",
            style:const TextStyle(fontSize: 14,color: Colors.black),
              children:<TextSpan>[
               TextSpan(
                  text: "Login Now",
                  style:const TextStyle(fontSize: 14,decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()..onTap=() {
                   Navigator.pop(context);
                  },
                ),
              ], )             
            )
            ],)),
        ),
      ),
    );
  }
   register()async{
if(formKey.currentState!.validate()){
  setState(() {
     _isLoading=true;
  });
  await authServuce.newUserFromEmail(email, password, fullName).then((value) async {
    if(value==true){
      //saving the SF state
      await HelperFunctions.saveUserLoggedInStatus(true);
      await HelperFunctions.saveUserEmailSF(email);
      await HelperFunctions.saveUserNameSF(fullName);
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