import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ecommerce/providers/cart.dart' show Cart;
import 'package:flutter_ecommerce/providers/orders.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ecommerce/widgets/cart_item.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "/cart";

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Cart>(context);

    FlutterMoneyFormatter fmf = FlutterMoneyFormatter(
        amount: cart.totalAmount,
        settings: MoneyFormatterSettings(
            symbol: 'Rp',
            thousandSeparator: '.',
            decimalSeparator: ' ',
            symbolAndNumberSeparator: ' ',
            fractionDigits: 0,
            compactFormatType: CompactFormatType.short));
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 20.0),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      "${fmf.output.symbolOnLeft /*toStringAsFixed(2)*/}",
                      style: TextStyle(
                          color:
                              Theme.of(context).primaryTextTheme.title.color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (BuildContext context, int index) {
                return CartItem(
                    cart.items.values.toList()[index].id,
                    cart.items.keys.toList()[index],
                    cart.items.values.toList()[index].price,
                    cart.items.values.toList()[index].quanity,
                    cart.items.values.toList()[index].title);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  final Cart cart;

  OrderButton(this.cart);

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  String imagePath;
  Image image;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading ? CircularProgressIndicator() : Text("ORDER NOW"),
      textColor: Theme.of(context).primaryColor,
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Form(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(' Konfirmasi '),
                      ),
                      Padding(
                        padding: EdgeInsets.all(1.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              labelText: "Alamat Pengiriman",
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0))),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              labelText: "No Handphone",
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0))),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                              "Silahkan melakukan pembayaran ke no rekening, mandiri : 12345678")),
                      Padding(
                        padding: EdgeInsets.all(1.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              labelText: "Bukti Pembayaran",
                              hintText: "Upload Bukti Bayar",
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0))),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: new ListBody(children: <Widget>[
                          Container(child: image != null ? image : null),
                          GestureDetector(
                              child: Row(children: <Widget>[
                                Icon(Icons.camera),
                                SizedBox(width: 5),
                                Text('Ambil Foto'),
                              ]),
                              onTap: () async {
                                await getImageFromCamera();
                                setState(() {});
                              }),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                          ),
                        ]),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            color: Colors.green[200],
                            child: Text(
                              "Submit",
                            ),
                            onPressed: widget.cart.totalAmount <= 0 ||
                                    _isLoading
                                ? null
                                : () async {
                                  print(widget.cart.items.values.toList()[0].price);
                                    // setState(() {
                                    //   _isLoading = true;
                                    // });
                                    // await Provider.of<Orders>(context,
                                    //         listen: false)
                                    //     .addOrder(
                                    //         widget.cart.items.values.toList(),
                                    //         widget.cart.totalAmount);
                                    // widget.cart.clear();

                                    // setState(() {
                                    //   _isLoading = false;
                                    // });
                                  },
                          ))
                    ])),
              );
            });
      },
    );
  }

  Future getImageFromCamera() async {
    var x = await ImagePicker.pickImage(source: ImageSource.camera);
    imagePath = x.path;
    image = Image(image: FileImage(x));
  }
}
