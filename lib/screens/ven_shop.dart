// lib/screens/ven_shop.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nanas_mobile/custom_widgets/custom_elevated_button.dart';
import 'package:nanas_mobile/custom_widgets/custom_outlined_button.dart';
import 'package:nanas_mobile/models/ven_shop.dart';
import 'package:nanas_mobile/styles/colors.dart';
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
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: kBodyLightColor,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                floating: false,
                pinned: true,
                backgroundColor: kPrimaryColor,
                leading: IconButton(
                  icon: const FaIcon(
                    FontAwesomeIcons.angleLeft,
                    color: kWhiteColor,
                    size: kIconSizeMedium,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    widget.shop.name,
                    style: textTheme.titleLarge?.copyWith(color: kWhiteColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        'assets/images/wp${(widget.shop.id % 4) + 1}.jpg',
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: kPaddingBody.copyWith(top: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: kBorderRadiusSmall,
                            ),
                            child: Text(
                              'RM${widget.shop.price.toStringAsFixed(2)}/kg',
                              style: textTheme.titleMedium?.copyWith(
                                color: kWhiteColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          FaIcon(
                            FontAwesomeIcons.locationDot,
                            color: kPrimaryColor,
                            size: kIconSizeSmall,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.shop.location,
                              style: textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.shop.name,
                        style: textTheme.titleLarge?.copyWith(
                          color: kPrimaryColor,
                        ),
                      ),
                      Text(widget.shop.desc, style: textTheme.bodyMedium),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        'Fresh Harvest Daily',
                        FontAwesomeIcons.leaf,
                        kSuccessColor,
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        'Direct from Farm',
                        FontAwesomeIcons.tractor,
                        kPrimaryColor,
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        'Quality Guaranteed',
                        FontAwesomeIcons.shieldHalved,
                        kWarningColor,
                      ),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: kBodyLightColor,
              padding: const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                16 + kBottomNavigationBarHeight,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: CustomElevatedButton(
                      backgroundColor: const Color(0xFF25D366),
                      text: 'WhatsApp',
                      onPressed: () {},
                      icon: FontAwesomeIcons.whatsapp,
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: CustomOutlinedButton(
                      icon: FontAwesomeIcons.phone,
                      backgroundColor: kPrimaryColor,
                      foregroundColor: kWhiteColor,
                      text: 'Call vendor',
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String text, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: FaIcon(icon, color: color, size: kIconSizeSmall),
          ),
        ),
        const SizedBox(width: 8),
        Text(text, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}
