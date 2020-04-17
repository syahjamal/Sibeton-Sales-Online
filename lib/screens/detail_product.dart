import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_ecommerce/utils/loading.dart';
import 'package:flutter_ecommerce/utils/preferences.dart';

class DetailProduk extends StatefulWidget {
  DetailProduk({this.productId});
  final productId;
  @override
  _DetailProdukState createState() => _DetailProdukState();
}

PreferenceUtil appData = new PreferenceUtil();

class _DetailProdukState extends State<DetailProduk> {
  final format = new NumberFormat("#,###");
  int current = 0, index = 0;
  String namaProduk = '', deskripsiProduk = '', userId = '', email = '';
  List fotoProduk;
  int hargaProduk = 0, hargaGetTotalProduk;
  List<Map> shoppingItems;
  List<Map> getShoppingItems;
  List<Map> postShoppingItems;
  List<dynamic> checkIdProduk;
  bool checkBasketUser = true;

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  outFocus() {
    FocusScope.of(context).requestFocus(FocusNode());
    SibWidget.loadingPageIndicator(context: context);
  }

  getData() async {
    Firestore.instance
        .collection('products')
        .document(widget.productId)
        .get()
        .then((onValue) {
      setState(() {
        shoppingItems = [
          {
            'created_at_item': DateTime.now(),
            'id_produk': widget.productId,
            'foto': onValue.data['foto'][0],
            'nama': onValue.data['nama'],
            'harga': onValue.data['harga'],
            'jumlah_pesanan': 1,
            'harga_total_item': onValue.data['harga'],
          }
        ];
        hargaProduk = onValue.data['harga'];
      });
    });
    appData.getVariable("user_id").then((result) {
      setState(() {
        userId = result;
        checkBasket();
      });
    });
    appData.getVariable("email").then((result) {
      setState(() {
        email = result;
      });
    });
  }

  assignDataToVar() async {
    await getData();
  }

  void initState() {
    super.initState();
    assignDataToVar();
  }

  addToBaskets() {
    Firestore.instance
        .collection('baskets')
        .document('BASKET' + userId)
        .setData({
      'user_id': userId,
      'created_at': DateTime.now(),
      'email': email,
      'harga_total': hargaProduk,
      'status_basket': "ada",
      'item_pesanan': shoppingItems,
    }).whenComplete(() {
      Navigator.of(context).pop();
    });
  }

  updateBasket() {
    bool idProduk = false;
    int indexIdproduk;
    for (int i = 0; i < checkIdProduk.length; i++) {
      if (checkIdProduk[i]['id_produk'] == widget.productId) {
        idProduk = true;
        indexIdproduk = i;
      }
    }

    if (idProduk == false) {
      // jika id_produk belum ada
      int hargaTot;
      hargaTot = hargaGetTotalProduk + hargaProduk;
      Firestore.instance
          .collection('baskets')
          .document('BASKET' + userId)
          .updateData({
        'harga_total': hargaTot,
        'item_pesanan': FieldValue.arrayUnion(shoppingItems),
      }).whenComplete(() {
        Navigator.of(context).pop();
      });
    } else {
      // jika id_produk sudah ada dan otomatis harus nambah
      int hargaTot, hargaTotItem, jumlahPesanan;
      hargaTotItem =
          checkIdProduk[indexIdproduk]['harga_total_item'] + hargaProduk;
      hargaTot = hargaGetTotalProduk + hargaProduk;
      jumlahPesanan = checkIdProduk[indexIdproduk]['jumlah_pesanan'] + 1;
      getShoppingItems = [
        {
          'created_at_item': checkIdProduk[indexIdproduk]['created_at_item'],
          'id_produk': checkIdProduk[indexIdproduk]['id_produk'],
          'foto': checkIdProduk[indexIdproduk]['foto'],
          'nama': checkIdProduk[indexIdproduk]['nama'],
          'harga': checkIdProduk[indexIdproduk]['harga'],
          'jumlah_pesanan': checkIdProduk[indexIdproduk]['jumlah_pesanan'],
          'harga_total_item': checkIdProduk[indexIdproduk]['harga_total_item'],
        }
      ];
      postShoppingItems = [
        {
          'created_at_item': checkIdProduk[indexIdproduk]['created_at_item'],
          'id_produk': checkIdProduk[indexIdproduk]['id_produk'],
          'foto': checkIdProduk[indexIdproduk]['foto'],
          'nama': checkIdProduk[indexIdproduk]['nama'],
          'harga': checkIdProduk[indexIdproduk]['harga'],
          'jumlah_pesanan': jumlahPesanan,
          'harga_total_item': hargaTotItem,
        }
      ];

      Firestore.instance
          .collection('baskets')
          .document('BASKET' + userId)
          .updateData({
        'item_pesanan': FieldValue.arrayRemove(getShoppingItems),
      });
      Firestore.instance
          .collection('baskets')
          .document('BASKET' + userId)
          .updateData({
        'harga_total': hargaTot,
        'item_pesanan': FieldValue.arrayUnion(postShoppingItems),
      }).whenComplete(() {
        Navigator.of(context).pop();
      });
    }
  }

  checkBasket() {
    Firestore.instance
        .collection('baskets')
        .document('BASKET' + userId)
        .get()
        .then((onValue) {
      if (onValue.data.length > 0) {
        setState(() {
          checkBasketUser = false;
          checkIdProduk = onValue.data['item_pesanan'];
          hargaGetTotalProduk = onValue.data['harga_total'];
        });
      }
    }).catchError((e) {
      print(e);
    });
  }

  Widget _showButton() {
    return new Padding(
      padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      child: Row(
        children: <Widget>[
          Container(
            height: 45,
            width: (MediaQuery.of(context).size.width * 0.5) - 20.0,
            child: RaisedButton(
                elevation: 10.0,
                color: Colors.white,
                textColor: Colors.white,
                child: Center(
                  child: Text('Check',
                      textAlign: TextAlign.center,
                      style: new TextStyle(fontSize: 18.0, color: Colors.red)),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed('/keranjang');
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0))),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0),
            height: 45,
            width: (MediaQuery.of(context).size.width * 0.5) - 20.0,
            child: RaisedButton(
                elevation: 10.0,
                color: Colors.red,
                textColor: Colors.white,
                child: Center(
                  child: Text('+ Keranjang',
                      textAlign: TextAlign.center,
                      style:
                          new TextStyle(fontSize: 18.0, color: Colors.white)),
                ),
                onPressed: () {
                  outFocus();

                  if (checkBasketUser == true) {
                    addToBaskets();
                  } else {
                    checkBasket();
                    updateBasket();
                  }
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance
              .collection('products')
              .document(widget.productId)
              .snapshots(),
          builder: (context, snapshot) {
            var document = snapshot.data;
            // fotoProduk = document['foto'];
            if (!snapshot.hasData) {
              return Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red)));
            } else {
              fotoProduk = document['foto'];
              return ListView(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: CarouselSlider(
                              height: 300,
                              initialPage: 0,
                              enableInfiniteScroll: false,
                              autoPlay: false,
                              enlargeCenterPage: true,
                              viewportFraction: 1.0,
                              aspectRatio:
                                  MediaQuery.of(context).size.aspectRatio,
                              scrollDirection: Axis.horizontal,
                              onPageChanged: (index) {
                                setState(() {
                                  current = index;
                                });
                              },
                              items: fotoProduk.map((imgAssets) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          image: DecorationImage(
                                            image: NetworkImage(imgAssets),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                          // bulat kecil
                          Positioned(
                            top: 270,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    children:
                                        map<Widget>(fotoProduk, (index, url) {
                                      return Container(
                                        width: 10.0,
                                        height: 10.0,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 2.0),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: current == index
                                              ? Colors.red
                                              : Colors.white,
                                        ),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(12.0, 15.0, 12.0, 2.0),
                        child: Text(
                          document['nama'].toString(),
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 10.0),
                        child: Text(
                          "Rp." + format.format(document['harga']).toString() + " \\m3",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Divider(
                        height: 10.0,
                        color: Colors.grey,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(12.0, 5.0, 12.0, 2.0),
                        child: Text(
                          "Informasi Produk",
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // berat
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(12.0, 2.0, 12.0, 2.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Berat',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Text(
                                  ' gram',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                            // kondisi
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Kondisi',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Text(
                                  'baru',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                            // pemesanan
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Pemesanan',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Text(
                                  'minimal 3 m3',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(12.0, 5.0, 12.0, 2.0),
                        child: Text(
                          "Deskripsi Produk",
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // deskripsi
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(12.0, 2.0, 12.0, 2.0),
                        child: Text(
                          document['deskripsi'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
          }),
      bottomNavigationBar: _showButton(),
    );
  }
}
