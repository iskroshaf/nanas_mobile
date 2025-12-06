// // lib/screens/farm_settings.dart

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// import 'package:nanas_mobile/custom_widgets/custom_app_bar.dart';
// import 'package:nanas_mobile/custom_widgets/custom_text_field.dart';
// import 'package:nanas_mobile/custom_widgets/custom_snack_bar.dart';
// import 'package:nanas_mobile/helpers/image_picker.dart';
// import 'package:nanas_mobile/services/farm.dart';
// import 'package:nanas_mobile/styles/colors.dart';
// import 'package:nanas_mobile/styles/sizes.dart';

// final String? _domain = dotenv.env['DOMAIN'];
// final String? _port = dotenv.env['PORT'];

// class FarmSettings extends StatefulWidget {
//   const FarmSettings({super.key});

//   @override
//   State<FarmSettings> createState() => _FarmSettingsState();
// }

// class _FarmSettingsState extends State<FarmSettings> {
//   final _farmNameCtrl = TextEditingController();
//   final _farmSizeCtrl = TextEditingController();
//   final _addressCtrl = TextEditingController();
//   final _postcodeCtrl = TextEditingController();
//   final _townCtrl = TextEditingController();
//   final _varietyCtrl = TextEditingController();
//   final _yearCtrl = TextEditingController();

//   File? _farmImage; // image baru (local)
//   String? _existingFarmImagePath; // image sedia ada dari server

//   bool _isLoading = true;
//   bool _isSaving = false;
//   bool _isValid = false;

//   int? _currentFarmId; // 🆕 simpan farm id paling latest

//   @override
//   void initState() {
//     super.initState();
//     _attachListeners();
//     _loadLatestFarm();
//   }

//   void _attachListeners() {
//     _farmNameCtrl.addListener(_validate);
//     _farmSizeCtrl.addListener(_validate);
//     _addressCtrl.addListener(_validate);
//     _postcodeCtrl.addListener(_validate);
//     _townCtrl.addListener(_validate);
//     _varietyCtrl.addListener(_validate);
//     _yearCtrl.addListener(_validate);
//   }

//   void _validate() {
//     setState(() {
//       _isValid =
//           _farmNameCtrl.text.isNotEmpty &&
//           _farmSizeCtrl.text.isNotEmpty &&
//           _addressCtrl.text.isNotEmpty &&
//           _postcodeCtrl.text.isNotEmpty &&
//           _townCtrl.text.isNotEmpty &&
//           _varietyCtrl.text.isNotEmpty &&
//           _yearCtrl.text.isNotEmpty;
//     });
//   }

//   /// 🔥 Load farm paling latest dari /v1/farms/me
//   Future<void> _loadLatestFarm() async {
//     setState(() => _isLoading = true);

//     try {
//       final latestFarm = await FarmService.getLatestFarmOfCurrentUser();

//       // latestFarm contoh:
//       // {
//       //   "name": "Golden Nenas",
//       //   "size": "5 hectors",
//       //   "address": "Jalan Bunga Raya",
//       //   "postcode": "78102",
//       //   "city": "Rawang",
//       //   "pineapple_variety": "Nenas md2",
//       //   "image_url": null,
//       //   "id": 3,
//       //   "owner_id": 1
//       // }

//       _currentFarmId = latestFarm['id'] as int?;

//       _farmNameCtrl.text = latestFarm['name']?.toString() ?? '';
//       _farmSizeCtrl.text = latestFarm['size']?.toString() ?? '';
//       _addressCtrl.text = latestFarm['address']?.toString() ?? '';
//       _postcodeCtrl.text = latestFarm['postcode']?.toString() ?? '';
//       _townCtrl.text = latestFarm['city']?.toString() ?? '';
//       _varietyCtrl.text = latestFarm['pineapple_variety']?.toString() ?? '';

//       // year_business mungkin tak ada dalam response /me
//       // kalau tak ada, biar kosong, user boleh isi
//       _yearCtrl.text = latestFarm['year_business']?.toString() ?? '';

//       _existingFarmImagePath = latestFarm['image_url']?.toString();

//       _validate();
//     } catch (e) {
//       CustomSnackBar.show(
//         // ignore: use_build_context_synchronously
//         context: context,
//         message: "Failed to load farm profile: $e",
//         type: SnackBarType.error,
//       );
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   String _buildFullImageURL(String path) {
//     if (path.startsWith('http://') || path.startsWith('https://')) {
//       return path;
//     }
//     if (_domain == null || _domain!.isEmpty) return path;
//     if (_port == null || _port!.isEmpty) {
//       return '$_domain$path';
//     }
//     return '$_domain:$_port$path';
//   }

//   Future<void> _pickFarmImage() async {
//     final picked = await ImagePickerHelper.pickImage(context);
//     if (picked != null) {
//       setState(() {
//         _farmImage = picked;
//       });
//     }
//   }

//   Future<void> _saveFarm() async {
//     if (_isSaving || !_isValid) return;

//     if (_currentFarmId == null) {
//       CustomSnackBar.show(
//         context: context,
//         message: "Farm ID not found. Please reload the page.",
//         type: SnackBarType.error,
//       );
//       return;
//     }

//     setState(() => _isSaving = true);

//     try {
//       final response = await FarmService.updateFarm(
//         farmId: _currentFarmId!,
//         farmName: _farmNameCtrl.text,
//         farmSize: _farmSizeCtrl.text,
//         farmAddress: _addressCtrl.text,
//         postcode: _postcodeCtrl.text,
//         city: _townCtrl.text,
//         pineappleVariety: _varietyCtrl.text,
//         yearBusiness: _yearCtrl.text,
//         imageFile: _farmImage,
//       );

//       // Update state dengan data terbaru dari server
//       final newImageUrl = response['image_url']?.toString();
//       setState(() {
//         _existingFarmImagePath = newImageUrl;
//         _farmImage = null; // lepas save, guna image dari server
//       });

//       CustomSnackBar.show(
//         // ignore: use_build_context_synchronously
//         context: context,
//         message: "Farm details updated successfully",
//         type: SnackBarType.success,
//       );
//     } catch (e) {
//       CustomSnackBar.show(
//         // ignore: use_build_context_synchronously
//         context: context,
//         message: "Failed to update farm details: $e",
//         type: SnackBarType.error,
//       );
//     } finally {
//       if (mounted) {
//         setState(() => _isSaving = false);
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _farmNameCtrl.dispose();
//     _farmSizeCtrl.dispose();
//     _addressCtrl.dispose();
//     _postcodeCtrl.dispose();
//     _townCtrl.dispose();
//     _varietyCtrl.dispose();
//     _yearCtrl.dispose();
//     super.dispose();
//   }

//   Widget _buildFarmImagePreview(TextTheme textTheme) {
//     if (_farmImage != null) {
//       // Gambar baru yang user pilih
//       return Image.file(_farmImage!, fit: BoxFit.cover);
//     }

//     if (_existingFarmImagePath != null && _existingFarmImagePath!.isNotEmpty) {
//       final url = _buildFullImageURL(_existingFarmImagePath!);
//       return Image.network(url, fit: BoxFit.cover);
//     }

//     // Placeholder
//     return Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           FaIcon(
//             FontAwesomeIcons.image,
//             size: kIconSizeLarge,
//             color: Colors.grey.shade400,
//           ),
//           const SizedBox(height: 8),
//           Text('Tap to upload image', style: textTheme.bodySmall),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final textTheme = Theme.of(context).textTheme;

//     return Scaffold(
//       appBar: CustomAppBar(
//         text: 'Farm Settings',
//         centerTitle: true,
//         backgroundColor: kPrimaryColor,
//         titleColor: kWhiteColor,
//         leadingIconColor: kWhiteColor,
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 20),
//             child: Center(
//               child:
//                   _isSaving
//                       ? const SizedBox(
//                         width: 18,
//                         height: 18,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           color: kSecondaryColor,
//                         ),
//                       )
//                       : Opacity(
//                         opacity: _isValid ? 1.0 : 0.4,
//                         child: GestureDetector(
//                           onTap: _isValid ? _saveFarm : null,
//                           child: Text(
//                             'Save',
//                             style: textTheme.bodyMedium?.copyWith(
//                               color: kSecondaryColor,
//                             ),
//                           ),
//                         ),
//                       ),
//             ),
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child:
//             _isLoading
//                 ? const Center(
//                   child: CircularProgressIndicator(color: kPrimaryColor),
//                 )
//                 : SingleChildScrollView(
//                   padding: kPaddingBody.copyWith(top: 16, bottom: 16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Tell us a little about your farm.',
//                         style: textTheme.bodySmall,
//                       ),
//                       const SizedBox(height: 24),

//                       // FARM IMAGE
//                       GestureDetector(
//                         onTap: _isSaving ? null : () => _pickFarmImage(),
//                         child: Container(
//                           width: double.infinity,
//                           height: 150,
//                           decoration: BoxDecoration(
//                             color: kWhiteColor,
//                             borderRadius: kBorderRadiusSmall,
//                             border: Border.all(color: const Color(0xFFf3f4f6)),
//                           ),
//                           child: _buildFarmImagePreview(textTheme),
//                         ),
//                       ),
//                       const SizedBox(height: 24),

//                       // FORM FIELDS
//                       buildFarmSettingField(
//                         context,
//                         'Farm Name',
//                         false,
//                         _isSaving,
//                         'Enter your farm name',
//                         _farmNameCtrl,
//                       ),
//                       const SizedBox(height: 12),

//                       buildFarmSettingField(
//                         context,
//                         'Farm Size',
//                         false,
//                         _isSaving,
//                         'Enter farm size (e.g. 4 hector)',
//                         _farmSizeCtrl,
//                       ),
//                       const SizedBox(height: 12),

//                       buildFarmSettingField(
//                         context,
//                         'Address',
//                         false,
//                         _isSaving,
//                         'Enter your farm address',
//                         _addressCtrl,
//                       ),
//                       const SizedBox(height: 12),

//                       Row(
//                         children: [
//                           Expanded(
//                             child: buildFarmSettingField(
//                               context,
//                               'Postcode',
//                               false,
//                               _isSaving,
//                               'Enter postcode',
//                               _postcodeCtrl,
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: buildFarmSettingField(
//                               context,
//                               'Town/City',
//                               false,
//                               _isSaving,
//                               'Enter town or city',
//                               _townCtrl,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 12),

//                       buildFarmSettingField(
//                         context,
//                         'Pineapple Variety(s)',
//                         false,
//                         _isSaving,
//                         'e.g., MD2, Moris, Josapine',
//                         _varietyCtrl,
//                       ),
//                       const SizedBox(height: 12),

//                       buildFarmSettingField(
//                         context,
//                         'Year In Business',
//                         false,
//                         _isSaving,
//                         'Enter year started (e.g. 2020)',
//                         _yearCtrl,
//                       ),
//                       const SizedBox(height: 24),
//                     ],
//                   ),
//                 ),
//       ),
//     );
//   }
// }

// Widget buildFarmSettingField(
//   BuildContext context,
//   String label,
//   bool isNumber,
//   bool isDisable,
//   String hintText,
//   TextEditingController controller,
// ) {
//   final textTheme = Theme.of(context).textTheme;

//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(label, style: textTheme.bodyMedium),
//       const SizedBox(height: 4),
//       CustomTextField(
//         controller: controller,
//         isDisable: isDisable,
//         hintText: hintText,
//         // kalau nak limit numeric keypad, boleh tambah keyboardType nanti
//       ),
//     ],
//   );
// }

// lib/screens/farm_settings.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:nanas_mobile/custom_widgets/custom_app_bar.dart';
import 'package:nanas_mobile/custom_widgets/custom_text_field.dart';
import 'package:nanas_mobile/custom_widgets/custom_snack_bar.dart';
import 'package:nanas_mobile/helpers/image_picker.dart';
import 'package:nanas_mobile/services/farm.dart';
import 'package:nanas_mobile/styles/colors.dart';
import 'package:nanas_mobile/styles/sizes.dart';

final String? _domain = dotenv.env['DOMAIN'];
final String? _port = dotenv.env['PORT'];

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

  File? _farmImage; 
  String? _existingFarmImagePath; 

  bool _isLoading = true;
  bool _isSaving = false;
  bool _isValid = false;

  int? _currentFarmId; 

  @override
  void initState() {
    super.initState();
    _attachListeners();
    _loadLatestFarm();
  }

  void _attachListeners() {
    _farmNameCtrl.addListener(_validate);
    _farmSizeCtrl.addListener(_validate);
    _addressCtrl.addListener(_validate);
    _postcodeCtrl.addListener(_validate);
    _townCtrl.addListener(_validate);
    _varietyCtrl.addListener(_validate);
  }

  void _validate() {
    setState(() {
      _isValid =
          _farmNameCtrl.text.isNotEmpty &&
          _farmSizeCtrl.text.isNotEmpty &&
          _addressCtrl.text.isNotEmpty &&
          _postcodeCtrl.text.isNotEmpty &&
          _townCtrl.text.isNotEmpty &&
          _varietyCtrl.text.isNotEmpty;
    });
  }

  Future<void> _loadLatestFarm() async {
    setState(() => _isLoading = true);

    try {
      final latestFarm = await FarmService.getLatestFarmOfCurrentUser();

      _currentFarmId = latestFarm['id'] as int?;

      _farmNameCtrl.text = latestFarm['name']?.toString() ?? '';
      _farmSizeCtrl.text = latestFarm['size']?.toString() ?? '';
      _addressCtrl.text = latestFarm['address']?.toString() ?? '';
      _postcodeCtrl.text = latestFarm['postcode']?.toString() ?? '';
      _townCtrl.text = latestFarm['city']?.toString() ?? '';
      _varietyCtrl.text = latestFarm['pineapple_variety']?.toString() ?? '';

      _existingFarmImagePath = latestFarm['image_url']?.toString();


      _validate();
    } catch (e) {
      CustomSnackBar.show(
        // ignore: use_build_context_synchronously
        context: context,
        message: "Failed to load farm profile: $e",
        type: SnackBarType.error,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _buildFullImageURL(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }
    if (_domain == null || _domain!.isEmpty) return path;
    if (_port == null || _port!.isEmpty) {
      return '$_domain$path';
    }
    return '$_domain:$_port$path';
  }

  Future<void> _pickFarmImage() async {
    final picked = await ImagePickerHelper.pickImage(context);
    if (picked != null) {
      setState(() {
        _farmImage = picked;
      });
    }
  }

  Future<void> _saveFarm() async {
    if (_isSaving || !_isValid) return;

    if (_currentFarmId == null) {
      CustomSnackBar.show(
        context: context,
        message: "Farm ID not found. Please reload the page.",
        type: SnackBarType.error,
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final response = await FarmService.updateFarm(
        farmId: _currentFarmId!,
        farmName: _farmNameCtrl.text,
        farmSize: _farmSizeCtrl.text,
        farmAddress: _addressCtrl.text,
        postcode: _postcodeCtrl.text,
        city: _townCtrl.text,
        pineappleVariety: _varietyCtrl.text,
        imageFile: _farmImage,
      );

      final newImageUrl = response['image_url']?.toString();
      setState(() {
        _existingFarmImagePath = newImageUrl;
        _farmImage = null; 
      });

      CustomSnackBar.show(
        // ignore: use_build_context_synchronously
        context: context,
        message: "Farm details updated successfully",
        type: SnackBarType.success,
      );
    } catch (e) {
      CustomSnackBar.show(
        // ignore: use_build_context_synchronously
        context: context,
        message: "Failed to update farm details: $e",
        type: SnackBarType.error,
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  void dispose() {
    _farmNameCtrl.dispose();
    _farmSizeCtrl.dispose();
    _addressCtrl.dispose();
    _postcodeCtrl.dispose();
    _townCtrl.dispose();
    _varietyCtrl.dispose();
    super.dispose();
  }

  Widget _buildFarmImagePreview(TextTheme textTheme) {
    if (_farmImage != null) {
      return Image.file(_farmImage!, fit: BoxFit.cover);
    }

    if (_existingFarmImagePath != null && _existingFarmImagePath!.isNotEmpty) {
      final url = _buildFullImageURL(_existingFarmImagePath!);

      return Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return Center(
            child: Text('Failed to load image', style: textTheme.bodySmall),
          );
        },
      );
    }

    return Center(
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
    );
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
            padding: const EdgeInsets.only(right: 20),
            child: Center(
              child:
                  _isSaving
                      ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: kSecondaryColor,
                        ),
                      )
                      : Opacity(
                        opacity: _isValid ? 1.0 : 0.4,
                        child: GestureDetector(
                          onTap: _isValid ? _saveFarm : null,
                          child: Text(
                            'Save',
                            style: textTheme.bodyMedium?.copyWith(
                              color: kSecondaryColor,
                            ),
                          ),
                        ),
                      ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child:
            _isLoading
                ? const Center(
                  child: CircularProgressIndicator(color: kPrimaryColor),
                )
                : SingleChildScrollView(
                  padding: kPaddingBody.copyWith(top: 16, bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tell us a little about your farm.',
                        style: textTheme.bodySmall,
                      ),
                      const SizedBox(height: 24),

                      // FARM IMAGE PREVIEW + PICKER
                      GestureDetector(
                        onTap: _isSaving ? null : () => _pickFarmImage(),
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            color: kWhiteColor,
                            borderRadius: kBorderRadiusSmall,
                            border: Border.all(color: const Color(0xFFf3f4f6)),
                          ),
                          child: _buildFarmImagePreview(textTheme),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // FORM FIELDS
                      buildFarmSettingField(
                        context,
                        'Farm Name',
                        false,
                        _isSaving,
                        'Enter your farm name',
                        _farmNameCtrl,
                      ),
                      const SizedBox(height: 12),

                      buildFarmSettingField(
                        context,
                        'Farm Size',
                        false,
                        _isSaving,
                        'Enter farm size (e.g. 4 hector)',
                        _farmSizeCtrl,
                      ),
                      const SizedBox(height: 12),

                      buildFarmSettingField(
                        context,
                        'Address',
                        false,
                        _isSaving,
                        'Enter your farm address',
                        _addressCtrl,
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: buildFarmSettingField(
                              context,
                              'Postcode',
                              false,
                              _isSaving,
                              'Enter postcode',
                              _postcodeCtrl,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: buildFarmSettingField(
                              context,
                              'Town/City',
                              false,
                              _isSaving,
                              'Enter town or city',
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
                        _isSaving,
                        'e.g., MD2, Moris, Josapine',
                        _varietyCtrl,
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
  String hintText,
  TextEditingController controller,
) {
  final textTheme = Theme.of(context).textTheme;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: textTheme.bodyMedium),
      const SizedBox(height: 4),
      CustomTextField(
        controller: controller,
        isDisable: isDisable,
        hintText: hintText,
      ),
    ],
  );
}
