import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class WillPopScopeRoute extends StatefulWidget {
  final AsyncValueGetter<bool> onBack;

  const WillPopScopeRoute({super.key,required this.onBack});

  @override
  WillPopScopeTestRouteState createState() {
    return WillPopScopeTestRouteState();
  }
}

class WillPopScopeTestRouteState extends State<WillPopScopeRoute> {
  DateTime? _lastPressedAt; //上次点击时间

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var back = await widget.onBack();
        if(back){
          if (_lastPressedAt == null || DateTime.now().difference(_lastPressedAt!) > const Duration(seconds: 1)) {
            //两次点击间隔超过1秒则重新计时
            _lastPressedAt = DateTime.now();
            return false;
          }
          return true;
        }else{
          return false;
        }
      },
      child: Container(),
    );
  }
}