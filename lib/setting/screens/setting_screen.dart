import 'package:coffeeya/core/config/color.dart';
import 'package:coffeeya/core/config/token.dart';
import 'package:coffeeya/core/layout/home/context.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeContextLayout(
      appBar: AppBar(
        title: const Text("مدیریت"),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 8,
            ),
            child: InkWell(
              hoverColor: Colors.transparent,
              onTap: () async {
                Token.logout();
                context.goNamed('auth');
              },
              child: Icon(
                Icons.logout,
                color: Colors.grey[400],
                size: 24,
              ),
            ),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: XColors.gray_1,
              borderRadius: BorderRadius.circular(4),
              boxShadow: const [
                BoxShadow(
                  color: XColors.gray_4,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 8,
            ),
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed("/tables");
                  },
                  title: Text(
                    "میز ها",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  leading: const FaIcon(
                    FontAwesomeIcons.table,
                    size: 20,
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: XColors.gray_8,
                    size: 20,
                  ),
                ),
                const Divider(
                  height: 8,
                  color: XColors.gray_4,
                ),
                ListTile(
                  title: Text(
                    "میز ها",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  leading: const FaIcon(
                    FontAwesomeIcons.table,
                    size: 20,
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: XColors.gray_8,
                    size: 20,
                  ),
                ),
                const Divider(
                  height: 8,
                  color: XColors.gray_4,
                ),
                ListTile(
                  title: Text(
                    "میز ها",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  leading: const FaIcon(
                    FontAwesomeIcons.table,
                    size: 20,
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: XColors.gray_8,
                    size: 20,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
