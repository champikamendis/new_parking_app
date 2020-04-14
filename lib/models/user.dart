import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class User {
  final String uid;
  User({ this.uid });
}


class Userdetails{
  String key;
  String fName;
  String lName;
  String email;

  Userdetails(this.fName, this.lName, this.email);

  Userdetails.fromSnapshot(DataSnapshot snapshot) :
            key = snapshot.key,
            fName = snapshot.value["firstName"],
            lName = snapshot.value["lastName"],
            email = snapshot.value["email"];

  toJson(){
    return{
      "firstName": fName,
      "lastName": lName,
      "email": email

    };
  }          

}