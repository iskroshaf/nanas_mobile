// lib/screens/farm_register.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nanas_mobile/custom_widgets/custom_outlined_button.dart';
import 'package:nanas_mobile/custom_widgets/custom_elevated_button.dart';
import 'package:nanas_mobile/custom_widgets/custom_text_field.dart';
import 'package:nanas_mobile/screens/ent_dashboard.dart';
import 'package:nanas_mobile/styles/colors.dart';
import 'package:nanas_mobile/styles/sizes.dart';
import 'dart:developer' as developer;

class EntFarmRegister extends StatefulWidget {
  const EntFarmRegister({super.key});

  @override
  State<EntFarmRegister> createState() => _EntFarmRegisterState();
}

class _EntFarmRegisterState extends State<EntFarmRegister> {
  late final PageController _pageController;
  int _currentPage = 0;

  final _farmNameCtrl = TextEditingController();
  final _farmSizeCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _postcodeCtrl = TextEditingController();
  final _townCtrl = TextEditingController();
  final _varietyCtrl = TextEditingController();
  final _yearCtrl = TextEditingController();

  final _ownerNameCtrl = TextEditingController();
  final _ownerPhoneCtrl = TextEditingController();
  final _ownerEmailCtrl = TextEditingController();
  final _ownerIcCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _farmNameCtrl.dispose();
    _farmSizeCtrl.dispose();
    _addressCtrl.dispose();
    _postcodeCtrl.dispose();
    _townCtrl.dispose();
    _varietyCtrl.dispose();
    _yearCtrl.dispose();

    _ownerNameCtrl.dispose();
    _ownerPhoneCtrl.dispose();
    _ownerEmailCtrl.dispose();
    _ownerIcCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(2, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: _currentPage == index ? 24 : 8,
                    decoration: BoxDecoration(
                      color:
                          _currentPage == index
                              ? kPrimaryColor
                              : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),

            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                children: [
                  SingleChildScrollView(
                    padding: kPaddingBody,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        Text(
                          'Owner Registration',
                          style: textTheme.titleLarge?.copyWith(
                            color: kPrimaryColor,
                          ),
                        ),
                        Text(
                          'Tell us a little about yourself as the farm owner.',
                          style: textTheme.bodySmall,
                        ),
                        const SizedBox(height: 24),
                        GestureDetector(
                          onTap:
                              () => developer.log('Upload Farm Image tapped'),
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                              color: kWhiteColor,
                              border: Border.all(
                                color: const Color(0xFFf3f4f6),
                              ),
                              shape: BoxShape.circle,
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
                                  Text(
                                    'Tap to upload image',
                                    style: textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        buildFarmField(
                          context,
                          'Full Name',
                          false,
                          _ownerNameCtrl,
                        ),
                        const SizedBox(height: 12),
                        buildFarmField(
                          context,
                          'Phone Number',
                          true,
                          _ownerPhoneCtrl,
                        ),
                        const SizedBox(height: 12),
                        buildFarmField(
                          context,
                          'IC / Passport Number',
                          false,
                          _ownerIcCtrl,
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),

                  SingleChildScrollView(
                    padding: kPaddingBody,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        Text(
                          'Farm Registration',
                          style: textTheme.titleLarge?.copyWith(
                            color: kPrimaryColor,
                          ),
                        ),
                        Text(
                          'Provide your farm details to finish setting up your profile.',
                          style: textTheme.bodySmall,
                        ),
                        const SizedBox(height: 24),
                        GestureDetector(
                          onTap:
                              () => developer.log('Upload Farm Image tapped'),
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                              color: kWhiteColor,
                              borderRadius: kBorderRadiusSmall,
                              border: Border.all(
                                color: const Color(0xFFf3f4f6),
                              ),
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
                                  Text(
                                    'Tap to upload image',
                                    style: textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        buildFarmField(
                          context,
                          'Farm Name',
                          false,
                          _farmNameCtrl,
                        ),
                        const SizedBox(height: 12),
                        buildFarmField(
                          context,
                          'Farm Size (acres)',
                          true,
                          _farmSizeCtrl,
                        ),
                        const SizedBox(height: 12),
                        buildFarmField(context, 'Address', false, _addressCtrl),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: buildFarmField(
                                context,
                                'Postcode',
                                true,
                                _postcodeCtrl,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: buildFarmField(
                                context,
                                'Town/City',
                                false,
                                _townCtrl,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        buildFarmField(
                          context,
                          'Pineapple Variety(s)',
                          false,
                          _varietyCtrl,
                        ),
                        const SizedBox(height: 12),
                        buildFarmField(
                          context,
                          'Year In Business',
                          true,
                          _yearCtrl,
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: Row(
                children: [
                  _currentPage == 1
                      ? Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: CustomOutlinedButton(
                            text: 'Back',
                            onPressed: () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                              );
                            },
                          ),
                        ),
                      )
                      : SizedBox.shrink(),
                  Expanded(
                    flex: 2,
                    child: CustomElevatedButton(
                      text: _currentPage == 0 ? 'Next' : 'Register',
                      onPressed: () {
                        _currentPage == 1
                            ? Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EntDashboard(),
                              ),
                            )
                            : _pageController.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFarmField(
    BuildContext context,
    String label,
    bool isNumber,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: kTextColorHigh),
        ),
        const SizedBox(height: 4),
        CustomTextField(controller: controller, isNumber: isNumber),
      ],
    );
  }
}
