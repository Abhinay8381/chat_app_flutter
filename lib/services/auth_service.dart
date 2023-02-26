import 'package:chat_app_flutter/helpers/helper_functions.dart';
import 'package:chat_app_flutter/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServuce{
 final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
// new Account function
Future newUserFromEmail(String email,String password,String fullName)async{
  try{
    User user=(await _firebaseAuth.createUserWithEmailAndPassword(
      email: email, password: password)).user!;
      if(user!=null){
       await DatabaseService(uid: user.uid).saveUserData(fullName, email);
       return true;
      }
  }
  on FirebaseAuthException catch(e){
    return e.message;
  }
}
//sign out function
Future signOut()async{
  await _firebaseAuth.signOut();
  await HelperFunctions.saveUserEmailSF("");
  await HelperFunctions.saveUserLoggedInStatus(false);
  await HelperFunctions.saveUserNameSF("");
}
// login 
Future logIn(String email,String password)async{
  try{
    User user=(await _firebaseAuth.signInWithEmailAndPassword(
      email: email, password: password)).user!;
      if(user!=null){
       return true;
      }
  }
  on FirebaseAuthException catch(e){
    return e.message;
  }
}
}