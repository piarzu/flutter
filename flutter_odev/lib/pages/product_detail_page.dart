import 'package:flutter/material.dart';
import 'package:flutter_odev/common/loading_page.dart';

import 'package:hive/hive.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../bases/detailed_product_base.dart';
import '../bases/hive_base.dart';
import '../common/custom_alert_dialog.dart';
import '../consts/consts.dart';
import '../consts/human_readable_date.dart';
import '../db/db.dart';

class ProductDetailPage extends StatefulWidget {
  final List<DetailedProduct>? products;

  const ProductDetailPage({Key? key, required this.products}) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  bool _following = false;
  Database _database = Database();
  Box<HiveUser> _userBox = Hive.box<HiveUser>(localDB);
  bool _loading = true;
  bool _increase = true;
  List<DetailedProduct>? _reversedList=[];

  @override
  void initState() {
    super.initState();
    _checkFollowing();
  }

  _checkFollowing() async {
    _following = await _database.checkFollowing(widget.products!.first.barcode, _userBox.get(localDB)!.username);
    Future.delayed(Duration(seconds: 2), () {
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
              title: Text(
                widget.products!.first.name,
              ),
              actions: [
                _increase
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 10, 10),
                        child: IconButton(
                          onPressed: () {
                            _reversedList!.clear();
                           _reversedList=new List.from(widget.products!.reversed);
                           print(_reversedList!.first.price);
                            setState(() {
                              _increase = false;
                            });
                          },
                          icon: Icon(
                            Icons.arrow_circle_up_outlined,
                            color: Colors.white,
                            size: 33,
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 10, 10),
                        child: IconButton(
                          onPressed: () {
                            _reversedList!.clear();
                            _reversedList=new List.from(_reversedList!.reversed);
                            setState(() {
                              _increase = true;
                            });
                          },
                          icon: Icon(
                            Icons.arrow_circle_down_outlined,
                            color: Colors.white,
                            size: 33,
                          ),
                        ),
                      )
              ],
            ),
            body: Column(
              children: [
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 15,
                      child: Container(
                        height: size.height * 0.2,
                        width: size.width * 0.99,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.lightBlueAccent.shade200,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //Image
                            Container(
                              height: size.height * 0.13,
                              width: size.width * 0.25,
                              child: CircleAvatar(
                                backgroundColor:
                                    Colors.lightBlueAccent.shade200,
                                radius: size.width * 0.2,
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: CircleAvatar(
                                    radius: size.width * 0.22,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: NetworkImage(
                                      widget.products!.first.image!,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            //Price and details
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      widget.products!.first.name,
                                      style: TextStyle(
                                        fontSize: 21,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => _approveFollow(_following,
                                          widget.products!.first.barcode),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                Colors.lightBlueAccent.shade200,
                                          ),
                                          height: size.height * 0.1,
                                          width: size.width * 0.1,
                                          child: _following == false
                                              ? Icon(
                                                  Icons.add_box_rounded,
                                                  color: Colors.white,
                                                )
                                              : Icon(
                                                  Icons
                                                      .assignment_turned_in_rounded,
                                                  color: Colors.white,
                                                ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Text(
                                  "Barkod: " + widget.products!.first.barcode,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    widget.products!.first.price.toString() +
                                        " ₺ - " +
                                        widget.products!.last.price.toString() +
                                        " ₺",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    width: size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(width: 1.25),
                      color: Colors.lightBlueAccent.shade100,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Marketler",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                _markets(),
              ],
            ),
          )
        : LoadingPage();
  }

  Widget _markets() {
    return _reversedList!.isEmpty?Expanded(
      child: Container(
        child: new Padding(
          padding: new EdgeInsets.only(top: 10.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Expanded(
                child: ListView.builder(
                  itemCount: widget.products!.length,
                  itemBuilder: (context, index) {
                    return new ListTile(
                      title: new Column(
                        children: <Widget>[
                          new Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Container(
                                height: 72.0,
                                width: 72.0,
                                decoration: new BoxDecoration(
                                  color: Colors.lightBlueAccent.shade100,
                                  boxShadow: [
                                    new BoxShadow(
                                        color: Colors.black.withAlpha(70),
                                        offset: const Offset(2.0, 2.0),
                                        blurRadius: 2.0)
                                  ],
                                  borderRadius: new BorderRadius.all(
                                    new Radius.circular(12.0),
                                  ),
                                  image: new DecorationImage(
                                    image: new ExactAssetImage(
                                      'images/markets/${widget.products![index].market}.png',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              new SizedBox(
                                width: 8.0,
                              ),
                              new Expanded(
                                  child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: new Text(
                                            widget.products![index].name,
                                            style: new TextStyle(
                                              fontSize: 17.0,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: new Text(
                                            widget.products![index].price
                                                    .toString() +
                                                " ₺",
                                            style: new TextStyle(
                                                fontSize: 17.0,
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0),
                                              child: new Text(
                                                "Kullanıcı: ",
                                                style: new TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                            new Text(
                                              widget.products![index].user,
                                              style: new TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 4.0),
                                          child: new Text(
                                            humanReadableDate(widget
                                                .products![index].priceDate!),
                                            style: new TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                            ],
                          ),
                          new Divider(
                            thickness: 2,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ):Expanded(
      child: Container(
        child: new Padding(
          padding: new EdgeInsets.only(top: 10.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Expanded(
                child: ListView.builder(
                  itemCount: _reversedList!.length,
                  itemBuilder: (context, index) {
                    return new ListTile(
                      title: new Column(
                        children: <Widget>[
                          new Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Container(
                                height: 72.0,
                                width: 72.0,
                                decoration: new BoxDecoration(
                                  color: Colors.lightBlueAccent.shade100,
                                  boxShadow: [
                                    new BoxShadow(
                                        color: Colors.black.withAlpha(70),
                                        offset: const Offset(2.0, 2.0),
                                        blurRadius: 2.0)
                                  ],
                                  borderRadius: new BorderRadius.all(
                                    new Radius.circular(12.0),
                                  ),
                                  image: new DecorationImage(
                                    image: new ExactAssetImage(
                                      'images/markets/${_reversedList![index].market}.png',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              new SizedBox(
                                width: 8.0,
                              ),
                              new Expanded(
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: new Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 8.0),
                                              child: new Text(
                                                _reversedList![index].name,
                                                style: new TextStyle(
                                                  fontSize: 17.0,
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 8.0),
                                              child: new Text(
                                                _reversedList![index].price
                                                    .toString() +
                                                    " ₺",
                                                style: new TextStyle(
                                                    fontSize: 17.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.normal),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: new Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 10.0),
                                                  child: new Text(
                                                    "Kullanıcı: ",
                                                    style: new TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.black87,
                                                      fontWeight: FontWeight.normal,
                                                    ),
                                                  ),
                                                ),
                                                new Text(
                                                  _reversedList![index].user,
                                                  style: new TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold),
                                                )
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(right: 4.0),
                                              child: new Text(
                                                humanReadableDate(_reversedList![index].priceDate!),
                                                style: new TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.normal),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                          new Divider(
                            thickness: 2,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _followProduct(String barcode) async {
    await _database.followProduct(barcode, _userBox.get(localDB)!.username);
    setState(() {
      _following = true;
    });
    customAlertDialog(context, "İşlem Başarılı",
        "Ürünü başarıyla takip ettiniz ", AlertType.success);
  }

  _unfollowProduct(String barcode) async {
    await _database.unfollowProduct(barcode, _userBox.get(localDB)!.username);
    setState(() {
      _following = false;
    });

    customAlertDialog(context, "İşlem Başarılı",
        "Ürünü başarıyla takipten çıkardınız", AlertType.success);
  }

  _approveFollow(bool following, String barcode) async {
    if (following) {
      await Alert(
          context: context,
          title: "Onay",
          desc: "Ürünü takipten çıkaracaksıınız!",
          type: AlertType.warning,
          buttons: [
            DialogButton(
              child: Text("Geri Dön"),
              onPressed: () => Navigator.pop(context),
              color: Colors.greenAccent,
            ),
            DialogButton(
              child: Text("Takibi Bırak"),
              onPressed: () {
                Navigator.pop(context);
                _unfollowProduct(barcode);
              },
              color: Colors.red,
            ),
          ]).show();
    } else {
      await Alert(
          context: context,
          title: "Onay",
          desc: "Ürünü takip edeceksiniz!",
          type: AlertType.warning,
          buttons: [
            DialogButton(
              child: Text("Geri Dön"),
              onPressed: () => Navigator.pop(context),
              color: Colors.greenAccent,
            ),
            DialogButton(
              child: Text("Takip Et"),
              onPressed: () {
                Navigator.pop(context);
                _followProduct(barcode);
              },
              color: Colors.lightBlueAccent.shade200,
            ),
          ]).show();
    }
  }
}
