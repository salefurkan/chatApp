import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:private_chat_app/helper/helperfunction.dart';
import 'package:private_chat_app/services/auth.dart';
import 'package:private_chat_app/services/database.dart';
import 'package:private_chat_app/views/chatRoomsScreen.dart';

import 'package:private_chat_app/widgets/widget.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;

  AuthMethods authMethods = new AuthMethods();

  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController =
      new TextEditingController();
  TextEditingController eMailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();

  signMeUp() {
    if (formKey.currentState.validate()) {
      Map<String, String> userInfoMap = {
        "name": userNameTextEditingController.text.toLowerCase(),
        "email": eMailTextEditingController.text.toLowerCase(),
      };
      HelperFunctions.saveUserEmailSharedPreference(
          eMailTextEditingController.text.toLowerCase());
      HelperFunctions.saveUserNameSharedPreference(
          userNameTextEditingController.text.toLowerCase());

      setState(() {
        isLoading = true;
      });
      authMethods
          .signUpwithEmailAndPassword(eMailTextEditingController.text,
              passwordTextEditingController.text)
          .then((val) {
        //print("$val.uid");

        databaseMethods.uploadUserInfo(userInfoMap);

        HelperFunctions.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChatRoom()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading
          ? Container(
              child: Center(
                child: SpinKitDualRing(
                  color: Colors.white54,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                color: Colors.black87,
                height: MediaQuery.of(context).size.height - 50,
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Form(
                        key: formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              validator: (val) {
                                return val.isEmpty || val.length < 2
                                    ? "Lütfen kullanıcı adı giriniz."
                                    : null;
                              },
                              controller: userNameTextEditingController,
                              style: simpleTextFieldStyle(),
                              decoration: textFieldInputDecoration('username'),
                            ),
                            TextFormField(
                              validator: (val) {
                                return RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(val)
                                    ? null
                                    : "Lütfen geçerli mail adresi giriniz";
                              },
                              controller: eMailTextEditingController,
                              style: simpleTextFieldStyle(),
                              decoration: textFieldInputDecoration('email'),
                            ),
                            TextFormField(
                              obscureText: true,
                              validator: (val) {
                                return val.length > 5
                                    ? null
                                    : "Lütfen en az 6 haneli şifre giriniz.";
                              },
                              controller: passwordTextEditingController,
                              style: simpleTextFieldStyle(),
                              decoration: textFieldInputDecoration(
                                'password',
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          "Şifremi Unuttum",
                          style: simpleTextFieldStyle(),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      GestureDetector(
                        onTap: () {
                          signMeUp();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xffAACCAA),
                                const Color(0xff00AAAA)
                              ],
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            "Kayıt Ol",
                            style: simpleTextFieldStyle(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          "Sign Up with Google",
                          style: TextStyle(color: Colors.black87, fontSize: 17),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Üye misin?",
                            style: simpleTextFieldStyle(),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.toggle();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                "Hemen Giriş Yap",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
