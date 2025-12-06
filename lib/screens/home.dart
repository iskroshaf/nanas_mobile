// lib/screens/home.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nanas_mobile/custom_widgets/custom_circular_progress_indicator.dart';
import 'package:nanas_mobile/helpers/image_viewer.dart';
import 'package:nanas_mobile/providers/announcement.dart';
import 'package:nanas_mobile/providers/farm_provider.dart';
import 'package:nanas_mobile/styles/colors.dart';
import 'package:nanas_mobile/styles/sizes.dart';
import 'package:nanas_mobile/utils/date.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:developer' as developer;

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.invalidate(announcementProvider);
      ref.invalidate(farmProvider);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    ref.invalidate(announcementProvider);
    ref.invalidate(farmProvider);

    await Future.wait([
      ref.read(announcementProvider.future),
      ref.read(farmProvider.future),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final announcementsAsync = ref.watch(announcementProvider);
    final farmsAsync = ref.watch(farmProvider);

    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SafeArea(
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
                        'Welcome back!',
                        style: textTheme.titleLarge?.copyWith(
                          color: kWhiteColor,
                        ),
                      ),
                      Text(
                        'Enterprise Dashboard',
                        style: textTheme.bodyMedium?.copyWith(
                          color: kWhiteColor,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    width: 25,
                    height: 25,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/images/meWithBajuMelayu.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Container(
                color: kBodyLightColor,
                child: announcementsAsync.when(
                  loading:
                      () => const Center(
                        child: CustomCircularProgressIndicator(),
                      ),
                  error:
                      (err, _) => Center(
                        child: Text('Error: $err', style: textTheme.bodyMedium),
                      ),
                  data:
                      (announcements) => farmsAsync.when(
                        loading:
                            () => const Center(
                              child: CustomCircularProgressIndicator(),
                            ),
                        error:
                            (err, _) => Center(
                              child: Text(
                                'Error: $err',
                                style: textTheme.bodyMedium,
                              ),
                            ),
                        data:
                            (farms) => RefreshIndicator(
                              onRefresh: _refresh,
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.only(
                                  top: 16,
                                  bottom: 16,
                                ),
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // 📊 STAT CARDS
                                    Padding(
                                      padding: kPaddingBody,
                                      child: Row(
                                        children: [
                                          _buildStatCard(
                                            'Total Farms',
                                            farms.length,
                                            FontAwesomeIcons.tractor,
                                          ),
                                          const SizedBox(width: 12),
                                          _buildStatCard(
                                            'Announcements',
                                            announcements.length,
                                            FontAwesomeIcons.bullhorn,
                                          ),
                                          const SizedBox(width: 12),
                                          _buildStatCard(
                                            'Active Vendors',
                                            farms.length,
                                            FontAwesomeIcons.store,
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(height: 24),

                                    // 🔔 RECENT ANNOUNCEMENTS
                                    Padding(
                                      padding: kPaddingBody.copyWith(bottom: 4),
                                      child: Text(
                                        'Recent Announcements',
                                        style: textTheme.titleLarge,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 200,
                                      child: ListView.builder(
                                        padding: kPaddingBody.copyWith(
                                          right: 4,
                                        ),
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            announcements.length > 5
                                                ? 5
                                                : announcements.length,
                                        itemBuilder: (context, index) {
                                          final ann = announcements[index];
                                          final imagePath =
                                              (ann.imageUrl != null &&
                                                      ann.imageUrl!.isNotEmpty)
                                                  ? "${dotenv.env['DOMAIN']}:${dotenv.env['PORT']}${ann.imageUrl}"
                                                  : 'assets/images/farm_placeholder.jpg';
                                          // final imagePath =
                                          //     'assets/images/wp${(index % 4) + 1}.jpg';
                                          return Container(
                                            width: 275,
                                            margin: const EdgeInsets.only(
                                              right: 12,
                                            ),
                                            decoration: BoxDecoration(
                                              color: kWhiteColor,
                                              borderRadius: kBorderRadiusSmall,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                GestureDetector(
                                                  onTap:
                                                      () =>
                                                          ImageViewerHelper.viewImage(
                                                            context,
                                                            imagePath,
                                                          ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.vertical(
                                                          top: Radius.circular(
                                                            12,
                                                          ),
                                                        ),
                                                    child: Image.network(
                                                      imagePath,
                                                      height: 100,
                                                      width: double.infinity,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: kPaddingCard,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        ann.title,
                                                        style: textTheme
                                                            .titleMedium
                                                            ?.copyWith(
                                                              color:
                                                                  kPrimaryColor,
                                                            ),
                                                        maxLines: 1,
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        ann.message,
                                                        style:
                                                            textTheme.bodySmall,
                                                        maxLines: 2,
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: 20,
                                                            height: 20,
                                                            decoration: BoxDecoration(
                                                              shape:
                                                                  BoxShape
                                                                      .circle,
                                                              image: DecorationImage(
                                                                image:
                                                                    AssetImage(
                                                                      imagePath,
                                                                    ),
                                                                fit:
                                                                    BoxFit
                                                                        .cover,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 4,
                                                          ),
                                                          Text(
                                                            ann.sender,
                                                            style: textTheme
                                                                .bodySmall
                                                                ?.copyWith(
                                                                  color:
                                                                      Colors
                                                                          .grey,
                                                                ),
                                                          ),
                                                          const Spacer(),
                                                          Text(
                                                            formatTimestamp(
                                                              ann.timestamp,
                                                            ),
                                                            style:
                                                                textTheme
                                                                    .bodySmall,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),

                                    const SizedBox(height: 24),

                                    Padding(
                                      padding: kPaddingBody.copyWith(bottom: 4),
                                      child: Text(
                                        'Featured Farms',
                                        style: textTheme.titleLarge,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 225,
                                      child: ListView.builder(
                                        padding: kPaddingBody.copyWith(
                                          right: 4,
                                        ),
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            farms.length > 8 ? 8 : farms.length,
                                        itemBuilder: (context, index) {
                                          final farm = farms[index];
                                          final img =
                                              (farm.imageUrl != null &&
                                                      farm.imageUrl!.isNotEmpty)
                                                  ? "${dotenv.env['DOMAIN']}:${dotenv.env['PORT']}${farm.imageUrl}"
                                                  : 'assets/images/farm_placeholder.jpg';

                                          return Container(
                                            width: 280,
                                            margin: const EdgeInsets.only(
                                              right: 12,
                                            ),
                                            decoration: BoxDecoration(
                                              color: kWhiteColor,
                                              borderRadius: kBorderRadiusSmall,
                                            ),
                                            child: InkWell(
                                              borderRadius: kBorderRadiusSmall,
                                              onTap: () {
                                                developer.log(farm.name);
                                              },
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.vertical(
                                                          top: Radius.circular(
                                                            12,
                                                          ),
                                                        ),
                                                    child:
                                                        img.startsWith(
                                                              'assets/',
                                                            )
                                                            ? Image.asset(
                                                              img,
                                                              height: 120,
                                                              width:
                                                                  double
                                                                      .infinity,
                                                              fit: BoxFit.cover,
                                                            )
                                                            : Image.network(
                                                              img,
                                                              height: 120,
                                                              width:
                                                                  double
                                                                      .infinity,
                                                              fit: BoxFit.cover,
                                                            ),
                                                  ),
                                                  Padding(
                                                    padding: kPaddingCard,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          farm.name,
                                                          style:
                                                              textTheme
                                                                  .titleMedium,
                                                          maxLines: 1,
                                                          overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                        ),
                                                        const SizedBox(
                                                          height: 2,
                                                        ),
                                                        Text(
                                                          'Variety: ${farm.pineappleVariety}',
                                                          style: textTheme
                                                              .titleSmall
                                                              ?.copyWith(
                                                                color:
                                                                    kPrimaryColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        ),
                                                        const SizedBox(
                                                          height: 2,
                                                        ),
                                                        Text(
                                                          'Size: ${farm.size}',
                                                          style:
                                                              textTheme
                                                                  .bodySmall,
                                                        ),
                                                        const SizedBox(
                                                          height: 2,
                                                        ),
                                                        Text(
                                                          '${farm.address}, ${farm.city} ${farm.postcode}',
                                                          style: textTheme
                                                              .bodySmall
                                                              ?.copyWith(
                                                                color:
                                                                    Colors
                                                                        .grey[600],
                                                              ),
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
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 32),
                                  ],
                                ),
                              ),
                            ),
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, int value, IconData icon) {
    return Expanded(
      child: Container(
        padding: kPaddingCard.copyWith(top: 16, bottom: 16),
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: kBorderRadiusMedium,
        ),
        child: Column(
          children: [
            FaIcon(icon, color: kPrimaryColor, size: kIconSizeMedium),
            const SizedBox(height: 8),
            Text(
              value.toString(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 18,
                color: kPrimaryColor,
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
