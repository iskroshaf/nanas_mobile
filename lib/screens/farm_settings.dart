// lib/screens/farm_settings.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nanas_mobile/custom_widgets/custom_app_bar.dart';
import 'package:nanas_mobile/custom_widgets/custom_text_field.dart';
import 'package:nanas_mobile/styles/colors.dart';
import 'package:nanas_mobile/styles/sizes.dart';
import 'dart:developer' as developer;

class FarmSettings extends StatefulWidget {
  const FarmSettings({super.key});

  @override
  State<FarmSettings> createState() => _FarmSettingsState();
}

class _FarmSettingsState extends State<FarmSettings> {
  final _farmNameCtrl = TextEditingController();
  final _farmSizeCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _postcodeCtrl = TextEditingController();
  final _townCtrl = TextEditingController();
  final _varietyCtrl = TextEditingController();
  final _yearCtrl = TextEditingController();

  @override
  void dispose() {
    _farmNameCtrl.dispose();
    _farmSizeCtrl.dispose();
    _addressCtrl.dispose();
    _postcodeCtrl.dispose();
    _townCtrl.dispose();
    _varietyCtrl.dispose();
    _yearCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: CustomAppBar(
        text: 'Farm Settings',
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        titleColor: kWhiteColor,
        leadingIconColor: kWhiteColor,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Text(
              'Save',
              style: textTheme.bodyMedium?.copyWith(color: kSecondaryColor),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: kPaddingBody.copyWith(top: 16, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tell us a little about yourself as the farm owner.',
                style: textTheme.bodySmall,
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () => developer.log('Upload Farm Image tapped'),
                child: Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    color: kWhiteColor,
                    borderRadius: kBorderRadiusSmall,
                    border: Border.all(color: const Color(0xFFf3f4f6)),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.image,
                          size: kIconSizeLarge,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 8),
                        Text('Tap to upload image', style: textTheme.bodySmall),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              buildFarmSettingField(
                context,
                'Farm Name',
                false,
                false,
                _farmNameCtrl,
              ),
              const SizedBox(height: 12),
              buildFarmSettingField(
                context,
                'Farm Size (acres)',
                true,
                false,
                _farmSizeCtrl,
              ),
              const SizedBox(height: 12),
              buildFarmSettingField(
                context,
                'Address',
                false,
                false,
                _addressCtrl,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: buildFarmSettingField(
                      context,
                      'Postcode',
                      true,
                      false,
                      _postcodeCtrl,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: buildFarmSettingField(
                      context,
                      'Town/City',
                      false,
                      false,
                      _townCtrl,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              buildFarmSettingField(
                context,
                'Pineapple Variety(s)',
                false,
                false,
                _varietyCtrl,
              ),
              const SizedBox(height: 12),
              buildFarmSettingField(
                context,
                'Year In Business',
                true,
                false,
                _yearCtrl,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildFarmSettingField(
  BuildContext context,
  String label,
  bool isNumber,
  bool isDisable,
  TextEditingController controller,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label),
      SizedBox(height: 4),
      CustomTextField(controller: controller, isDisable: isDisable),
    ],
  );
}
