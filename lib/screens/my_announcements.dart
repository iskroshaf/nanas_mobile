// lib/screens/my_announcements.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nanas_mobile/custom_widgets/custom_app_bar.dart';
import 'package:nanas_mobile/custom_widgets/custom_circular_progress_indicator.dart';
import 'package:nanas_mobile/custom_widgets/custom_icon_button.dart';
import 'package:nanas_mobile/custom_widgets/custom_snack_bar.dart';
import 'package:nanas_mobile/helpers/image_viewer.dart';
import 'package:nanas_mobile/providers/announcement.dart';
import 'package:nanas_mobile/screens/add_announcement.dart';
import 'package:nanas_mobile/styles/colors.dart';
import 'package:nanas_mobile/styles/sizes.dart';
import 'package:nanas_mobile/utils/date.dart';
import 'package:nanas_mobile/services/announcement.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MyAnnouncements extends ConsumerStatefulWidget {
  const MyAnnouncements({super.key});

  @override
  ConsumerState<MyAnnouncements> createState() => _MyAnnouncementsState();
}

class _MyAnnouncementsState extends ConsumerState<MyAnnouncements> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.invalidate(myAnnouncementProvider);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    ref.invalidate(myAnnouncementProvider);
    await ref.read(myAnnouncementProvider.future);
  }

  Future<void> _deleteAnnouncement(BuildContext context, int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Delete announcement?'),
            content: const Text(
              'Are you sure you want to delete this announcement?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: kErrorColor),
                ),
              ),
            ],
          ),
    );

    if (confirm != true) return;

    try {
      await AnnouncementService.deleteAnnouncement(id);
      ref.invalidate(myAnnouncementProvider);

      if (mounted) {
        CustomSnackBar.show(
          // ignore: use_build_context_synchronously
          context: context,
          message: 'Announcement deleted',
          type: SnackBarType.success,
        );
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar.show(
          // ignore: use_build_context_synchronously
          context: context,
          message: 'Failed to delete: $e',
          type: SnackBarType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final announcementsAsyncValue = ref.watch(myAnnouncementProvider);

    return Scaffold(
      backgroundColor: kBodyLightColor,
      appBar: CustomAppBar(
        text: 'My Announcements',
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
                  MaterialPageRoute(
                    builder: (context) => const AddAnnouncement(),
                  ),
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
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 80),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          FontAwesomeIcons.bullhorn,
                          size: kIconSizeExtraHuge,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No announcements yet',
                          style: textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Create your first announcement',
                          style: textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: Padding(
              padding: kPaddingBody.copyWith(right: 4),
              child: Scrollbar(
                controller: _scrollController,
                interactive: true,
                thumbVisibility: true,
                thickness: 6,
                child: ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(
                    top: 16,
                    bottom: 16,
                    right: 12,
                  ),
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemCount: announcements.length,
                  itemBuilder: (context, index) {
                    final announcement = announcements[index];

                    final fallbackAsset =
                        'assets/images/wp${(index % 4) + 1}.jpg';

                    String? fullImgUrl;
                    if (announcement.imageUrl != null &&
                        announcement.imageUrl!.isNotEmpty) {
                      fullImgUrl =
                          "${dotenv.env['DOMAIN']}:${dotenv.env['PORT']}${announcement.imageUrl}";
                    }

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
                              onPressed: (ctx) {
                                _deleteAnnouncement(context, announcement.id);
                              },
                              borderRadius: kBorderRadiusSmall,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const FaIcon(
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
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    bottomLeft: Radius.circular(8),
                                  ),
                                  child:
                                      fullImgUrl != null
                                          ? Image.network(
                                            fullImgUrl,
                                            width: 125,
                                            height: 100,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (_, __, ___) => Image.asset(
                                                  fallbackAsset,
                                                  width: 125,
                                                  height: 100,
                                                  fit: BoxFit.cover,
                                                ),
                                          )
                                          : Image.asset(
                                            fallbackAsset,
                                            width: 125,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: kPaddingCard,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
            ),
          );
        },
      ),
    );
  }
}
