import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_odev/bases/detailed_product_base.dart';
import 'package:flutter_odev/bases/hive_base.dart';
import 'package:flutter_odev/common/custom_alert_dialog.dart';
import 'package:flutter_odev/common/custom_button.dart';
import 'package:flutter_odev/common/loading_page.dart';
import 'package:flutter_odev/consts/consts.dart';
import 'package:flutter_odev/consts/markets.dart';
import 'package:flutter_odev/db/db.dart';
import 'package:flutter_odev/error_manager/errors.dart';
import 'package:flutter_odev/services/storage_service.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({Key? key}) : super(key: key);

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  Box<HiveUser> _authUserBox = Hive.box<HiveUser>(localDB);
  bool _isLoading = false;
  File? image;
  Database _database = Database();
  StorageService _storageService = StorageService();
  final _formKey = GlobalKey<FormState>();
  final ImagePicker picker = ImagePicker();
  TextEditingController _productNameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _barcodeController = TextEditingController();
  String? _productName, _barcode, _price;
  String? _market;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return _isLoading == false
        ? Scaffold(
            appBar: AppBar(
              title: Text(
                "Ürün Ekle",
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                  child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () async {
                            return _takePicFromCamera();
                          },
                          child: image != null
                              ? CircleAvatar(
                                  backgroundColor: Colors.black,
                                  radius: size.width * 0.205,
                                  child: CircleAvatar(
                                    radius:
                                        MediaQuery.of(context).size.width * 0.2,
                                    backgroundImage: FileImage(
                                      image!,
                                    ),
                                  ),
                                )
                              : Stack(
                                  alignment: AlignmentDirectional.bottomEnd,
                                  children: [
                                    SvgPicture.asset(
                                      "images/add_product.svg",
                                      height: size.height * 0.2,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.camera_alt,
                                          size: 25,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    image != null
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Ürün Resmi",
                              style: TextStyle(fontSize: 18),
                            ),
                          )
                        : SizedBox(),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(29),
                      ),
                      child: TextFormField(
                        controller: _productNameController,
                        textCapitalization: TextCapitalization.words,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 3) {
                            return "Ürün adı çok kısa";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (inputName) {
                          _productName = inputName!;
                        },
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 2.5),
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          errorStyle: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                          icon: Icon(
                            Icons.add_shopping_cart_outlined,
                            color: Colors.white,
                          ),
                          hintText: "Ürün Adı",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(29),
                      ),
                      child: TextFormField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Ürün fiyatı giriniz";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (inputName) {
                          _price = inputName!;
                        },
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 2.5),
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          errorStyle: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                          icon: Icon(
                            Icons.money,
                            color: Colors.white,
                          ),
                          hintText: "Ürün Fiyatı",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(29),
                      ),
                      child: TextFormField(
                        controller: _barcodeController,
                        obscureText: false,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 7) {
                            return "Ürün barkodu çok kısa";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (barcode) {
                          _barcode = barcode!;
                        },
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 2.5,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          errorStyle: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                          icon: Icon(
                            Icons.qr_code,
                            color: Colors.white,
                          ),
                          hintText: "Ürün Barkodu",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 15, 30, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.lightBlueAccent,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: DropdownButtonHideUnderline(
                                      child: ButtonTheme(
                                        alignedDropdown: true,
                                        child: DropdownButton<String>(
                                          isDense: true,
                                          hint: new Text("Market Seçin"),
                                          value: _market,
                                          onChanged: (newValue) {
                                            setState(() {
                                              _market = newValue!;
                                            });

                                            print(_market);
                                          },
                                          items: markets.map((Map map) {
                                            return new DropdownMenuItem<String>(
                                              value: map["name"].toString(),
                                              child: Row(
                                                children: <Widget>[
                                                  Image.asset(
                                                    map["image"],
                                                    width: size.width * 0.3,
                                                    height: size.height * 0.1,
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10),
                                                    child: Text(
                                                      map["name"],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
                      child: CustomButton(
                        onPressed: () => _formSubmit(),
                        buttonText: "Ürünü Kaydet",
                      ),
                    ),
                  ],
                ),
              )),
            ),
          )
        : LoadingPage();
  }

  _formSubmit() async {
    if (image == null) {
      await customAlertDialog(context, "Resim Yok!",
          "Ürün resmi olmadan ürün ekleyemezsiniz!", AlertType.error);
    } else if(_market!=null){
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        try {
          setState(() {
            _isLoading = true;
          });
          String? _url = await _storageService.uploadProductPhoto(_barcode!, image!);
          DetailedProduct _product = DetailedProduct(
            market: _market!,
            name: _productName!,
            barcode: _barcode!,
            image: _url,
            price: double.parse(_price!),
            user: _authUserBox.get(localDB)!.username,
          );
          await _database.createProduct(_product);

          setState(() {
            _isLoading = false;
            image = null;
            _priceController.clear();
            _barcodeController.clear();
            _productNameController.clear();
          });
          await customAlertDialog(
            context,
            "İşlem Başarılı!",
            "Ürün başarıyla eklendi Teşekkürler :)",
            AlertType.success,
          );
        } on FirebaseException catch (e) {
          await customAlertDialog(
            context,
            "HATA!",
            "Hata oluştu ${ErrorManager.show(e.code)}",
            AlertType.error,
          );
        }
      }
    }else{
      await customAlertDialog(context, "Market Yok!",
          "Market seçiniz market olmadan ürün ekleyemezsiniz!", AlertType.error);
    }
  }

  void _takePicFromCamera() async {
    final newImage =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 30);
    setState(() {
      image = File(newImage!.path);
    });
  }
}
