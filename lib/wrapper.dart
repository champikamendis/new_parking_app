import 'package:flutter/cupertino.dart';
import 'package:new_parking_app/screens/authenticate/login.dart';
import 'package:new_parking_app/screens/ui/home.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context); 
    
    if(user == null){
      return Login();
    }else{
      return MyHomePage();
    }
  }

}