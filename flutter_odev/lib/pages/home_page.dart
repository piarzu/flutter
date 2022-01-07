import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_odev/bases/detailed_product_base.dart';
import 'package:flutter_odev/db/db.dart';
import 'package:flutter_odev/pages/add_product_page.dart';
import 'package:flutter_odev/pages/product_detail_page.dart';
import 'package:flutter_odev/pages/profile_page.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../pages/my_products_page.dart';
import '../pages/name_search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _tapped = false;
  String _scanBarcode = 'Bilinmiyor';
  Database _database=Database();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Ana Sayfa"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _mainWidget(
                  size,
                  "images/products.svg",
                  "Ürünlerim",
                  MyProductsPage(),
                ),_mainWidget(
                  size,
                  "images/app.svg",
                  "Profilim",
                  ProfilePage(),
                ),
                _customSearchBoxWidget(
                  size,
                  "images/search_product.svg",
                  "Ürün Ara",
                  NameSearchPage(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> scanBarcode() async {
    List<DetailedProduct>? _productsWithMarkets;
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Geri Dön', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Barkod okunamadı!';
    }
    if (!mounted) return;
    setState(() {
      _scanBarcode = barcodeScanRes;
    });

    _productsWithMarkets=await _database.getProductWithBarcode(_scanBarcode);

    if(_productsWithMarkets!=null){
      print("bulduk");
      print("PRODUCT ---> ${_productsWithMarkets.first.name}");
      Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetailPage(products: _productsWithMarkets,),),);
    }else{
      print("urun bulunamadı");
      await Alert(
        context: context,
        type: AlertType.info,
        title: "Ürün Bulunamadı!",
        desc: "Aradığınız ürünü bulamadık, siz ürün ekleyebilirsiniz",
        style: AlertStyle(animationType: AnimationType.grow,),
        buttons: [
          DialogButton(
            color: Colors.red,
            child: Text(
              "Geri Dön",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          ),
          DialogButton(
            color: Colors.lightBlueAccent,
            child: Text(
              "Ürün Ekle",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>AddProductPage(),),);
            },
            width: 120,
          ),
        ],
      ).show();
    }

  }

  Widget _mainWidget(Size size, String path, title, Widget page) {
    return Stack(
      alignment: AlignmentDirectional.topStart,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => page,
              ),
            ),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    height: size.height * 0.15,
                    width: size.width * 0.6,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SvgPicture.asset(
                        path,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _customSearchBoxWidget(Size size, String path, title, Widget page) {
    return Stack(
      alignment: AlignmentDirectional.topStart,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => {
              setState(() {
                _tapped = !_tapped;
              }),
            },
            child: _tapped == false
                ? Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 21, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          height: size.height * 0.15,
                          width: size.width * 0.6,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: SvgPicture.asset(
                              path,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Card(
                    elevation: 10,
                    color: Colors.grey.shade200,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: size.height * 0.18,
                        width: size.width * 0.6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () async=> await scanBarcode(),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.blue.shade200,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Icon(
                                        Icons.qr_code,
                                        color: Colors.blue,
                                      ),
                                      Text(
                                        "Barkod İle Ürün Bul",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => page,
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.blue.shade200,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Icon(
                                        Icons.search_off_outlined,
                                        color: Colors.blue,
                                      ),
                                      Text(
                                        "Ürün Adı ile Ürün Bul",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
