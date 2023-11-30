import 'package:coffeeya/core/config/constant.dart';
import 'package:coffeeya/core/widgets/notification/toast.dart';
import 'package:flutter/material.dart';

class NotificationNotify extends ChangeNotifier {
  String? _message;
  String? get message => _message;
  ToastPosition? _position;
  ToastPosition? get position => _position;
  ToastType? _type;
  ToastType? get type => _type;
  ToastStatus? _status;
  ToastStatus? get status => _status;

  void notify({
    required String message,
    ToastPosition position = ToastPosition.bottomLeft,
    ToastType type = ToastType.message,
    ToastStatus status = ToastStatus.info,
  }) {
    _message = message;
    _position = position;
    _type = type;
    _status = status;
    notifyListeners();
  }
}

final NotificationNotify notificationNotify = NotificationNotify();

void toast({
  required String message,
  ToastPosition position = ToastPosition.bottomLeft,
  ToastType type = ToastType.message,
  ToastStatus status = ToastStatus.info,
}) {
  // notificationNotify.notify(
  //   message: message,
  //   position: position,
  //   type: type,
  //   status: status,
  // );
  //todo : Global Context bayad pack beshe ,
  if (Global.context != null) {
    Toast().show(context: Global.context!, message: message);
  }
}
