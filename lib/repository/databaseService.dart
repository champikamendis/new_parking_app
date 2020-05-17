import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{
  final uid;

  DatabaseService({this.uid});

  final CollectionReference userDetails = Firestore.instance.collection('users');

  Future userData(String firstName, String lastName, String email) async {
    return await userDetails.document(uid).setData({
      'firstName': firstName,
      'lastName': lastName,
      'email' : email,
    });
  }

}