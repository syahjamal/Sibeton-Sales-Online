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
      body: Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        height: 220,
        width: double.maxFinite,
        child: Card(
          elevation: 5,
          child: Padding(
            padding: EdgeInsets.all(7),
            child: Stack(children: <Widget>[
              Align(
                alignment: Alignment.centerRight,
                child: Stack(
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(left: 10, top: 5),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Stack(
                                      children: <Widget>[
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, top: 5),
                                            child: Column(
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    cryptoIcon(),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    cryptoNameSymbol(),
                                                    Spacer(),
                                                    cryptoChange(),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    changeIcon(),
                                                    SizedBox(
                                                      width: 20,
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    cryptoAmount()
                                                  ],
                                                )
                                              ],
                                            ))
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ))
                  ],
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}

Widget cryptoIcon() {
   return Padding(
     padding: const EdgeInsets.only(left: 15.0),
     child: Align(
         alignment: Alignment.centerLeft,
         child: Icon(
           Icons.money_off,
           color: Colors.amber,
           size: 40,
         )),
   );
 }
 Widget cryptoNameSymbol() {
   return Align(
     alignment: Alignment.centerLeft,
     child: RichText(
       text: TextSpan(
         text: 'Jumlah',
         style: TextStyle(
             fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
         children: <TextSpan>[
           TextSpan(
               text: '\nBTC',
               style: TextStyle(
                   color: Colors.grey,
                   fontSize: 15,
                   fontWeight: FontWeight.bold)),
         ],
       ),
     ),
   );
  }
Widget cryptoChange() {
  return Align(
    alignment: Alignment.topRight,
    child: RichText(
      text: TextSpan(
        text: '+3.67%',
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.green, fontSize: 20),
        children: <TextSpan>[
        TextSpan(
            text: '\n+202.835',
            style: TextStyle(
                color: Colors.green,
                fontSize: 15,
                fontWeight: FontWeight.bold)),
      ],
    ),
  ),
);
}

Widget changeIcon() {
  return Align(
      alignment: Alignment.topRight,
      child: Icon(
        Icons.arrow_drop_up,
        color: Colors.green,
        size: 30,
      ));
}
Widget cryptoAmount() {
  return Align(
    alignment: Alignment.centerLeft,
    child: Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Row(
        children: <Widget>[
          RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              text: '\n\$12.279',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 35,
              ),
              children: <TextSpan>[
                TextSpan(
                    text: '\n0.1349',
                    style: TextStyle(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    ),
  );
 }