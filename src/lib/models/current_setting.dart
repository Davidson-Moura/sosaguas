import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CurrentSetting {

  String id;
  String email;
  String name;
  String password;

  CurrentSetting({ this.id = '', this.email = '', this.password = '', this.name = '' });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'password': password,
    };
  }

  factory CurrentSetting.fromJson(Map<String, dynamic> json) {
    return CurrentSetting(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      password: json['password'],
    );
  }


  final Future<SharedPreferencesWithCache> _prefs =
  SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
          allowList: <String>{'counter'}
      )
  );


  Future<void> Save() async {
    final prefs = await SharedPreferences.getInstance();
    String stngJson = jsonEncode(this.toJson());
    await prefs.setString('currentSetting', stngJson);
  }

  Future<CurrentSetting?> Fill() async {
    final prefs = await SharedPreferences.getInstance();
    String? settingJson = prefs.getString('currentSetting');

    if (settingJson == null) return null;
    CurrentSetting stng = CurrentSetting.fromJson(jsonDecode(settingJson));

    this.id = stng.id;
    this.email = stng.email;
    this.name = stng.name;
    this.password = stng.password;

    return stng;
  }
  void Clear(){
    this.id = '';
    this.email = '';
    this.name = '';
    this.password = '';
  }

}