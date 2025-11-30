// lib/screens/home.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nanas_mobile/custom_widgets/custom_circular_progress_indicator.dart';
import 'package:nanas_mobile/custom_widgets/custom_text_field.dart';
import 'package:nanas_mobile/providers/ven_shops_provider.dart';
import 'package:nanas_mobile/screens/ven_shop.dart' as screen;
import 'package:nanas_mobile/styles/colors.dart';
import 'package:nanas_mobile/styles/sizes.dart';
import 'dart:developer' as developer;

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final shopsAsyncValue = ref.watch(venShopsProvider);
    final searchQuery = ref.watch(shopSearchProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: kPaddingBody,
              child: CustomTextField(
                controller: _searchController,
                hintText: 'Search...',
                onChanged: (value) {
                  ref.read(shopSearchProvider.notifier).state = value;
                },
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: shopsAsyncValue.when(
                loading:
                    () =>
                        const Center(child: CustomCircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('$error')),
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
                    return const Center(child: Text('No Vendor found.'));
                  }
                  return Padding(
                    padding: kPaddingBody.copyWith(right: 4),
                    child: Scrollbar(
                      interactive: true,
                      thumbVisibility: true,
                      thickness: 6,
                      child: ListView.separated(
                        padding: const EdgeInsets.only(right: 12),
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
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
                                if (index == 0) const SizedBox(height: 10),
                                Container(
                                  padding: kPaddingCard,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: kWhiteColor,
                                    borderRadius: kBorderRadiusSmall,
                                    border: Border.all(
                                      width: 1,
                                      color: const Color(0xFFe2e8f0),
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
                                          borderRadius: kBorderRadiusSmall,
                                          child: Image.asset(
                                            'assets/images/wp${(index % 4) + 1}.jpg',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: 4),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    shop.name,
                                                    style:
                                                        textTheme.titleMedium,
                                                  ),
                                                  Text(
                                                    'RM${shop.price}/kg',
                                                    style: textTheme.titleSmall
                                                        ?.copyWith(
                                                          color: kPrimaryColor,
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
    );
  }
}
