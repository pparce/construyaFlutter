import 'package:construyaalcosto/models/login.dart';
import 'package:construyaalcosto/services/message-serveice.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class LoginService extends ChangeNotifier {
  static LoginService _instance;
  Login login;

  LoginService._internal() {
    _instance = this;
    initLogin();
  }

  void initLogin() async {
    login = Login();
    Box box = await Hive.openBox('app');
    String loginString = box.get('login', defaultValue: '');
    if (loginString.isNotEmpty) {
      login = loginFromJson(loginString);
    }

    notifyListeners();
  }

  bool isLogin() {
    return login.id != null;
  }

  addLogin(Login login) {
    this.login = login;
    setFirstTimeUser(true);
    saveLogin();
  }

  void logout() async {
    login = Login();
    Box box = await Hive.openBox('app');
    box.put('login', '');
    notifyListeners();
  }

  Login getLogin() {
    return login;
  }

  void saveLogin() async {
    Box box = await Hive.openBox('app');
    box.put('login', loginToJson(login));
    notifyListeners();
  }

  void setFirstTimeUser(bool value) async {
    Box box = await Hive.openBox('app');
    box.put('firstTimeUser', value);
  }

  void showWelcomeMessage(BuildContext context) async {
    bool isFirstTime = await isFirstTimeUser();
    if (isFirstTime) {
      setFirstTimeUser(false);
      MessageService.showMessage(
        context: context,
        isNegative: false,
        duration: 3000,
        mensaje:
            'Bienvenido ${login.customer.user.firstName} ${login.customer.user.lastName}',
      );
    }
  }

  Future<bool> isFirstTimeUser() async {
    Box box = await Hive.openBox('app');
    bool firstTimeUser = box.get('firstTimeUser', defaultValue: false);
    return firstTimeUser;
  }

  factory LoginService() => _instance ?? LoginService._internal();
}
