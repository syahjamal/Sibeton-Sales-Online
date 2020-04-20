import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/utils/screenutil.dart';
import 'bukti_pembayaran.dart';

class KeranjangPembayaran extends StatefulWidget {
  KeranjangPembayaran({this.hargaTotal});
  final hargaTotal;
  @override
  _KeranjangPembayaranState createState() => _KeranjangPembayaranState();
}

class _KeranjangPembayaranState extends State<KeranjangPembayaran> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pembayaran'),
      ),
      body: Container(
        padding: EdgeInsets.all(ScreenUtil.getInstance().setWidth(55)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Toko",
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'PT-Sans-Regular',
                  fontSize: ScreenUtil.getInstance().setSp(50),
                )),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(
                  bottom: ScreenUtil.getInstance().setWidth(50),
                  top: ScreenUtil.getInstance().setWidth(20)),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.black26, width: 1))),
              child: Text("Toko Tani Karya",
                  style: TextStyle(
                      fontFamily: 'PT-Sans-Regular',
                      fontSize: ScreenUtil.getInstance().setSp(50),
                      letterSpacing: 0.5)),
            ),
            Text("Faktur yang akan dibayar",
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'PT-Sans-Regular',
                  fontSize: ScreenUtil.getInstance().setSp(50),
                )),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(
                bottom: ScreenUtil.getInstance().setWidth(50),
                top: ScreenUtil.getInstance().setWidth(20),
              ),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.black26, width: 1))),
              child: Text("INV-DGW-0307184123757",
                  style: TextStyle(
                      fontFamily: 'PT-Sans-Regular',
                      fontSize: ScreenUtil.getInstance().setSp(50),
                      letterSpacing: 0.5)),
            ),
            Text("Jumlah Faktur yang akan dibayar",
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'PT-Sans-Regular',
                  fontSize: ScreenUtil.getInstance().setSp(50),
                )),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(
                bottom: ScreenUtil.getInstance().setWidth(50),
                top: ScreenUtil.getInstance().setWidth(20),
              ),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.black26, width: 1))),
              child: Text("Rp 2.000.000",
                  style: TextStyle(
                      fontFamily: 'PT-Sans-Regular',
                      fontSize: ScreenUtil.getInstance().setSp(50),
                      letterSpacing: 0.5)),
            ),
            Text("Jenis Pembayaran",
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'PT-Sans-Regular',
                  fontSize: ScreenUtil.getInstance().setSp(50),
                )),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(
                bottom: ScreenUtil.getInstance().setWidth(50),
                top: ScreenUtil.getInstance().setWidth(20),
              ),
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.width / 4),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.black26, width: 1))),
              child: Text("Transfer",
                  style: TextStyle(
                      fontFamily: 'PT-Sans-Regular',
                      fontSize: ScreenUtil.getInstance().setSp(50),
                      letterSpacing: 0.5)),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(
                    top: ScreenUtil.getInstance().setWidth(10),
                    bottom: ScreenUtil.getInstance().setWidth(10)),
                width: MediaQuery.of(context).size.width / 1.10,
                child: MaterialButton(
                  padding: EdgeInsets.only(
                      top: ScreenUtil.getInstance().setWidth(40),
                      bottom: ScreenUtil.getInstance().setWidth(40)),
                  shape: StadiumBorder(),
                  color: Colors.green,
                  child: Text(
                    "KONFIRMASI PEMBAYARAN",
                    style: TextStyle(
                        fontFamily: 'PT-Sans-Regular',
                        letterSpacing: 0.5,
                        color: Colors.white,
                        fontSize: ScreenUtil.getInstance().setSp(50)),
                  ),
                  onPressed: () => _showAlert(),
                ),
              ),
            ),
            Center(
              child: FlatButton(
                child: Text(
                  "BATALKAN",
                  style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'PT-Sans-Regular',
                      letterSpacing: 0.5,
                      fontSize: ScreenUtil.getInstance().setSp(55)),
                ),
                onPressed: () {},
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showAlert() {
    AlertDialog alertDialog = new AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.all(0),
      content: new Container(
        decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(ScreenUtil.getInstance().setWidth(40)),
            color: Colors.white),
        height: MediaQuery.of(context).size.height / 1.7,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
                height: MediaQuery.of(context).size.height / 4,
                child:
                    new Image.asset("assets/images/pembayaran_berhasil.png")),
            Padding(
              padding:
                  EdgeInsets.only(top: ScreenUtil.getInstance().setWidth(50)),
              child: new Text(
                "Terima Kasih!",
                style: TextStyle(
                    fontFamily: 'PT-Sans-Bold',
                    color: Colors.red,
                    fontSize: ScreenUtil.getInstance().setSp(70)),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(ScreenUtil.getInstance().setWidth(20)),
              child: new Text(
                "Pembayaran Anda Telah di Proses",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'PT-Sans-Regular',
                    fontSize: ScreenUtil.getInstance().setSp(50)),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: ScreenUtil.getInstance().setWidth(50),
                  bottom: ScreenUtil.getInstance().setWidth(10)),
              width: MediaQuery.of(context).size.width / 2,
              child: MaterialButton(
                padding: EdgeInsets.only(
                    top: ScreenUtil.getInstance().setWidth(30),
                    bottom: ScreenUtil.getInstance().setWidth(30)),
                shape: StadiumBorder(),
                color: Colors.green,
                child: Text(
                  "SELANJUTNYA",
                  style: TextStyle(
                      fontFamily: 'PT-Sans-Regular',
                      letterSpacing: 0.5,
                      color: Colors.white,
                      fontSize: ScreenUtil.getInstance().setSp(50)),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BuktiPembayaran()));
                },
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(
      context: context,
      child: alertDialog,
    );
  }
}
