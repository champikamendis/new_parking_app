import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_parking_app/services/auth.dart';

class DatabaseService{

  

  final CollectionReference userDetails = Firestore.instance.collection('users');
 

  Future userData(String firstName, String lastName, String email, String profPicUrl) async {
    String userId = (await FirebaseAuth.instance.currentUser()).uid;

    return await userDetails.document(userId).setData({
      'firstName': firstName,
      'lastName': lastName,
      'email' : email,
      'profilePicture': profPicUrl,

    });
  }

}