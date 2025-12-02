import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:nanas_mobile/custom_widgets/custom_icon_button.dart';
import 'package:nanas_mobile/styles/colors.dart';
import 'package:nanas_mobile/styles/sizes.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  final List<Map<String, dynamic>> messages = [
    {
      'sender_profile_id': 'Ali',
      'message': 'Hey, how are you?',
      'sent_at': '2023-01-08T10:30:00Z',
      'is_read': true,
    },
    {
      'sender_profile_id': 'Other',
      'message': 'I am good, thanks!',
      'sent_at': '2023-01-08T10:32:00Z',
      'is_read': true,
    },
  ];

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => _focusNode.unfocus(),
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
                          'Chat',
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
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: kWhiteColor,
                  child: Scrollbar(
                    controller: scrollController,
                    interactive: true,
                    thumbVisibility: true,
                    thickness: 6,
                    child: ListView.separated(
                      reverse: true,
                      controller: scrollController,
                      padding: const EdgeInsets.only(bottom: 8, right: 8),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final reversedIndex = messages.length - 1 - index;
                        final message = messages[reversedIndex];
                        final bool isSender =
                            message['sender_profile_id'] == 'Ali';
                        final DateTime sentAt =
                            DateTime.parse(message['sent_at']).toLocal();
                        final String formattedTime = DateFormat(
                          'HH:mm',
                        ).format(sentAt);
                        final bool isRead = message['is_read'] ?? false;

                        final BorderRadius borderRadius =
                            isSender
                                ? const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                )
                                : const BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                );

                        final bool showDateHeader =
                            reversedIndex == messages.length - 1;

                        return Column(
                          children: [
                            if (showDateHeader)
                              Center(
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: kBorderRadiusMedium,
                                  ),
                                  child: Text(
                                    DateFormat('d MMMM yyyy').format(sentAt),
                                    style: textTheme.bodySmall,
                                  ),
                                ),
                              ),
                            Align(
                              alignment:
                                  isSender
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.75,
                                ),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 2,
                                    horizontal: 8,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        isSender
                                            ? kPrimaryColor
                                            : Colors.grey.shade100,
                                    borderRadius: borderRadius,
                                    border: Border.all(
                                      color: Colors.grey.shade200,
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        message['message'] ?? '',
                                        style: textTheme.bodyMedium?.copyWith(
                                          color:
                                              isSender
                                                  ? kWhiteColor
                                                  : kTextColorMedium,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            formattedTime,
                                            style: textTheme.bodySmall
                                                ?.copyWith(
                                                  color:
                                                      isSender
                                                          ? kWhiteColor
                                                          : kTextColorMedium,
                                                ),
                                          ),
                                          if (isSender) ...[
                                            const SizedBox(width: 6),
                                            Icon(
                                              isRead
                                                  ? Icons.done_all
                                                  : Icons.done,
                                              size: kIconSizeSmall,
                                              color:
                                                  isRead
                                                      ? kPrimaryColor
                                                      : kIconColor,
                                            ),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox.shrink(),
                    ),
                  ),
                ),
              ),
              _buildMessageInput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: kWhiteColor,
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: kBodyLightColor,
                  borderRadius: kBorderRadiusFull,
                  border: Border.all(color: Colors.grey.shade200, width: 1),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          hintText: 'Type your message...',
                          hintStyle: TextStyle(
                            fontFamily: 'myFont',
                            fontSize: kFontSizeMedium,
                            color: kTextColorLow,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                        ),
                        style: TextStyle(
                          fontFamily: 'myFont',
                          fontSize: kFontSizeMedium,
                          color: kTextColorHigh,
                        ),
                        maxLines: 5,
                        minLines: 1,
                        onSubmitted: (_) => () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            CustomIconButton(
              icon: FontAwesomeIcons.paperPlane,
              onPressed: () {
                if (messageController.text.trim().isNotEmpty) {
                  messageController.clear();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
