// lib/screens/ven_shop.dart

import 'package:flutter/material.dart';
import 'package:nanas_mobile/models/ven_shop.dart';
import 'package:nanas_mobile/styles/sizes.dart';

class VenShop extends StatefulWidget {
  final VenShopModel shop;

  const VenShop({super.key, required this.shop});

  @override
  State<VenShop> createState() => _VenShopState();
}

class _VenShopState extends State<VenShop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: kPaddingBody,
          child: Column(
            children: [
              Text(widget.shop.name),
              Text('${widget.shop.price}'),
              Text(widget.shop.location),
              Text(widget.shop.desc),
            ],
          ),
        ),
      ),
    );
  }
}
