import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sos_aguas/models/reports/report.dart';

class ReportStorage{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> Add(Report user) async {
    await _firestore.collection('Reports').add(user.toJson());
  }
  Future<List<Report>> GetAll() async {
    var now = DateTime.now();
    QuerySnapshot snapshot = await _firestore.collection('Reports')
        .where('date', isGreaterThanOrEqualTo: DateTime(now.year, now.month, now.day, 0, 1, 0, 0))
        .get();

    List<Report> list = [];
    for (var doc in snapshot.docs) {
      var json = doc.data() as Map<String, dynamic>;
      list.add(Report.fromJson(json, doc.id));
    }

    return list;
  }
}