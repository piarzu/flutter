import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_odev/bases/detailed_product_base.dart';
import 'package:flutter_odev/bases/product_base.dart';
import 'package:flutter_odev/db/db.dart';
import 'package:flutter_odev/pages/add_product_page.dart';
import 'package:flutter_odev/pages/product_detail_page.dart';

class NameSearchPage extends StatefulWidget {
  const NameSearchPage({Key? key}) : super(key: key);

  @override
  _NameSearchPageState createState() => _NameSearchPageState();
}

class _NameSearchPageState extends State<NameSearchPage> {
  Database _database = Database();
  TextEditingController _textEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _searched = false;
  List<Product>? _products;
  List<DetailedProduct>? _detailedProducts;

  void _getProduct(String productName) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _products != null ? _products!.clear() : {};
      _products = await _database.getProductsWithName(productName);
      setState(() {
        _searched = true;
      });
    }
  }

  Future<void> _convert(Product product) async {
      _detailedProducts=await _database.getProductWithBarcode(product.barcode);

      Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetailPage(products: _detailedProducts)));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFormField(
                  autofocus: true,
                  controller: _textEditingController,
                  textCapitalization: TextCapitalization.words,
                  validator: (query) {
                    if (query!.length <= 3) {
                      return "Yetersiz karakter girdiniz";
                    } else if (query.length == 0) {
                      return "Ürün adını girin";
                    } else {
                      return null;
                    }
                  },
                  onFieldSubmitted: (value) {
                    _getProduct(value);
                  },
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "Aradığınız ürünün adını giriniz",
                    prefixIcon: Icon(
                      Icons.search,
                      size: 35,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                _searched == false
                    ? SizedBox()
                    : _products != null
                        ? Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: _products!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      _textEditingController.clear();
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    _products![index].name,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: size.height * 0.01,
                                                  ),
                                                  Text(
                                                    "Barkod: " +
                                                        _products![index]
                                                            .barcode,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
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
                        : Card(
                            elevation: 10,
                            shadowColor: Colors.grey,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 18.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              "Malesef aradığınız ürünü bulamadık :(",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontSize: 13,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(3.0),
                                              child: Text(
                                                "Ama sen ekleyebilirsin :)",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AddProductPage(),
                                            ),
                                          ),
                                          child: Text("Ürün Ekle"),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}
