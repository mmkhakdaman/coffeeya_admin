import 'package:coffeeya/core/helpers/number.dart';
import 'package:coffeeya/product/blocs/category_bloc.dart';
import 'package:coffeeya/product/models/product_model.dart';
import 'package:coffeeya/product/repositories/product_repository.dart';
import 'package:coffeeya/product/screens/edit_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductItemWidget extends StatefulWidget {
  const ProductItemWidget({super.key, required this.product});

  final ProductModel product;

  @override
  State<ProductItemWidget> createState() => _ProductItemWidgetState();
}

class _ProductItemWidgetState extends State<ProductItemWidget> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (pageContext) => BlocProvider.value(
                          value: BlocProvider.of<CategoryCubit>(context),
                          child: EditProductScreen(
                            id: widget.product.id.toString(),
                          ),
                        ),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
                            if (wasSynchronouslyLoaded) {
                              return child;
                            }
                            return AnimatedOpacity(
                              opacity: frame == null ? 0 : 1,
                              duration: const Duration(seconds: 1),
                              curve: Curves.easeOut,
                              child: child,
                            );
                          },
                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                              ),
                            );
                          },
                          widget.product.image,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.product.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        MouseRegion(
                          cursor: MaterialStateMouseCursor.clickable,
                          child: GestureDetector(
                            onTap: () async {
                              setState(() {
                                isLoading = true;
                              });
                              await ProductRepository.toggleActive(
                                product: widget.product,
                              ).then((value) {
                                setState(() {
                                  isLoading = false;
                                  widget.product.inStock = value.data.inStock;
                                });
                              });
                            },
                            child: Container(
                              width: 40,
                              height: 24,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: widget.product.inStock! ? Colors.green : Colors.grey,
                              ),
                              child: Stack(
                                children: [
                                  AnimatedPositioned(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeInOut,
                                    left: widget.product.inStock! ? 16 : 0,
                                    right: widget.product.inStock! ? 0 : 16,
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: isLoading
                                          ? CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: widget.product.inStock! ? Colors.green : Colors.grey,
                                            )
                                          : widget.product.inStock!
                                              ? const Icon(
                                                  Icons.check,
                                                  color: Colors.green,
                                                  size: 16,
                                                )
                                              : const Icon(
                                                  Icons.close,
                                                  color: Colors.grey,
                                                  size: 16,
                                                ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'تغییر وضعیت',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(
                            priceFormatter(widget.product.price.toDouble()),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'تومان',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
