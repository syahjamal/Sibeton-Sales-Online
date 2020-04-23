import 'package:flutter/material.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat'),
      ),
      // Kayanya harus pake listview builder
      body: ListView(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.fromLTRB(12.0, 20.0, 12.0, 0.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      offset: const Offset(0.0, 5.0),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                ),
                child: Container(
                  color: Colors.green[200],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 3.0),
                        child: Text(
                          " Pesanan Selesai ",
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(12.0, 2.0, 12.0, 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: const Offset(0.0, 10.0),
                    ),
                  ],
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      leading: Text("Tanggal Transaksi :"),
                      title: Text("12/12/20"), //get data tanggal transaksi
                    ),
                    ListTile(
                      leading: Text("Nomor Transaksi :"),
                      title: Text("12345678910"), //get data nomor transaksi
                    ),
                    Divider(
                      height: 0.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 12.0, 12.0, 20.0),
                      //barang yang di pesan
                      child: ListTile(
                        leading: Image.asset(
                            "assets/google_logo.png"), // Gambar product
                        title: Text("ReadyMix"), //Nama Product
                        subtitle: Text("Rp. 600.000"), // Harga satuan
                      ),
                    ),
                    Divider(
                      height: 0.0,
                    ),
                    ListTile(
                      leading: Text("Total Pembelian :"),
                      title: Text("12345678910"), //Total harga
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
