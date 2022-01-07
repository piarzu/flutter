import 'dart:io';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_odev/bases/hive_base.dart';
import 'package:flutter_odev/common/custom_alert_dialog.dart';
import 'package:flutter_odev/common/custom_button.dart';
import 'package:flutter_odev/common/loading_page.dart';
import 'package:flutter_odev/consts/consts.dart';
import 'package:flutter_odev/db/db.dart';
import 'package:flutter_odev/pages/onboard_page.dart';
import 'package:flutter_odev/services/auth_service.dart';
import 'package:flutter_odev/services/storage_service.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker picker = ImagePicker();
  bool _loading = false;
  bool _isHidden = true;
  Box<HiveUser> _userBox = Hive.box<HiveUser>(localDB);
  File? _image;
  final _formKey = GlobalKey<FormState>();
  AuthService _authService = AuthService();
  StorageService _storageService = StorageService();
  Database _database = Database();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _passwordController.text = _userBox.get(localDB)!.password;
    return _loading == false
        ? Scaffold(
            appBar: AppBar(
              title: Text("Profil"),
              backgroundColor: Colors.blue,
              actions: [
                FlatButton.icon(
                  onPressed: () => _logOutControl(),
                  icon: Icon(
                    Icons.login_outlined,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Çıkış Yapın",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () async {
                        return showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.19,
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      leading: Icon(
                                        Icons.camera_alt,
                                      ),
                                      title: Text("Kameradan Çek"),
                                      onTap: () {
                                        _takePicFromCamera();
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.image),
                                      title: Text("Galeriden Seç"),
                                      onTap: () {
                                        _chooseFromGallery();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                      child: _image != null
                          ? CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: size.width * 0.205,
                              child: CircleAvatar(
                                radius: MediaQuery.of(context).size.width * 0.2,
                                backgroundImage: FileImage(
                                  _image!,
                                ),
                              ),
                            )
                          : Stack(
                              alignment: AlignmentDirectional.bottomEnd,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.black,
                                  radius: size.width * 0.205,
                                  child: CircleAvatar(
                                    radius:
                                        MediaQuery.of(context).size.width * 0.2,
                                    backgroundImage: NetworkImage(
                                      _userBox.get(localDB)!.profileUrl,
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blue,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.edit,
                                      size: 25,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            height: size.height * 0.08,
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(),
                                  Text(
                                    "Kullanıcı Adınız: ",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    _userBox.get(localDB)!.username,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: size.width * 0.1,
                                  )
                                ],
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                          child: Container(
                            height: size.height * 0.15,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 5, 8, 0),
                                  child: Text(
                                    "Şifreniz",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: TextFormField(
                                    validator: (value){
                                      if(value!.isEmpty||value.length<4){
                                        return "Şifre çok kısa";
                                      }else{
                                        return null;
                                      }
                                    },
                                    obscureText: _isHidden,
                                    controller: _passwordController,
                                    decoration: InputDecoration(
                                      hintText: 'Şifreniz',
                                      suffix: InkWell(
                                        onTap: _togglePasswordView,
                                        child: Icon(
                                          _isHidden
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                          child: CustomButton(
                            buttonText: "Hesabını Güncelle",
                            buttonIcon: Icon(
                              Icons.send_sharp,
                              color: Colors.white,
                            ),
                            buttonColor: Colors.blue.shade400,
                            height: 40,
                            onPressed: () => _formSubmit(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                          child: CustomButton(
                            buttonText: "Hesabımı Sil",
                            buttonColor:Colors.red,
                            buttonIcon: Icon(
                              Icons.delete_forever_outlined,
                              color: Colors.white,
                            ),
                            height: 40,
                            onPressed: () async => _confirmDelete(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ))
        : LoadingPage();
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  void _takePicFromCamera() async {
    final newImage =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 30);
    setState(() {
      _image = File(newImage!.path);
    });
    Navigator.pop(context);
  }

  void _chooseFromGallery() async {
    final newImage =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 30);
    setState(() {
      _image = File(newImage!.path);
    });
    Navigator.pop(context);
  }

  _logOut() async {
    try {
      setState(() {
        _loading = true;
      });
      await _authService.logout();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => OnBoardingPage()),
          (route) => false);
    } on FirebaseException catch (e) {
      setState(() {
        _loading = false;
      });
      print(e.code);
      customAlertDialog(
          context, "Hata", "Beklenmeyen bir hata oluştu", AlertType.error);
    }
  }

  void _logOutControl() async {
    return showDialog(
      context: (context),
      builder: (ctx) {
        return AlertDialog(
          title: Text("Çıkış Yap"),
          content: Text("Çıkış yapacaksınız onaylıyor musunuz?"),
          actions: [
            FlatButton(
              onPressed: () async {
                Navigator.of(
                  context,
                ).pop();
                _logOut();
              },
              child: Text("Çıkış Yap"),
            ),
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Geri Dön"),
            )
          ],
        );
      },
    );
  }

  _formSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_userBox.get(localDB)!.password != _passwordController.text) {
        await _database.updatePassword(_passwordController.text, _userBox.get(localDB)!.username);
        _userBox.put(
          localDB,
          HiveUser(
            username: _userBox.get(localDB)!.username,
            profileUrl: _userBox.get(localDB)!.profileUrl,
            password: _passwordController.text,
          ),
        );
       setState(() async {
         await customAlertDialog(context, "İşlem Başarılı", "Hesabınız başarıyla güncellendi", AlertType.success);
       });
      }
      if (_image != null) {
        String? url = await _storageService.uploadUserPhoto(_userBox.get(localDB)!.username, _image!);
        await _database.updateProfilePhoto(url!, _userBox.get(localDB)!.username);
        _userBox.put(
          localDB,
          HiveUser(
            username: _userBox.get(localDB)!.username,
            profileUrl: url,
            password: _userBox.get(localDB)!.password,
          ),
        );
        setState(() async {
          await customAlertDialog(context, "İşlem Başarılı", "Hesabınız başarıyla güncellendi", AlertType.success);
        });

      }
    }
  }

  _confirmDelete() async {
    await Alert(context: context,type: AlertType.warning,title: "Emin Misiniz?",desc: "Hesabınızı silme üzeresiniz! "
        "Tüm bilgileriniz silinecektir ve b işlem geri alınamaz",buttons: [
      DialogButton(child: Text("Geri Dön"), onPressed: ()=>Navigator.pop(context),color: Colors.greenAccent,),
      DialogButton(child: Text("Hesabımı Sil"), onPressed: ()=>_deleteAccount(_userBox.get(localDB)!.username),color: Colors.red,),
    ],).show();
  }

  _deleteAccount(String username) async{
    await _database.deleteAccount(username);
    _userBox.clear();
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>OnBoardingPage()), (route) => false);
  }
}
