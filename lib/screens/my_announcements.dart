// lib/screens/my_announcements.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nanas_mobile/custom_widgets/custom_app_bar.dart';
import 'package:nanas_mobile/custom_widgets/custom_circular_progress_indicator.dart';
import 'package:nanas_mobile/custom_widgets/custom_icon_button.dart';
import 'package:nanas_mobile/helpers/image_viewer.dart';
import 'package:nanas_mobile/providers/announcement.dart';
import 'package:nanas_mobile/screens/add_announcement.dart';
import 'package:nanas_mobile/styles/colors.dart';
import 'package:nanas_mobile/styles/sizes.dart';
import 'package:nanas_mobile/utils/date.dart';

class MyAnnouncements extends ConsumerStatefulWidget {
  const MyAnnouncements({super.key});

  @override
  ConsumerState<MyAnnouncements> createState() => _MyAnnouncementsState();
}

class _MyAnnouncementsState extends ConsumerState<MyAnnouncements> {
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
      appBar: CustomAppBar(
        text: 'Isk Announcements',
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        titleColor: kWhiteColor,
        leadingIconColor: kWhiteColor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: CustomIconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddAnnouncement()),
                );
              },
              icon: FontAwesomeIcons.circlePlus,
              iconColor: kWhiteColor,
              iconSize: kIconSizeSmall,
            ),
          ),
        ],
      ),
      body: announcementsAsyncValue.when(
        loading: () => const Center(child: CustomCircularProgressIndicator()),
        error:
            (error, stack) => Center(
              child: Text('Error: $error', style: textTheme.bodyMedium),
            ),
        data: (announcements) {
          if (announcements.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FontAwesomeIcons.bullhorn, size: kIconSizeExtraHuge),
                  const SizedBox(height: 16),
                  Text('No announcements yet', style: textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    'Create your first announcement',
                    style: textTheme.bodySmall,
                  ),
                ],
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
                padding: const EdgeInsets.only(top: 16, bottom: 16, right: 12),
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemCount: announcements.length,
                itemBuilder: (context, index) {
                  final announcement = announcements[index];
                  final imagePath = 'assets/images/wp${(index % 4) + 1}.jpg';
                  return Container(
                    decoration: BoxDecoration(
                      color: kWhiteColor,
                      borderRadius: kBorderRadiusSmall,
                    ),
                    child: Slidable(
                      key: Key(announcement.id.toString()),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          CustomSlidableAction(
                            onPressed: (context) => () {},
                            borderRadius: kBorderRadiusSmall,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.trash,
                                  color: kErrorColor,
                                  size: kIconSizeSmall,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Delete',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: kErrorColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: kWhiteColor,
                          borderRadius: kBorderRadiusMedium,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap:
                                  () => ImageViewerHelper.viewImage(
                                    context,
                                    imagePath,
                                  ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                ),
                                child: Image.asset(
                                  width: 125,
                                  height: 100,
                                  imagePath,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: kPaddingCard,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      announcement.title,
                                      style: textTheme.titleMedium?.copyWith(
                                        color: kPrimaryColor,
                                      ),
                                    ),
                                    Text(
                                      formatTimestamp(announcement.timestamp),
                                      style: textTheme.bodySmall,
                                    ),
                                    Text(
                                      announcement.message,
                                      style: textTheme.bodySmall,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
