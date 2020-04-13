import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtil {
  // kalau mau buat data baru tentang shared prefences
  getUserId() async {
    String _userId;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userId = (prefs.getString('user_id'));
    prefs.setString('user_id', _userId);
    return _userId;
  }
  getEmail() async {
    String _email;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _email = (prefs.getString('email'));
    prefs.setString('email', _email);
    return _email;
  }

  getVariable(String namaVariable) async {
    String _valueVariable;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _valueVariable = (prefs.getString(namaVariable));
    return _valueVariable;
  }

  saveVariable(String namaVariable, String valueVariable) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(namaVariable, valueVariable);
  }
}
