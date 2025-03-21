import 'package:cloud_firestore/cloud_firestore.dart';

class Report{
  String id;
  String userId;
  String userName;

  DateTime? date;

  ReportType reportType;

  double lat;
  double lng;

  String title;
  String msg;



  Report({ this.id = '', this.userId = '', this.userName = '',
    this.date = null,
    this.reportType = ReportType.Flood,
    this.lat = 0.0, this.lng = 0.0,
    this.title = '', this.msg = ''
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'date': date,

      'reportType': reportType.index,

      'lat': lat,
      'lng': lng,

      'title': title,
      'msg': msg,
    };
  }



  factory Report.fromJson(Map<String, dynamic> json, String id) {
    var report = Report(
      id: id,
      userId: json['userId'],
      userName: json['userName'],

      date: json['date'] is Timestamp ? (json['date'] as Timestamp).toDate() : null,

      reportType: ReportType.values[json['reportType']],

      lat: json['lat'],
      lng: json['lng'],

      title: json['title'],
      msg: json['msg'],
    );


    return report;
  }
}
enum ReportType {
  Flood, //Enchente 0
  LackOfWater // Falta de água 1
}