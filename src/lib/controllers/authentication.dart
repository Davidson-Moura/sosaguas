import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sos_aguas/models/user.dart';

class Authentication{
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<User> login(String email, String password) async {
    QuerySnapshot snapshot = await _firestore.collection('Users')
        .where('email', isEqualTo: email)
        .where('password', isEqualTo: password)
        .limit(1)
        .get()
        ;

    if(snapshot.docs.length <= 0) throw new Exception("Login inválido!");

    var first = snapshot.docs.first;
    Map<String, dynamic> userData = first.data() as Map<String, dynamic>;

    return User.fromJson(userData, first.id);
  }
}