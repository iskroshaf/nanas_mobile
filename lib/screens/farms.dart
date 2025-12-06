// lib/screens/farms.dart

import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nanas_mobile/custom_widgets/custom_circular_progress_indicator.dart';
import 'package:nanas_mobile/custom_widgets/custom_icon_button.dart';
import 'package:nanas_mobile/custom_widgets/custom_text_field.dart';
import 'package:nanas_mobile/providers/farm_provider.dart';
import 'package:nanas_mobile/screens/ent_farm_register.dart';
import 'package:nanas_mobile/styles/colors.dart';
import 'package:nanas_mobile/styles/sizes.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nanas_mobile/screens/ven_shop.dart';

class Farms extends ConsumerStatefulWidget {
  const Farms({super.key});

  @override
  ConsumerState<Farms> createState() => _FarmsState();
}

class _FarmsState extends ConsumerState<Farms> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final farmsAsyncValue = ref.watch(farmProvider);
    final searchQuery = ref.watch(farmSearchProvider);

    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: Container(
          color: kBodyLightColor,
          child: Column(
            children: [
              Container(
                padding: kPaddingBody.copyWith(top: 16, bottom: 16),
                width: double.infinity,
                decoration: const BoxDecoration(color: kPrimaryColor),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Farms',
                          style: textTheme.titleLarge?.copyWith(
                            color: kWhiteColor,
                          ),
                        ),
                        Text(
                          'Latest updates from farms & vendors',
                          style: textTheme.bodyMedium?.copyWith(
                            color: kWhiteColor,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    CustomIconButton(
                      onPressed: () async {
                        final created = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EntFarmRegister(),
                          ),
                        );

                        // Jika farm berjaya didaftarkan, refresh senarai farms
                        if (created == true) {
                          ref.invalidate(farmProvider);
                        }
                      },
                      icon: FontAwesomeIcons.seedling,
                      iconColor: kWhiteColor,
                      iconSize: kIconSizeSmall,
                    ),
                  ],
                ),
              ),

              Padding(
                padding: kPaddingBody.copyWith(top: 16),
                child: CustomTextField(
                  controller: _searchController,
                  hintText: 'Search farms...',
                  onChanged: (value) {
                    ref.read(farmSearchProvider.notifier).state = value;
                  },
                ),
              ),
              const SizedBox(height: 8),

              Expanded(
                child: farmsAsyncValue.when(
                  loading:
                      () => const Center(
                        child: CustomCircularProgressIndicator(),
                      ),
                  error:
                      (error, stack) => Center(
                        child: Text('$error', style: textTheme.bodyMedium),
                      ),
                  data: (farms) {
                    final filteredFarms =
                        farms
                            .where(
                              (farm) => farm.name.toLowerCase().contains(
                                searchQuery.toLowerCase(),
                              ),
                            )
                            .toList();

                    return RefreshIndicator(
                      onRefresh: () async {
                        // Buang cache & fetch semula dari API
                        ref.invalidate(farmProvider);
                        await ref.read(farmProvider.future);
                      },
                      child:
                          filteredFarms.isEmpty
                              ? ListView(
                                controller: _scrollController,
                                physics:
                                    const AlwaysScrollableScrollPhysics(),
                                children: [
                                  const SizedBox(height: 80),
                                  Center(
                                    child: Text(
                                      'No farms found.',
                                      style: textTheme.bodyMedium,
                                    ),
                                  ),
                                ],
                              )
                              : Padding(
                                padding: kPaddingBody.copyWith(right: 4),
                                child: Scrollbar(
                                  controller: _scrollController,
                                  interactive: true,
                                  thumbVisibility: true,
                                  thickness: 6,
                                  child: ListView.separated(
                                    controller: _scrollController,
                                    primary: false,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    padding: const EdgeInsets.only(right: 12),
                                    separatorBuilder:
                                        (_, __) => const SizedBox(height: 8),
                                    itemCount: filteredFarms.length,
                                    itemBuilder: (context, index) {
                                      final farm = filteredFarms[index];

                                      final fullImgUrl =
                                          (farm.imageUrl != null &&
                                                  farm.imageUrl!.isNotEmpty)
                                              ? "${dotenv.env['DOMAIN']}:${dotenv.env['PORT']}${farm.imageUrl}"
                                              : null;

                                      return GestureDetector(
                                        onTap: () {
                                          developer.log(
                                            'Tapped farm: ${farm.name}',
                                          );
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (_) => FarmDetail(
                                                    farm: farm,
                                                  ),
                                            ),
                                          );
                                        },
                                        child: Column(
                                          children: [
                                            if (index == 0)
                                              const SizedBox(height: 8),
                                            Container(
                                              height: 200,
                                              decoration: const BoxDecoration(
                                                color: kWhiteColor,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8),
                                                  topRight: Radius.circular(8),
                                                ),
                                              ),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: 130,
                                                    width: double.infinity,
                                                    decoration:
                                                        const BoxDecoration(
                                                          color: kWhiteColor,
                                                        ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                  8,
                                                                ),
                                                            topRight:
                                                                Radius.circular(
                                                                  8,
                                                                ),
                                                          ),
                                                      child:
                                                          fullImgUrl != null
                                                              ? Image.network(
                                                                fullImgUrl,
                                                                fit:
                                                                    BoxFit
                                                                        .cover,
                                                                errorBuilder:
                                                                    (
                                                                      _,
                                                                      __,
                                                                      ___,
                                                                    ) => Container(
                                                                      color:
                                                                          Colors
                                                                              .grey
                                                                              .shade200,
                                                                      child: const Icon(
                                                                        Icons
                                                                            .image_not_supported,
                                                                        size:
                                                                            40,
                                                                      ),
                                                                    ),
                                                              )
                                                              : Image.asset(
                                                                'assets/images/wp${(index % 4) + 1}.jpg',
                                                                fit:
                                                                    BoxFit
                                                                        .cover,
                                                              ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),

                                                  Padding(
                                                    padding: kPaddingCard,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                // Nama Farm
                                                                Text(
                                                                  farm.name,
                                                                  style:
                                                                      textTheme
                                                                          .titleMedium,
                                                                ),
                                                                // Variety (ganti price lama)
                                                                Text(
                                                                  'Variety: ${farm.pineappleVariety}',
                                                                  style: textTheme
                                                                      .titleSmall
                                                                      ?.copyWith(
                                                                        color:
                                                                            kPrimaryColor,
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                            Text(
                                                              '${farm.city}, ${farm.postcode}',
                                                              style:
                                                                  textTheme
                                                                      .bodySmall,
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                            ),
                                                          ],
                                                        ),

                                                        Text(
                                                          'Size: ${farm.size} • ${farm.address}',
                                                          style:
                                                              textTheme
                                                                  .bodySmall,
                                                          maxLines: 2,
                                                          overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            if (index ==
                                                filteredFarms.length - 1)
                                              const SizedBox(height: 10),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
