import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sos_aguas/models/user.dart';

class UserStorage{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> add(User user) async {
    await _firestore.collection('Users').add(user.toJson());
  }
  Future<List<User>> GetAll() async {
    QuerySnapshot snapshot = await _firestore.collection('Users').get();

    List<User> list = [];
    for (var doc in snapshot.docs) {
      var json = doc.data() as Map<String, dynamic>;
      list.add(User.fromJson(json, doc.id));
    }

    return list;
  }
}