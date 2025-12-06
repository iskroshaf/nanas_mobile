// lib/screens/ent_farm_register.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nanas_mobile/custom_widgets/custom_outlined_button.dart';
import 'package:nanas_mobile/custom_widgets/custom_elevated_button.dart';
import 'package:nanas_mobile/custom_widgets/custom_text_field.dart';
import 'package:nanas_mobile/helpers/image_picker.dart';
import 'package:nanas_mobile/services/ent.dart';
import 'package:nanas_mobile/styles/colors.dart';
import 'package:nanas_mobile/styles/sizes.dart';
import 'package:nanas_mobile/custom_widgets/custom_snack_bar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
  File? _farmImage;

  final _ownerNameCtrl = TextEditingController();
  final _ownerPhoneCtrl = TextEditingController();
  final _ownerIcCtrl = TextEditingController();
  File? _ownerImage;
  String? _profilePhotoUrl;

  Future<void> _loadOwnerData() async {
    try {
      final p = await EntService.getOwnerProfile();

      _ownerNameCtrl.text = p["full_name"] ?? "";
      _ownerPhoneCtrl.text = p["phone_no"] ?? "";
      _ownerIcCtrl.text = p["ic"] ?? "";

      if (p["profile_photo"] != null) {
        _profilePhotoUrl =
            "${dotenv.env['DOMAIN']}:${dotenv.env['PORT']}${p['profile_photo']}";
      }


      setState(() {});
    } catch (_) {}
  }

  Future<void> _submitOwnerInfo() async {
    try {
      await EntService.updateOwnerProfile(
        fullName: _ownerNameCtrl.text,
        phoneNo: _ownerPhoneCtrl.text,
        ic: _ownerIcCtrl.text,
        profilePhoto: _ownerImage,
      );

      CustomSnackBar.show(
        // ignore: use_build_context_synchronously
        context: context,
        message: 'Owner Update Successfully',
        type: SnackBarType.success,
      );
    } catch (e) {
      CustomSnackBar.show(
        // ignore: use_build_context_synchronously
        context: context,
        message: 'Failed to update owner',
        type: SnackBarType.error,
      );
    }
  }

  Future<void> _submitFarm() async {
    try {
      await EntService.registerFarm(
        name: _farmNameCtrl.text,
        size: _farmSizeCtrl.text,
        address: _addressCtrl.text,
        postcode: _postcodeCtrl.text,
        city: _townCtrl.text,
        pineappleVariety: _varietyCtrl.text,
        image: _farmImage,
      );

      CustomSnackBar.show(
        // ignore: use_build_context_synchronously
        context: context,
        message: 'Farm Added Successfully',
        type: SnackBarType.success,
      );

      // ignore: use_build_context_synchronously
      Navigator.pop(context, true);
    } catch (e) {
      CustomSnackBar.show(
        // ignore: use_build_context_synchronously
        context: context,
        message: 'Failed to register farm',
        type: SnackBarType.error,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadOwnerData();

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
                    padding: kPaddingBody.copyWith(top: 16, bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        Center(
                          child: GestureDetector(
                            onTap: () async {
                              final picked = await ImagePickerHelper.pickImage(
                                context,
                              );
                              if (picked != null) {
                                setState(() => _ownerImage = picked);
                              }
                            },
                            child: ClipOval(
                              child: Container(
                                width: 150,
                                height: 150,
                                color: kWhiteColor,
                                child:
                                    _ownerImage != null
                                        ? Image.file(
                                          _ownerImage!,
                                          fit: BoxFit.cover,
                                        )
                                        : _profilePhotoUrl != null
                                        ? Image.network(
                                          _profilePhotoUrl!,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (_, __, ___) => Icon(Icons.error),
                                        )
                                        : Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              FaIcon(
                                                FontAwesomeIcons.image,
                                                size: kIconSizeLarge,
                                                color: Colors.grey.shade400,
                                              ),
                                              SizedBox(height: 8),
                                              Text("Tap to upload image"),
                                            ],
                                          ),
                                        ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        buildOwnerFarmFields(
                          context,
                          'Full Name',
                          false,
                          'Enter your full name',
                          _ownerNameCtrl,
                        ),
                        const SizedBox(height: 12),
                        buildOwnerFarmFields(
                          context,
                          'Phone Number',
                          true,
                          'Enter your phone number',
                          _ownerPhoneCtrl,
                        ),
                        const SizedBox(height: 12),
                        buildOwnerFarmFields(
                          context,
                          'IC / Passport Number',
                          false,
                          'Enter your IC or passport number',
                          _ownerIcCtrl,
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),

                  SingleChildScrollView(
                    padding: kPaddingBody.copyWith(top: 16, bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                          onTap: () async {
                            final picked = await ImagePickerHelper.pickImage(
                              context,
                            );
                            if (picked != null) {
                              setState(() => _farmImage = picked);
                            }
                          },
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
                            child:
                                _farmImage != null
                                    ? Image.file(_farmImage!, fit: BoxFit.cover)
                                    : Center(
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
                                            style: textTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        buildOwnerFarmFields(
                          context,
                          'Farm Name',
                          false,
                          'Enter your farm name',
                          _farmNameCtrl,
                        ),
                        const SizedBox(height: 12),
                        buildOwnerFarmFields(
                          context,
                          'Farm Size (acres)',
                          true,
                          'Enter farm size in acres',
                          _farmSizeCtrl,
                        ),
                        const SizedBox(height: 12),
                        buildOwnerFarmFields(
                          context,
                          'Address',
                          false,
                          'Enter your farm address',
                          _addressCtrl,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: buildOwnerFarmFields(
                                context,
                                'Postcode',
                                true,
                                'Enter postcode',
                                _postcodeCtrl,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: buildOwnerFarmFields(
                                context,
                                'Town/City',
                                false,
                                'Enter town or city',
                                _townCtrl,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        buildOwnerFarmFields(
                          context,
                          'Pineapple Variety(s)',
                          false,
                          'e.g., MD2, Moris, Josapine',
                          _varietyCtrl,
                        ),
                        const SizedBox(height: 12),
                        buildOwnerFarmFields(
                          context,
                          'Year In Business',
                          true,
                          'Enter year started',
                          _yearCtrl,
                        ),
                        const SizedBox(height: 24),
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
                      onPressed: () async {
                        if (_currentPage == 0) {
                          // SUBMIT OWNER PROFILE
                          await _submitOwnerInfo();

                          // GO TO PAGE 2
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          // SUBMIT FARM REGISTRATION
                          await _submitFarm();
                        }
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
}

Widget buildOwnerFarmFields(
  BuildContext context,
  String label,
  bool isNumber,
  String hintText,
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
      CustomTextField(
        controller: controller,
        isNumber: isNumber,
        hintText: hintText,
      ),
    ],
  );
}
