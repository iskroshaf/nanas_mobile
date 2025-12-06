// lib/screens/announcement.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nanas_mobile/custom_widgets/custom_circular_progress_indicator.dart';
import 'package:nanas_mobile/custom_widgets/custom_icon_button.dart';
import 'package:nanas_mobile/helpers/image_viewer.dart';
import 'package:nanas_mobile/providers/announcement.dart';
import 'package:nanas_mobile/screens/my_announcements.dart';
import 'package:nanas_mobile/styles/colors.dart';
import 'package:nanas_mobile/styles/sizes.dart';
import 'package:nanas_mobile/utils/date.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:developer' as developer;

class Announcements extends ConsumerStatefulWidget {
  const Announcements({super.key});

  @override
  ConsumerState<Announcements> createState() => _AnnouncementsState();
}

class _AnnouncementsState extends ConsumerState<Announcements> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    ref.invalidate(announcementProvider);
    await ref.read(announcementProvider.future);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final announcementsAsyncValue = ref.watch(announcementProvider);

    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
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
                        'Announcements',
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
                      // Pergi ke MyAnnouncements
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyAnnouncements(),
                        ),
                      );

                      if (!mounted) return;
                      ref.invalidate(announcementProvider);
                    },
                    icon: FontAwesomeIcons.bullhorn,
                    iconColor: kWhiteColor,
                    iconSize: kIconSizeSmall,
                  ),
                ],
              ),
            ),

            Expanded(
              child: announcementsAsyncValue.when(
                loading:
                    () =>
                        const Center(child: CustomCircularProgressIndicator()),
                error:
                    (error, stack) => Center(
                      child: Text('$error', style: textTheme.bodyMedium),
                    ),
                data: (announcements) {
                  return RefreshIndicator(
                    onRefresh: _refresh,
                    child:
                        announcements.isEmpty
                            ? Container(
                              color: kBodyLightColor,
                              child: ListView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                children: [
                                  const SizedBox(height: 80),
                                  Center(
                                    child: Text(
                                      'No announcements found.',
                                      style: textTheme.bodyMedium,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            : Container(
                              color: kBodyLightColor,
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
                                  itemCount: announcements.length,
                                  itemBuilder: (context, index) {
                                    final announcement = announcements[index];

                                    final fallbackAsset =
                                        'assets/images/wp${(index % 4) + 1}.jpg';

                                    String? fullImgUrl;
                                    if (announcement.imageUrl != null &&
                                        announcement.imageUrl!
                                            .toString()
                                            .isNotEmpty) {
                                      fullImgUrl =
                                          "${dotenv.env['DOMAIN']}:${dotenv.env['PORT']}${announcement.imageUrl}";
                                    }

                                    return GestureDetector(
                                      onTap: () {
                                        developer.log(announcement.title);
                                      },
                                      child: Column(
                                        children: [
                                          if (index == 0)
                                            const SizedBox(height: 10),
                                          Container(
                                            padding: kPaddingCard,
                                            height: 250,
                                            decoration: BoxDecoration(
                                              color: kWhiteColor,
                                              borderRadius: kBorderRadiusSmall,
                                            ),
                                            child: Column(
                                              children: [
                                                // Row atas: avatar + sender + farm + timestamp
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: 20,
                                                      height: 20,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                          image:
                                                              fullImgUrl != null
                                                                  ? NetworkImage(
                                                                    fullImgUrl,
                                                                  )
                                                                  : AssetImage(
                                                                        fallbackAsset,
                                                                      )
                                                                      as ImageProvider,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      announcement.sender,
                                                      style:
                                                          textTheme.bodyMedium,
                                                    ),
                                                    const Spacer(),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Text(
                                                          announcement.farm,
                                                          style: textTheme
                                                              .titleSmall
                                                              ?.copyWith(
                                                                color:
                                                                    kPrimaryColor,
                                                              ),
                                                        ),
                                                        Text(
                                                          formatTimestamp(
                                                            announcement
                                                                .timestamp,
                                                          ),
                                                          style:
                                                              textTheme
                                                                  .bodySmall,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),

                                                const SizedBox(height: 4),

                                                // Gambar utama
                                                GestureDetector(
                                                  onTap: () {
                                                    if (fullImgUrl != null) {
                                                      ImageViewerHelper.viewImage(
                                                        context,
                                                        fullImgUrl,
                                                      );
                                                    } else {
                                                      ImageViewerHelper.viewImage(
                                                        context,
                                                        fallbackAsset,
                                                      );
                                                    }
                                                  },
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        kBorderRadiusSmall,
                                                    child:
                                                        fullImgUrl != null
                                                            ? Image.network(
                                                              fullImgUrl,
                                                              height: 125,
                                                              width:
                                                                  double
                                                                      .infinity,
                                                              fit: BoxFit.cover,
                                                              errorBuilder:
                                                                  (
                                                                    _,
                                                                    __,
                                                                    ___,
                                                                  ) => Image.asset(
                                                                    fallbackAsset,
                                                                    height: 125,
                                                                    width:
                                                                        double
                                                                            .infinity,
                                                                    fit:
                                                                        BoxFit
                                                                            .cover,
                                                                  ),
                                                            )
                                                            : Image.asset(
                                                              fallbackAsset,
                                                              height: 125,
                                                              width:
                                                                  double
                                                                      .infinity,
                                                              fit: BoxFit.cover,
                                                            ),
                                                  ),
                                                ),

                                                const SizedBox(height: 8),

                                                // Title + message
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      announcement.title,
                                                      style: textTheme
                                                          .titleMedium
                                                          ?.copyWith(
                                                            color:
                                                                kPrimaryColor,
                                                          ),
                                                    ),
                                                    Text(
                                                      announcement.message,
                                                      style:
                                                          textTheme.bodySmall,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (index == announcements.length - 1)
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
    );
  }
}
