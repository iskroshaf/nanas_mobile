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
import 'dart:developer' as developer;

class Announcements extends ConsumerStatefulWidget {
  const Announcements({super.key});

  @override
  ConsumerState<Announcements> createState() => _AnnouncementsState();
}

class _AnnouncementsState extends ConsumerState<Announcements> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
                  Spacer(),
                  CustomIconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyAnnouncements(),
                        ),
                      );
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
                  if (announcements.isEmpty) {
                    return Center(
                      child: Text(
                        'No Vendor found.',
                        style: textTheme.bodyMedium,
                      ),
                    );
                  }
                  return Container(
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
                        padding: const EdgeInsets.only(right: 12),
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemCount: announcements.length,
                        itemBuilder: (context, index) {
                          final announcement = announcements[index];
                          final imagePath =
                              'assets/images/wp${(index % 4) + 1}.jpg';
                          return GestureDetector(
                            onTap: () {
                              developer.log(announcement.title);
                            },
                            child: Column(
                              children: [
                                if (index == 0) const SizedBox(height: 10),
                                Container(
                                  padding: kPaddingCard,
                                  height: 250,
                                  decoration: BoxDecoration(
                                    color: kWhiteColor,
                                    borderRadius: kBorderRadiusSmall,
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                image: AssetImage(imagePath),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            announcement.sender,
                                            style: textTheme.bodyMedium,
                                          ),
                                          Spacer(),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                announcement.farm,
                                                style: textTheme.titleSmall
                                                    ?.copyWith(
                                                      color: kPrimaryColor,
                                                    ),
                                              ),
                                              Text(
                                                formatTimestamp(
                                                  announcement.timestamp,
                                                ),
                                                style: textTheme.bodySmall,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 4),
                                      GestureDetector(
                                        onTap:
                                            () => ImageViewerHelper.viewImage(
                                              context,
                                              imagePath,
                                            ),
                                        child: ClipRRect(
                                          borderRadius: kBorderRadiusSmall,
                                          child: Image.asset(
                                            height: 125,
                                            width: double.infinity,
                                            imagePath,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            announcement.title,
                                            style: textTheme.titleMedium
                                                ?.copyWith(
                                                  color: kPrimaryColor,
                                                ),
                                          ),
                                          Text(
                                            announcement.message,
                                            style: textTheme.bodySmall,
                                            maxLines: 2,
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
