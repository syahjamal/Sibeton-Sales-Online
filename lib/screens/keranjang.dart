import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_ecommerce/utils/loading.dart';
import 'package:flutter_ecommerce/utils/preferences.dart';

class Keranjang extends StatefulWidget {
  @override
  _KeranjangState createState() => _KeranjangState();
}

PreferenceUtil appData = new PreferenceUtil();

class _KeranjangState extends State<Keranjang> {
  final format = new NumberFormat("#,###");
  String userId = '';
  // TextEditingController jumlahController = TextEditingController();

  getData() async {
    appData.getVariable("user_id").then((result) {
      setState(() {
        userId = result;
        print(userId);
        Firestore.instance
            .collection('baskets')
            .document('BASKET' + userId)
            .get()
            .then((onValue) {
          print(onValue.data['email']);
        });
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

  Widget _buildListItem(BuildContext context, Map<dynamic, dynamic> document) {
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    TextEditingController jumlahController =
        new TextEditingController.fromValue(
      TextEditingValue(
        text: document['jumlah_pesanan'].toString(),
        selection: new TextSelection.collapsed(
          offset: document['jumlah_pesanan'].toString().length,
        ),
      ),
    );
    return Column(
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // checbox buat ceklis keseluruhan
              Container(
                height: 80,
                width: 50,
                alignment: Alignment.center,
                child: Checkbox(
                  checkColor: Colors.white,
                  activeColor: Colors.red,
                  value: false,
                  onChanged: (bool val) {},
                ),
              ),

              // buat foto
              Expanded(
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: GestureDetector(
                            child: Container(
                              height: 80,
                              width: 80,
                              alignment: Alignment.center,
                              child: FadeInImage.assetNetwork(
                                placeholder: 'assets/images/background.png',
                                image: document['foto'],
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: 70,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      // buat nama produk dan harga
                                      Container(
                                        child: Text(
                                          document['nama'] != null
                                              ? document['nama'].toString()
                                              : "-",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        child: Text(
                                          document['harga_total_item'] != null
                                              ? "Rp." +
                                                  format
                                                      .format(document[
                                                          'harga_total_item'])
                                                      .toString()
                                              : "Rp.-",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
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
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  // buat delete pake function remove
                },
                child: Container(
                  height: 30,
                  width: 30,
                  child: Icon(
                    Icons.delete,
                    size: 25,
                    color: Colors.grey[500],
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              GestureDetector(
                onTap: () {
                  // buat kurang pesanan
                },
                child: Container(
                  height: 30,
                  width: 30,
                  child: Icon(
                    Icons.remove,
                    size: 20,
                    color: Colors.white,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[500],
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.grey[400],
                        offset: new Offset(0.0, 1.0),
                      ),
                    ],
                  ),
                ),
              ),
              // jumlah pesanan
              Container(
                width: width * 1 / 6,
                height: 40,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  controller: jumlahController,
                  enabled: false,
                ),
              ),
              //  buat tambah pesanan
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: 30,
                  width: 30,
                  child: Icon(
                    Icons.add,
                    size: 20,
                    color: Colors.white,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[500],
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.grey[400],
                        offset: new Offset(0.0, 1.0),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
            ],
          ),
        ),
        Divider(
          height: 10.0,
          color: Colors.grey,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Keranjang'),
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance
              .collection('baskets')
              .document('BASKET' + userId)
              .snapshots(),
          builder: (context, snapshot) {
            var document = snapshot.data;
            if (!snapshot.hasData) {
              return Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red)));
            } else if (snapshot.data == null) {
              return Center(
                child: Text("Belanja Terlebih Dahulu"),
              );
            } else {
              document['item_pesanan'].sort((b, a) => Timestamp(
                      a['created_at_item'].seconds,
                      a['created_at_item'].nanoseconds)
                  .toDate()
                  .compareTo(Timestamp(b['created_at_item'].seconds,
                          b['created_at_item'].nanoseconds)
                      .toDate()));
              return new ListView.builder(
                itemCount: document['item_pesanan'].length,
                itemBuilder: (context, index) =>
                    _buildListItem(context, document['item_pesanan'][index]),
              );
            }
          },
        ));
  }
}

// cart

/*
Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Container(
                    height: 80,
                    width: 50,
                    alignment: Alignment.center,
                    child: Checkbox(
                      checkColor: Colors.white,
                      activeColor: Colors.red,
                      value: false,
                      onChanged: (bool val) {},
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: GestureDetector(
                              child: Container(
                                height: 80,
                                width: 80,
                                color: Colors.red,
                                alignment: Alignment.center,
                                // child: FadeInImage.assetNetwork(
                                //   placeholder: 'assets/images/shoppingbg.png',
                                //   image: item['gambar'],
                                //   fit: BoxFit.contain,
                                // ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    height: 70,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            "sibeton safsaojo fjsfsjo ojsoajfosaj osjafosfoj ojfso jofjaso",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.grey[700],
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          child: Text(
                                            "Rp.500,000",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
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
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 30,
                    width: 30,
                    child: Icon(
                      Icons.delete,
                      size: 25,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 30,
                    width: 30,
                    child: Icon(
                      Icons.remove,
                      size: 20,
                      color: Colors.white,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[500],
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        new BoxShadow(
                          color: Colors.grey[400],
                          offset: new Offset(0.0, 1.0),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: width * 1 / 6,
                  height: 40,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    controller: jumlahController,
                    enabled: false,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 30,
                    width: 30,
                    child: Icon(
                      Icons.add,
                      size: 20,
                      color: Colors.white,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[500],
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        new BoxShadow(
                          color: Colors.grey[400],
                          offset: new Offset(0.0, 1.0),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
          ),
        ],
      ),
*/
