import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailProduk extends StatefulWidget {
  DetailProduk({this.productId});
  final productId;
  @override
  _DetailProdukState createState() => _DetailProdukState();
}

class _DetailProdukState extends State<DetailProduk> {
  final format = new NumberFormat("#,###");
  int current = 0, index = 0;
  String namaProduk = '', deskripsiProduk = '';
  List fotoProduk;
  var hargaProduk;

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  getData() async {
    Firestore.instance
        .collection('products')
        .document(widget.productId)
        .get()
        .then((onValue) {
      namaProduk = onValue.data['nama'];
      deskripsiProduk = onValue.data['deskripsi'];
      hargaProduk = onValue.data['harga'];
    });
  }

  assignDataToVar() async {
    await getData();
  }

  void initState() {
    super.initState();
    // assignDataToVar();
  }

  Widget _showButton() {
    return new Padding(
      padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      child: Container(
        height: 45,
        width: MediaQuery.of(context).size.width,
        child: RaisedButton(
            elevation: 10.0,
            //color: Color(0xFF43A047),
            color: Colors.red,
            textColor: Colors.white,
            child: Center(
              child: Text('Tambah Ke Keranjang',
                  textAlign: TextAlign.center,
                  style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            ),
            onPressed: () {
              //create();
            },
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0))),
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
