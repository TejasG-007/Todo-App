import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication {

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> signInWithGoogle() async {
    try {
      GoogleSignInAccount? res = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await res!.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
      UserCredential userCred = await _auth.signInWithCredential(credential);
      User? user = _auth.currentUser;
      // print(user!.email);
      // print(user.photoURL);
      // print(user.displayName);
      return user != null;
    } catch (e) {
      log("$e Error");
      return false;
    }
  }

  signOut() async {
    try{
      await _auth.signOut();
    }catch(e){
      throw "Unable to Sign out";
    }
  }

  Map<String,dynamic> userDetails(){
   User? user =  _auth.currentUser;
   return {"userId":user!.uid,"userName":user.displayName,"emailId":user.email,"photoUrl":user.photoURL};
  }
}
