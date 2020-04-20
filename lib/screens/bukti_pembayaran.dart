import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/main.dart';
import 'package:flutter_ecommerce/utils/screenutil.dart';

class BuktiPembayaran extends StatefulWidget {
  @override
  _BuktiPembayaranState createState() => _BuktiPembayaranState();
}

class _BuktiPembayaranState extends State<BuktiPembayaran> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFD92631),
        title: Text(
          "Bukti Pembayaran",
          style: TextStyle(
              fontFamily: 'PT-Sans-Bold',
              color: Colors.white,
              letterSpacing: 0.5),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(
                  ScreenUtil.getInstance().setWidth(80),
                  ScreenUtil.getInstance().setWidth(50),
                  ScreenUtil.getInstance().setWidth(80),
                  ScreenUtil.getInstance().setWidth(50)),
              color: Colors.grey[350],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Balance Toko",
                    style: TextStyle(
                        fontSize: ScreenUtil.getInstance().setSp(45),
                        fontFamily: 'PT-Sans-Regular',
                        letterSpacing: 0.5,
                        color: Colors.black),
                  ),
                  Text(
                    "Rp 3.694.000",
                    style: TextStyle(
                      fontSize: ScreenUtil.getInstance().setSp(45),
                      fontFamily: 'PT-Sans-Bold',
                      letterSpacing: 0.5,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                left: ScreenUtil.getInstance().setWidth(80),
                top: ScreenUtil.getInstance().setWidth(50),
                right: ScreenUtil.getInstance().setWidth(80),
              ),
              child: toko(),
            ),
            Container(
              padding: EdgeInsets.only(
                left: ScreenUtil.getInstance().setWidth(80),
                right: ScreenUtil.getInstance().setWidth(80),
              ),
              child: pembayaran(),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: ScreenUtil.getInstance().setWidth(60),
                  bottom: ScreenUtil.getInstance().setWidth(10)),
              width: MediaQuery.of(context).size.width / 1.10,
              child: MaterialButton(
                padding: EdgeInsets.only(
                    top: ScreenUtil.getInstance().setWidth(40),
                    bottom: ScreenUtil.getInstance().setWidth(40)),
                shape: StadiumBorder(),
                color: Colors.green,
                child: Text(
                  "PRINT BUKTI PEMBAYARAN",
                  style: TextStyle(
                      fontFamily: 'PT-Sans-Regular',
                      letterSpacing: 0.5,
                      color: Colors.white,
                      fontSize: ScreenUtil.getInstance().setSp(50)),
                ),
                onPressed: () {},
              ),
            ),
            FlatButton(
              padding: EdgeInsets.only(
                  top: ScreenUtil.getInstance().setWidth(30),
                  bottom: ScreenUtil.getInstance().setWidth(50)),
              child: Text(
                "SELESAI",
                style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'PT-Sans-Regular',
                    letterSpacing: 0.5,
                    fontSize: ScreenUtil.getInstance().setSp(55)),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyApp()));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget toko() {
    return Card(
      margin: EdgeInsets.only(
        top: ScreenUtil.getInstance().setWidth(40),
        bottom: ScreenUtil.getInstance().setWidth(40),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.red, width: 2),
              ),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: ScreenUtil.getInstance().setWidth(100),
                  margin: EdgeInsets.fromLTRB(
                    ScreenUtil.getInstance().setWidth(70),
                    ScreenUtil.getInstance().setWidth(40),
                    ScreenUtil.getInstance().setWidth(70),
                    ScreenUtil.getInstance().setWidth(40),
                  ),
                  child: Image.asset("assets/icons/icon_new_store.png"),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: ScreenUtil.getInstance().setWidth(20),
                  ),
                  child: Text(
                    "Toko Tani Karya",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontFamily: 'PT-Sans-Bold',
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsetsDirectional.only(
              start: ScreenUtil.getInstance().setWidth(70),
              top: ScreenUtil.getInstance().setWidth(30),
              end: ScreenUtil.getInstance().setWidth(70),
            ),
            child: Text(
              "Desa Loh Bener Indramayu",
              style: TextStyle(
                fontFamily: 'PT-Sans-Regular',
                fontSize: 18,
              ),
            ),
          ),
          Container(
            margin: EdgeInsetsDirectional.only(
              start: ScreenUtil.getInstance().setWidth(70),
              top: ScreenUtil.getInstance().setWidth(20),
              end: ScreenUtil.getInstance().setWidth(70),
              bottom: ScreenUtil.getInstance().setWidth(50),
            ),
            child: Text(
              "082316312199",
              style: TextStyle(
                fontFamily: 'PT-Sans-Regular',
                fontSize: 18,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget pembayaran() {
    return Card(
      margin: EdgeInsets.only(
        top: ScreenUtil.getInstance().setWidth(40),
        bottom: ScreenUtil.getInstance().setWidth(40),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.red, width: 2),
              ),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: ScreenUtil.getInstance().setWidth(80),
                  margin: EdgeInsets.fromLTRB(
                    ScreenUtil.getInstance().setWidth(70),
                    ScreenUtil.getInstance().setWidth(40),
                    ScreenUtil.getInstance().setWidth(70),
                    ScreenUtil.getInstance().setWidth(40),
                  ),
                  child: Image.asset("assets/icons/icon_pesanan.png"),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: ScreenUtil.getInstance().setWidth(20),
                  ),
                  child: Text(
                    "PAY0307184118159",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontFamily: 'PT-Sans-Bold',
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
                ScreenUtil.getInstance().setWidth(50),
                ScreenUtil.getInstance().setWidth(20),
                ScreenUtil.getInstance().setWidth(50),
                ScreenUtil.getInstance().setWidth(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Tanggal",
                  style: TextStyle(
                    fontFamily: 'PT-Sans-Regular',
                    fontSize: 18,
                  ),
                ),
                Text(
                  "03/07/2018 13:43:32",
                  style: TextStyle(
                    fontFamily: 'PT-Sans-Bold',
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
                ScreenUtil.getInstance().setWidth(50),
                ScreenUtil.getInstance().setWidth(20),
                ScreenUtil.getInstance().setWidth(50),
                ScreenUtil.getInstance().setWidth(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Jenis Pembayaran",
                  style: TextStyle(
                    fontFamily: 'PT-Sans-Regular',
                    fontSize: 18,
                  ),
                ),
                Text(
                  "Transfer",
                  style: TextStyle(
                    fontFamily: 'PT-Sans-Bold',
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
                ScreenUtil.getInstance().setWidth(50),
                ScreenUtil.getInstance().setWidth(20),
                ScreenUtil.getInstance().setWidth(50),
                ScreenUtil.getInstance().setWidth(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Total Pembayaran",
                  style: TextStyle(
                    fontFamily: 'PT-Sans-Regular',
                    fontSize: 18,
                  ),
                ),
                Text(
                  "Rp 2.000.000",
                  style: TextStyle(
                    fontFamily: 'PT-Sans-Bold',
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(ScreenUtil.getInstance().setWidth(50)),
            margin: EdgeInsets.all(ScreenUtil.getInstance().setWidth(20)),
            decoration: BoxDecoration(
                border:
                    Border(top: BorderSide(color: Colors.black26, width: 1))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Status",
                  style: TextStyle(
                    color: Colors.green,
                    fontFamily: 'PT-Sans-Regular',
                    fontSize: 18,
                  ),
                ),
                Text(
                  "LUNAS",
                  style: TextStyle(
                    color: Colors.green,
                    fontFamily: 'PT-Sans-Bold',
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}