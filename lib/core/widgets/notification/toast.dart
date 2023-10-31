import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum ToastPosition { topLeft, topRight, bottomLeft, bottomRight }

enum ToastType { notification, message }

enum ToastStatus { success, warning, danger, info }

class Toast {
  show({
    required BuildContext context,
    ToastPosition position = ToastPosition.bottomLeft,
    ToastType type = ToastType.message,
    ToastStatus status = ToastStatus.info,
    required message,
  }) {
    OverlayState overlayState = Overlay.of(context);
    OverlayEntry? entry;
    entry = OverlayEntry(
        builder: (context) => type == ToastType.notification
            ? const Positioned(
                bottom: 20,
                left: 20,
                child: NotificationWidget(),
              )
            : Positioned(
                top: 20,
                left: MediaQuery.of(context).size.width / 2 - 160,
                child: MessageWidget(status: status, message: message),
              ));
    overlayState.insert(entry);
    Future.delayed(
      const Duration(seconds: 2),
      () {
        entry?.remove();
        entry = null;
      },
    );
  }
}

class MessageWidget extends StatelessWidget {
  final ToastStatus status;
  final String message;

  const MessageWidget({Key? key, required this.status, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlideInDown(
      duration: const Duration(milliseconds: 150),
      child: Material(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(6)), color: Colors.white, boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.08),
              offset: Offset(0, 6),
              blurRadius: 16,
            ),
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.12),
              offset: Offset(0, 3),
              blurRadius: 6,
              spreadRadius: -4,
            ),
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.05),
              offset: Offset(0, 9),
              blurRadius: 28,
              spreadRadius: 8,
            )
          ]),
          child: Row(
            children: [
              if (status == ToastStatus.success)
                Icon(
                  Icons.check_circle,
                  color: Colors.green[600],
                ),
              if (status == ToastStatus.info)
                Icon(
                  Icons.info,
                  color: Colors.blue[600],
                ),
              if (status == ToastStatus.warning)
                Icon(
                  Icons.warning_rounded,
                  color: Colors.yellow[600],
                ),
              if (status == ToastStatus.danger)
                Icon(
                  Icons.dangerous_rounded,
                  color: Colors.red[600],
                ),
              const SizedBox(width: 6),
              Text(message),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlideInLeft(
      duration: const Duration(milliseconds: 150),
      child: Material(
        child: Container(
          padding: const EdgeInsets.all(16),
          width: 320,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(6)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.08),
                offset: Offset(0, 6),
                blurRadius: 16,
              ),
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.12),
                offset: Offset(0, 3),
                blurRadius: 6,
                spreadRadius: -4,
              ),
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.05),
                offset: Offset(0, 9),
                blurRadius: 28,
                spreadRadius: 8,
              )
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("عنوان اعلان", style: TextStyle(fontWeight: FontWeight.w600)),
                  Material(
                    color: Colors.white,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      onTap: () {
                        // entry?.remove();
                        // entry = null;
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: FaIcon(FontAwesomeIcons.xmark, color: Colors.grey[600], size: 15),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 12),
              const Text("شناخت بیشتری را برای طراحان رایانه ای علی الخصوص طراحان خلاقی، و فرهنگ پیشرو در زبان فارسی ایجاد کرد،")
            ],
          ),
        ),
      ),
    );
  }
}
