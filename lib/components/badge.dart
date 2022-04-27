import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';

class Badge extends StatelessWidget {
  const Badge({
    Key? key,
    required this.child,
    this.itemsCount,
    this.color,
  }) : super(key: key);

  final Widget? child;
  final int? itemsCount;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child!,
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: const EdgeInsets.all(2.0),
            // color: Theme.of(context).accentColor,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: color ?? kSecondaryColor,
            ),
            constraints: const BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: Text(
              "$itemsCount",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
              ),
            ),
          ),
        )
      ],
    );
  }
}
