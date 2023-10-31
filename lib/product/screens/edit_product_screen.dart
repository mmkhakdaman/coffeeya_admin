import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditProductScreen extends StatelessWidget {
  const EditProductScreen({
    super.key,
    required String id,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ویرایش محصول'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.goNamed(
              'home',
            );
          },
        ),
      ),
      body: Container(),
    );
  }
}
