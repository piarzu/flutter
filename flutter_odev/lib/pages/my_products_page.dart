import 'package:flutter/material.dart';
import 'package:flutter_odev/bases/detailed_product_base.dart';
import 'package:flutter_odev/bases/hive_base.dart';
import 'package:flutter_odev/bases/product_base.dart';
import 'package:flutter_odev/common/loading_page.dart';
import 'package:flutter_odev/consts/consts.dart';
import 'package:flutter_odev/db/db.dart';
import 'package:flutter_odev/pages/product_detail_page.dart';
import 'package:hive/hive.dart';

class MyProductsPage extends StatefulWidget {
  const MyProductsPage({Key? key}) : super(key: key);

  @override
  _MyProductsPageState createState() => _MyProductsPageState();
}

class _MyProductsPageState extends State<MyProductsPage> {
  bool _loading = true;
  List<Product>? _products;
  List<DetailedProduct>? _detailedProducts = [];
  Database _database = Database();
  Box<HiveUser> _userBox = Hive.box<HiveUser>(localDB);

  @override
  void initState() {
    super.initState();
    _getProducts();
  }

  Future<void> _convert(Product product) async {
    _detailedProducts = await _database.getProductWithBarcode(product.barcode);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ProductDetailPage(products: _detailedProducts)));
  }

  _getProducts() async {
    setState(() {
      _loading = true;
    });
    _products =
        await _database.getFollowingProducts(_userBox.get(localDB)!.username);
    if (_products == null) {
      print("list null");
    } else {
      if (_products!.isEmpty) {
        print("product bos");
      } else {
        print("product var");
      }
    }

    Future.delayed(
        Duration(
          seconds: 3,
        ), () {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return _loading == false
        ? Scaffold(
            appBar: AppBar(
              title: Text("Ürünlerim"),
            ),
            body: _products != null
                ? Container(
                    height: size.height,
                    width: size.width,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _products!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              _convert(_products![index]);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Card(
                                elevation: 10,
                                shadowColor: Colors.grey,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 18.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        height: size.height * 0.1,
                                        width: size.width * 0.22,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(
                                              _products![index].image,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            _products![index].name,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: size.height * 0.01,
                                          ),
                                          Text(
                                            "Barkod: " +
                                                _products![index].barcode,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  )
                : Center(
                    child: Text("Takip ettiğiniz ürün bulunmuyor..."),
                  ),
          )
        : LoadingPage();
  }
}
