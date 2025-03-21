import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sos_aguas/models/current_setting.dart';
import 'package:sos_aguas/models/reports/report.dart';
import 'package:sos_aguas/storages/report_storage.dart';

class EditReportScreen extends StatefulWidget {
  final Report report = Report();

  EditReportScreen();

  @override
  _EditReportScreenState createState() => _EditReportScreenState();
}

class _EditReportScreenState extends State<EditReportScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _msgController;
  late ReportType _selectedReportType;

  double? latitude;
  double? longitude;

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verifica se o serviço de localização está ativado
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _mostrarMensagem(context, "É necessário ativar a localização do celular.");
      print("################ desativado");
      Navigator.pop(context, null);
      return;
    }

    // Verifica permissões
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _mostrarMensagem(context, "É necessário dar permissão ao app acessar a localização.");
        Navigator.pop(context, null);

        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _mostrarMensagem(context, "É necessário dar permissão ao app acessar a localização.");
      Navigator.pop(context, null);
      print(2);
      return;
    }

    // Obtém a localização
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });

  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.report.title);
    _msgController = TextEditingController(text: widget.report.msg);
    _selectedReportType = widget.report.reportType;

    _getCurrentLocation();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _msgController.dispose();
    super.dispose();
  }
  void _mostrarMensagem(BuildContext context, String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        duration: Duration(seconds: 3), // Tempo de exibição
        backgroundColor: Colors.blue, // Cor do fundo
      ),
    );
  }
  Future<void> _saveReport() async {
    if (_formKey.currentState!.validate()) {

      var stng = new CurrentSetting();
      await stng.Fill();

      Report addReport = Report(
        id: widget.report.id,
        userId: stng.id,
        userName: stng.name,
        date: DateTime.now(),
        reportType: _selectedReportType,
        lat: latitude??0.0,
        lng: longitude??0.0,
        title: _titleController.text,
        msg: _msgController.text,
      );

      ReportStorage().Add(addReport);
      _mostrarMensagem(context, "Salvo com sucesso!");
      Navigator.pop(context, addReport);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Editar Report")),
        body:Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: "Título"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "O título não pode estar vazio";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _msgController,
                decoration: InputDecoration(labelText: "Mensagem"),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "A mensagem não pode estar vazia";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Text("Tipo de Report:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              DropdownButton<ReportType>(
                value: _selectedReportType,
                onChanged: (newValue) {
                  setState(() {
                    _selectedReportType = newValue!;
                  });
                },
                items: ReportType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type == ReportType.Flood ? "Enchente" : "Falta de Água"),
                  );
                }).toList(),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _saveReport,
                    child: Text("Salvar"),
                  ),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancelar"),
                  ),
                ],
              ),
            ],
          ),
        ),
    )
    );
  }
}
