import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_ecommerce/utils/preferences.dart';
import 'package:flutter_ecommerce/utils/loading.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_ecommerce/models/list_bank.dart';
import 'package:flutter_ecommerce/screens/keranjang_verifikasi_pembayaran.dart';
import 'package:flutter/services.dart';

class KonfirmasiPembayaran extends StatefulWidget {
  KonfirmasiPembayaran({this.orderID});
  final orderID;
  @override
  _KonfirmasiPembayaranState createState() => _KonfirmasiPembayaranState();
}

PreferenceUtil appData = new PreferenceUtil();
int jumlahPembayaran;

class _KonfirmasiPembayaranState extends State<KonfirmasiPembayaran> {
  final format = DateFormat("dd-MM-yyyy");
  final _formKey = GlobalKey<FormState>();
  var thumbnail, url;
  bool status = false, imageStatus = true;
  DateTime _tanglah = DateTime.now();
  String userId = '', bankTujuan, filename = '', foto = '', detik = '';
  File image, kirimImage;
  DateTime tglBayar;

  TextEditingController namaRekeningController = TextEditingController();
  TextEditingController jumlahPembayaranController = TextEditingController();
  TextEditingController pesanTambahanController = TextEditingController();

  getData() async {
    appData.getVariable("user_id").then((result) {
      setState(() {
        userId = result;
        print(userId);
      });
    });
  }

  Future _getImage(BuildContext context) async {
    var selectedImage = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      detik = DateFormat("hhmmss").format(_tanglah).toString();
      image = selectedImage;
      filename = userId + detik + "foto_user.jpg";
      status = true;
    });
    if (selectedImage != null) {
      Navigator.pop(context);
    }
  }

  Future _getImageGallery(BuildContext context) async {
    var selectedImage =
        await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      detik = DateFormat("hhmmss").format(_tanglah).toString();
      image = selectedImage;
      filename = userId + detik + "foto_user.jpg";
      status = false;
    });
    if (selectedImage != null) {
      Navigator.pop(context);
    }
  }

  outFocus() {
    FocusScope.of(context).requestFocus(FocusNode());
    SibWidget.loadingPageIndicator(context: context);
  }

  assignDataToVar() async {
    await getData();
  }

  void initState() {
    super.initState();
    assignDataToVar();
  }

  addData() async {
    if (status == true) {
      var iemge = img.decodeImage(image.readAsBytesSync());
      thumbnail = img.copyResize(iemge, width: 360);
      File thumbnel = image..writeAsBytesSync(img.encodePng(thumbnail));
      kirimImage = thumbnel;
    } else {
      kirimImage = image;
    }
    String gambar = "konfirmasi-pembayarans/" + filename;
    StorageReference ref = FirebaseStorage.instance.ref().child(gambar);
    StorageUploadTask uploadTask = ref.putFile(kirimImage);

    var downUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    url = downUrl.toString();

    print(jumlahPembayaran.toString());

    await Firestore.instance
        .collection('verifikasi_pembayarans')
        .document()
        .setData({
      'created_at': DateTime.now(),
      'user_id': userId,
      'order_id': widget.orderID,
      'status': "konfirmasi",
      'bank_tujuan': bankTujuan,
      'nama_rekening': namaRekeningController.text ?? "",
      'jumlah_pembayaran': jumlahPembayaran,
      'tanggal_pembayaran': tglBayar,
      'pesan_tambahan': pesanTambahanController.text ?? "",
      'foto_pembayaran': url,
    }).whenComplete(() {
      Navigator.of(context).pop();
      SibWidget.sibDialog(
          context: context,
          title: 'Berhasil Disimpan',
          content: 'Perubahan berhasil disimpan',
          buttons: <Widget>[
            SibWidget.sibDialogButton(
                buttonText: 'Ok',
                onPressed: () async {
                  // di pop dulu baru di push replacementNamed
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => KeranjangVerifikasiPembayaran(
                        orderID: widget.orderID,
                      ),
                    ),
                  );
                })
          ]);
    });
  }

  Widget titleInput(title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 25, 15, 10),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Comfortaa',
            fontSize: 15.0,
          ),
        ),
      ),
    );
  }

  void showAlertDialog() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      builder: (builder) {
        return Container(
          height: 250.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(10.0),
              topRight: const Radius.circular(10.0),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 20.0),
                  width: 40.0,
                  height: 5.0,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 40.0, left: 20.0, bottom: 30.0),
                child: Text(
                  "Bukti Pembayaran",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: 'Comfortaa',
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  _getImage(context);
                },
                leading: Icon(Icons.photo_camera),
                title: Text(
                  "Ambil Foto dari Kamera",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'Comfortaa',
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.chevron_right),
                  ],
                ),
              ),
              ListTile(
                onTap: () {
                  _getImageGallery(context);
                },
                leading: Icon(Icons.photo_library),
                title: Text(
                  "Ambil Foto dari Galeri",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'Comfortaa',
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Konfirmasi Pembayaran")),
      body: ListView(
        children: <Widget>[
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  titleInput("Bank Tujuan"),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15, bottom: 10, right: 15),
                    child: DropdownButtonFormField(
                      isExpanded: true,
                      hint: new Text("Pilih Bank Tujuan"),
                      value: bankTujuan,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Comfortaa',
                      ),
                      items: listBanksTujuan
                          .map((label) => DropdownMenuItem(
                                child: Text(label.toString()),
                                value: label,
                              ))
                          .toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'Tidak boleh kosong';
                        }
                        return null;
                      },
                      onChanged: (key) {
                        setState(() {
                          bankTujuan = key;
                        });
                      },
                    ),
                  ),
                  titleInput("Nama Rekening Pengirim"),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15, bottom: 15, right: 15),
                    //Nama Rekening
                    child: TextFormField(
                        controller: namaRekeningController,
                        decoration: new InputDecoration(
                            hintStyle: new TextStyle(
                                color: Colors.grey[300],
                                fontFamily: 'Comfortaa',
                                fontSize: 15.0),
                            hintText: "Nama Rekening",
                            fillColor: Colors.white70),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Tidak boleh kosong';
                          }
                          return null;
                        }),
                  ),
                  titleInput("Jumlah Pembayaran"),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15, bottom: 15, right: 15),
                    //Nama Rekening
                    child: TextFormField(
                        controller: jumlahPembayaranController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,
                          CurrencyInputFormatter()
                        ],
                        decoration: new InputDecoration(
                            hintStyle: new TextStyle(
                                color: Colors.grey[300],
                                fontFamily: 'Comfortaa',
                                fontSize: 15.0),
                            hintText: "500,000",
                            fillColor: Colors.white70),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Tidak boleh kosong';
                          }
                          return null;
                        }),
                  ),
                  titleInput("Tanggal Pembayaran"),
                  Padding(
                    // tgl bayar
                    padding:
                        const EdgeInsets.only(left: 15, bottom: 15, right: 15),
                    child: DateTimeField(
                      format: format,
                      validator: (value) {
                        if (value == null) {
                          return 'Tidak boleh kosong';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: "12-05-2020",
                          hintStyle: new TextStyle(
                              color: Colors.grey[300],
                              fontFamily: 'Comfortaa',
                              fontSize: 15.0),
                          fillColor: Colors.white70),
                      onShowPicker: (context, currentValue) async {
                        final date = await showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100));
                        if (date != null) {
                          final time = TimeOfDay.now();
                          setState(() {
                            tglBayar = DateTimeField.combine(date, time);
                          });

                          return DateTimeField.combine(date, time);
                        } else {
                          return currentValue;
                        }
                      },
                    ),
                  ),
                  titleInput("Pesan Tambahan"),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15, bottom: 10, right: 15),
                    child: TextFormField(
                      controller: pesanTambahanController,
                      keyboardType: TextInputType.text,
                      maxLines: 3,
                      decoration: new InputDecoration(
                          hintStyle: new TextStyle(
                              color: Colors.grey[300],
                              fontFamily: 'Comfortaa',
                              fontSize: 15.0),
                          hintText: "opsional",
                          fillColor: Colors.white70),
                    ),
                  ),
                  titleInput("Bukti Transfer"),
                  Container(
                    padding:
                        const EdgeInsets.only(left: 15, bottom: 5, right: 15),
                    alignment: Alignment.centerLeft,
                    child: RaisedButton(
                      onPressed: () {
                        showAlertDialog();
                      },
                      child: Text("Browse"),
                    ),
                  ),
                  imageStatus == true
                      ? Container(
                          padding: const EdgeInsets.only(
                              left: 15, bottom: 10, right: 12),
                        )
                      : Container(
                          padding: const EdgeInsets.only(
                              left: 12.0, bottom: 10, right: 15),
                          alignment: Alignment.centerLeft,
                          child: Text("Foto tidak boleh kosong!",
                              style:
                                  TextStyle(color: Colors.red, fontSize: 12.0)),
                        ),
                  image == null
                      ? Container(
                          padding: const EdgeInsets.only(
                              left: 15, bottom: 40, right: 12),
                        )
                      : Container(
                          padding: const EdgeInsets.only(
                              left: 15, bottom: 40, right: 12),
                          alignment: Alignment.centerLeft,
                          child: Image.file(
                            image,
                            width: 300,
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                        ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 40.0),
            child: Container(
              height: 45,
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                  elevation: 10.0,
                  color: Colors.red,
                  textColor: Colors.white,
                  child: Center(
                    child: Text('Konfirmasi Pembayaran',
                        textAlign: TextAlign.center,
                        style:
                            new TextStyle(fontSize: 15.0, color: Colors.white)),
                  ),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      // ketika ada fungsi onsaved bisa langsung dipakai
                      // _formKey.currentState.save();
                      if (image != null) {
                        outFocus();
                        addData();
                      } else {
                        setState(() {
                          imageStatus = false;
                        });
                      }
                    }
                  },
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0))),
            ),
          ),
        ],
      ),
    );
  }
}

class DatePicker {}

class CurrencyInputFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    double value = double.parse(newValue.text);
    jumlahPembayaran = int.parse(newValue.text);
    final formatter = new NumberFormat("#,###");

    String newText = formatter.format(value);

    return newValue.copyWith(
        text: newText,
        selection: new TextSelection.collapsed(offset: newText.length));
  }
}

class BasicDateField extends StatelessWidget {
  final format = DateFormat("dd-MM-yyyy");
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Text('Basic date field (${format.pattern})'),
      DateTimeField(
        format: format,
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
        },
      ),
    ]);
  }
}
