import 'package:flutter/material.dart';
import 'package:sos_aguas/models/reports/report.dart';
import 'package:sos_aguas/storages/report_storage.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreeem createState() => _NewsScreeem();
}
class _NewsScreeem extends State<NewsScreen>{
  late Future<List<Report>> reports = ReportStorage().GetAll();

  @override
  void initState() {
    super.initState();
    reports = ReportStorage().GetAll();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: reports,
        builder: (context, snapshot) {
          List<Report> reportList = snapshot.data ?? [];

          return ListView.builder(
            itemCount: reportList.length,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.all(10),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reportList[index].reportType == ReportType.Flood ? "Alagamento" : "Falta de água",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        reportList[index].title,
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        '${reportList[index].date?.day.toString().padLeft(2, '0')}/${reportList[index].date?.month.toString().padLeft(2, '0')}/${reportList[index].date?.year}'
                        ,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
    );
  }
}