import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_ecommerce/utils/screenutil.dart';

class SibWidget {
  static Widget sibDialogButton(
      {String buttonText = '', Function onPressed}) {
    return FlatButton(
        child: Text(buttonText),
        onPressed: onPressed != null ? onPressed : () {});
  }

  static sibDialog(
      {@required BuildContext context,
      @required String title,
      @required String content,
      List<Widget> buttons,
      bool isDismissible = true}) {
    showGeneralDialog(
        context: context,
        barrierDismissible: isDismissible,
        transitionDuration: Duration(milliseconds: 150),
        barrierLabel: '',
        barrierColor: Colors.black.withOpacity(0.6),
        pageBuilder: (context, animation1, animation2) {
          return Container();
        },
        transitionBuilder: (BuildContext context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: SibDialog(
                title: Text(title, textAlign: TextAlign.center),
                content: Text(
                  content,
                ),
                buttonActions: buttons != null ? buttons : Container(),
              ),
            ),
          );
        });
  }

  static loadingPageIndicator(
      {@required BuildContext context,
      String loadingText,
      double loadingSize = 30}) {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        transitionDuration: Duration(milliseconds: 100),
        barrierLabel: '',
        barrierColor: Colors.black.withOpacity(0.6),
        pageBuilder: (context, animation1, animation2) {
          return Container();
        },
        transitionBuilder: (BuildContext context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
                opacity: a1.value,
                child: LoadingIndicator(
                  loadingText: loadingText != null ? loadingText : '',
                  loadingSize: loadingSize,
                )),
          );
        });
  }
}

class LoadingIndicator extends StatelessWidget {
  final String loadingText;
  final double loadingSize;
  LoadingIndicator({this.loadingText, this.loadingSize});

  Future<bool> _onWillPop() {
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      allowFontScaling: true,
    )..init(context);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: loadingText != ''
          ? Center(
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SpinKitFadingCircle(
                      size: loadingSize,
                      itemBuilder: (BuildContext context, int index) {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            color: index.isEven ? Colors.red : Colors.red,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 10.0),
                    Text(loadingText)
                  ],
                ),
              ),
            )
          : Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  dialogContent(context),
                ],
              ),
            ),
    );
  }

  dialogContent(BuildContext context) {
    return Center(
      child: Container(
          width: ScreenUtil().setWidth(150),
          height: ScreenUtil().setHeight(150),
          decoration: new BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Theme(
            data: Theme.of(context).copyWith(accentColor: Colors.red),
            child: SpinKitFadingCircle(
              size: loadingSize,
              itemBuilder: (BuildContext context, int index) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: index.isEven ? Colors.red : Colors.red,
                  ),
                );
              },
            ),
          )),
    );
  }
}

class SibDialog extends StatelessWidget {
  final Widget title, content;
  final List<Widget> buttonActions;

  SibDialog({
    this.title,
    @required this.content,
    this.buttonActions,
  });

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      allowFontScaling: true,
    )..init(context);

    return AlertDialog(
        title: title != null ? title : Container(),
        content: content,
        backgroundColor: Colors.white.withOpacity(0.9),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        actions: buttonActions != null ? buttonActions : <Widget>[]);
  }
}
