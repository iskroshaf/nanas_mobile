// lib/screens/farms.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nanas_mobile/custom_widgets/custom_circular_progress_indicator.dart';
import 'package:nanas_mobile/custom_widgets/custom_icon_button.dart';
import 'package:nanas_mobile/custom_widgets/custom_text_field.dart';
import 'package:nanas_mobile/providers/ven_shop.dart';
import 'package:nanas_mobile/screens/ent_farm_register.dart';
import 'package:nanas_mobile/screens/ven_shop.dart' as screen;
import 'package:nanas_mobile/styles/colors.dart';
import 'package:nanas_mobile/styles/sizes.dart';
import 'dart:developer' as developer;

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

    final shopsAsyncValue = ref.watch(venShopProvider);
    final searchQuery = ref.watch(shopSearchProvider);

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
                    Spacer(),
                    CustomIconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EntFarmRegister(),
                          ),
                        );
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
                    ref.read(shopSearchProvider.notifier).state = value;
                  },
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: shopsAsyncValue.when(
                  loading:
                      () => const Center(
                        child: CustomCircularProgressIndicator(),
                      ),
                  error:
                      (error, stack) => Center(
                        child: Text('$error', style: textTheme.bodyMedium),
                      ),
                  data: (shops) {
                    final filteredShops =
                        shops
                            .where(
                              (shop) => shop.name.toLowerCase().contains(
                                searchQuery.toLowerCase(),
                              ),
                            )
                            .toList();

                    if (filteredShops.isEmpty) {
                      return Center(
                        child: Text(
                          'No Vendor found.',
                          style: textTheme.bodyMedium,
                        ),
                      );
                    }
                    return Padding(
                      padding: kPaddingBody.copyWith(right: 4),
                      child: Scrollbar(
                        controller: _scrollController,
                        interactive: true,
                        thumbVisibility: true,
                        thickness: 6,
                        child: ListView.separated(
                          controller: _scrollController,
                          primary: false,
                          padding: const EdgeInsets.only(right: 12),
                          separatorBuilder:
                              (_, __) => const SizedBox(height: 8),
                          itemCount: filteredShops.length,
                          itemBuilder: (context, index) {
                            final shop = filteredShops[index];
                            return GestureDetector(
                              onTap: () {
                                developer.log(shop.name);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => screen.VenShop(shop: shop),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  if (index == 0) const SizedBox(height: 8),
                                  Container(
                                    height: 200,
                                    decoration: BoxDecoration(
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
                                          decoration: const BoxDecoration(
                                            color: kWhiteColor,
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                              topRight: Radius.circular(8),
                                            ),
                                            child: Image.asset(
                                              'assets/images/wp${(index % 4) + 1}.jpg',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Padding(
                                          padding: kPaddingCard,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        shop.name,
                                                        style:
                                                            textTheme
                                                                .titleMedium,
                                                      ),
                                                      Text(
                                                        'RM${shop.price}/kg',
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
                                                    shop.location,
                                                    style: textTheme.bodySmall,
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                shop.desc,
                                                style: textTheme.bodySmall,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (index == filteredShops.length - 1)
                                    const SizedBox(height: 10),
                                ],
                              ),
                            );
                          },
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
