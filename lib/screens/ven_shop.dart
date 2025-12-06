// lib/screens/farm_detail.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nanas_mobile/custom_widgets/custom_elevated_button.dart';
import 'package:nanas_mobile/custom_widgets/custom_outlined_button.dart';
import 'package:nanas_mobile/styles/colors.dart';
import 'package:nanas_mobile/styles/sizes.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:nanas_mobile/models/farm_model.dart';

class FarmDetail extends StatefulWidget {
  final FarmModel farm;

  const FarmDetail({super.key, required this.farm});

  @override
  State<FarmDetail> createState() => _FarmDetailState();
}

class _FarmDetailState extends State<FarmDetail> {
  String? _fullImageUrl;

  @override
  void initState() {
    super.initState();

    final img = widget.farm.imageUrl;
    if (img != null && img.toString().isNotEmpty) {
      _fullImageUrl =
          "${dotenv.env['DOMAIN']}:${dotenv.env['PORT']}${img.toString()}";
    }
  }

  /// Ambil nombor telefon owner dari FarmModel
  String? _getOwnerPhone() {
    final phone = widget.farm.ownerPhoneNo;
    if (phone == null || phone.trim().isEmpty) return null;
    return phone.trim();
  }

  Future<void> _openWhatsApp() async {
    final phoneRaw = _getOwnerPhone();

    if (phoneRaw == null || phoneRaw.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No phone number available for this farm'),
        ),
      );
      return;
    }

    // Buang semua non-digit ( +, space, dash dsb ) supaya format OK
    final phone = phoneRaw.replaceAll(RegExp(r'\D'), '');

    if (phone.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid phone number')));
      return;
    }

    final message = Uri.encodeComponent('Hi, saya dari Nanas App.');
    final url = Uri.parse('https://wa.me/$phone?text=$message');

    try {
      final launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        ScaffoldMessenger.of(
          // ignore: use_build_context_synchronously
          context,
        ).showSnackBar(const SnackBar(content: Text('Cannot open WhatsApp')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(const SnackBar(content: Text('Cannot open WhatsApp')));
    }
  }

  Future<void> _callOwner() async {
    final phoneRaw = _getOwnerPhone();

    if (phoneRaw == null || phoneRaw.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No phone number available for this farm'),
        ),
      );
      return;
    }

    final phone = phoneRaw.replaceAll(RegExp(r'\D'), '');
    if (phone.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid phone number')));
      return;
    }

    final uri = Uri(scheme: 'tel', path: phone);

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cannot start phone call')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(const SnackBar(content: Text('Cannot start phone call')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final farm = widget.farm;

    return Scaffold(
      backgroundColor: kBodyLightColor,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // ───── APP BAR DENGAN GAMBAR FARM ─────
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
                    farm.name,
                    style: textTheme.titleLarge?.copyWith(color: kWhiteColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      _fullImageUrl != null
                          ? Image.network(
                            _fullImageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (_, __, ___) => Container(
                                  color: Colors.grey.shade200,
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                ),
                          )
                          : Image.asset(
                            'assets/images/wp1.jpg',
                            fit: BoxFit.cover,
                          ),
                    ],
                  ),
                ),
              ),

              // ───── KANDUNGAN DETAIL FARM ─────
              SliverToBoxAdapter(
                child: Padding(
                  padding: kPaddingBody.copyWith(top: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badge size + location
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
                              'Size: ${farm.size}',
                              style: textTheme.titleMedium?.copyWith(
                                color: kWhiteColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          const FaIcon(
                            FontAwesomeIcons.locationDot,
                            color: kPrimaryColor,
                            size: kIconSizeSmall,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${farm.city}, ${farm.postcode}',
                              style: textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Nama farm besar
                      Text(
                        farm.name,
                        style: textTheme.titleLarge?.copyWith(
                          color: kPrimaryColor,
                        ),
                      ),

                      // "Desc" – guna variety + address
                      Text(
                        [
                          if (farm.pineappleVariety.isNotEmpty)
                            'Pineapple variety: ${farm.pineappleVariety}',
                          '${farm.address}, ${farm.city} ${farm.postcode}',
                        ].join('\n'),
                        style: textTheme.bodyMedium,
                      ),

                      const SizedBox(height: 16),

                      _buildInfoRow(
                        'Pineapple variety: ${farm.pineappleVariety}',
                        FontAwesomeIcons.leaf,
                        kSuccessColor,
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        'Farm size: ${farm.size}',
                        FontAwesomeIcons.tractor,
                        kPrimaryColor,
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        'Located in: ${farm.city}, ${farm.postcode}',
                        FontAwesomeIcons.locationDot,
                        kWarningColor,
                      ),

                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ───── BUTANG DI BAWAH ─────
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
                      onPressed: _openWhatsApp,
                      icon: FontAwesomeIcons.whatsapp,
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: CustomOutlinedButton(
                      icon: FontAwesomeIcons.phone,
                      backgroundColor: kPrimaryColor,
                      foregroundColor: kWhiteColor,
                      text: 'Call farm owner',
                      onPressed: _callOwner,
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
