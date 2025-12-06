// lib/screens/chat.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'package:nanas_mobile/custom_widgets/custom_icon_button.dart';
import 'package:nanas_mobile/models/chat_message.dart';
import 'package:nanas_mobile/services/chat_service.dart';
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

  List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String _streamingMessage = '';
  bool _isStreaming = false;

  Timer? _typingTimer;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    _focusNode.dispose();
    _typingTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    final msgs = await ChatService.loadMessages();
    setState(() {
      _messages = msgs;
    });
  }

  Future<void> _saveMessages() async {
    await ChatService.saveMessages(_messages);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty || _isLoading) return;

    final userMessage = ChatMessage(
      sender: ChatSender.user,
      message: text.trim(),
      sentAt: DateTime.now(),
    );

    setState(() {
      _messages.add(userMessage);
      _isLoading = true;
      _isStreaming = true;
      _streamingMessage = '';
    });

    await _saveMessages();
    _scrollToBottom();

    try {
      final aiFullResponse = await ChatService.sendMessageToAI(text.trim());

      await _streamResponse(aiFullResponse);

      final aiMessage = ChatMessage(
        sender: ChatSender.ai,
        message: aiFullResponse,
        sentAt: DateTime.now(),
      );

      setState(() {
        _messages.add(aiMessage);
        _isLoading = false;
        _isStreaming = false;
        _streamingMessage = '';
      });

      await _saveMessages();
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isStreaming = false;
        _streamingMessage = '';
        _messages.remove(userMessage);
      });
      await _saveMessages();

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _streamResponse(String fullResponse) async {
    final words = fullResponse.split(' ');
    _typingTimer?.cancel();

    for (int i = 0; i < words.length; i++) {
      await Future.delayed(const Duration(milliseconds: 50));
      if (!mounted) return;
      setState(() {
        _streamingMessage += (i == 0 ? '' : ' ') + words[i];
      });
      _scrollToBottom();
    }
  }

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Message'),
            content: const Text(
              'Are you sure you want to delete this message?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  setState(() {
                    _messages.removeAt(index);
                  });
                  await _saveMessages();
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  void _clearAllMessages() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Clear All Messages'),
            content: const Text(
              'Are you sure you want to delete all messages?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  setState(() {
                    _messages.clear();
                  });
                  await ChatService.clearMessages();
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                },
                child: const Text(
                  'Clear All',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final bool isEmpty = _messages.isEmpty && !_isStreaming;

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
                          'AI Chat Assistant',
                          style: textTheme.titleLarge?.copyWith(
                            color: kWhiteColor,
                          ),
                        ),
                        Text(
                          'Ask me anything about farming',
                          style: textTheme.bodyMedium?.copyWith(
                            color: kWhiteColor,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    if (_messages.isNotEmpty)
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: kWhiteColor,
                        ),
                        onPressed: _clearAllMessages,
                      ),
                  ],
                ),
              ),

              Expanded(
                child: Container(
                  color: kWhiteColor,
                  child:
                      isEmpty
                          ? _buildEmptyState(textTheme)
                          : Scrollbar(
                            controller: scrollController,
                            interactive: true,
                            thumbVisibility: true,
                            thickness: 6,
                            child: ListView.builder(
                              reverse: true,
                              controller: scrollController,
                              padding: const EdgeInsets.all(8),
                              itemCount:
                                  _messages.length + (_isStreaming ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == 0 && _isStreaming) {
                                  return _buildStreamingMessage();
                                }

                                final actualIndex =
                                    _isStreaming ? index - 1 : index;
                                final reversedIndex =
                                    _messages.length - 1 - actualIndex;
                                final msg = _messages[reversedIndex];

                                return _buildMessageBubble(
                                  msg,
                                  reversedIndex,
                                  textTheme,
                                );
                              },
                            ),
                          ),
                ),
              ),

              // INPUT
              _buildMessageInput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(TextTheme textTheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.commentDots,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'No messages yet',
            style: textTheme.titleMedium?.copyWith(color: Colors.grey.shade400),
          ),
          const SizedBox(height: 8),
          Text(
            'Start a conversation with AI',
            style: textTheme.bodyMedium?.copyWith(color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  Widget _buildStreamingMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            border: Border.all(color: Colors.grey.shade200, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: kPrimaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      FontAwesomeIcons.robot,
                      size: 14,
                      color: kPrimaryColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'AI Assistant',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                      fontSize: kFontSizeSmall,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              MarkdownBody(
                data: _streamingMessage,
                styleSheet: MarkdownStyleSheet(
                  p: TextStyle(
                    fontSize: kFontSizeMedium,
                    color: kTextColorHigh,
                  ),
                  strong: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kTextColorHigh,
                  ),
                  h1: TextStyle(
                    fontSize: kFontSizeLarge,
                    fontWeight: FontWeight.bold,
                    color: kTextColorHigh,
                  ),
                  h2: TextStyle(
                    fontSize: kFontSizeMedium + 2,
                    fontWeight: FontWeight.bold,
                    color: kTextColorHigh,
                  ),
                  tableBody: TextStyle(fontSize: kFontSizeSmall),
                  tableHead: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: kFontSizeSmall,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Typing...',
                    style: TextStyle(
                      fontSize: kFontSizeSmall,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg, int index, TextTheme textTheme) {
    final bool isUser = msg.isUser;
    final sentAt = msg.sentAt.toLocal();
    final formattedTime = DateFormat('HH:mm').format(sentAt);

    return GestureDetector(
      onLongPress: () => _showDeleteDialog(index),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth:
                MediaQuery.of(context).size.width * (isUser ? 0.75 : 0.85),
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isUser ? kPrimaryColor : Colors.grey.shade100,
              borderRadius:
                  isUser
                      ? const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      )
                      : const BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
              border: Border.all(
                color: isUser ? kPrimaryColor : Colors.grey.shade200,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isUser) ...[
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: kPrimaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          FontAwesomeIcons.robot,
                          size: 14,
                          color: kPrimaryColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'AI Assistant',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor,
                          fontSize: kFontSizeSmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
                isUser
                    ? Text(
                      msg.message,
                      style: textTheme.bodyMedium?.copyWith(color: kWhiteColor),
                    )
                    : MarkdownBody(
                      data: msg.message,
                      styleSheet: MarkdownStyleSheet(
                        p: TextStyle(
                          fontSize: kFontSizeMedium,
                          color: kTextColorHigh,
                        ),
                        strong: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: kTextColorHigh,
                        ),
                        h1: TextStyle(
                          fontSize: kFontSizeLarge,
                          fontWeight: FontWeight.bold,
                          color: kTextColorHigh,
                        ),
                        h2: TextStyle(
                          fontSize: kFontSizeMedium + 2,
                          fontWeight: FontWeight.bold,
                          color: kTextColorHigh,
                        ),
                        tableBody: TextStyle(fontSize: kFontSizeSmall),
                        tableHead: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: kFontSizeSmall,
                        ),
                      ),
                    ),
                const SizedBox(height: 6),
                Text(
                  formattedTime,
                  style: textTheme.bodySmall?.copyWith(
                    color:
                        isUser
                            ? kWhiteColor.withOpacity(0.8)
                            : Colors.grey.shade500,
                    fontSize: kFontSizeSmall - 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: kWhiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
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
                child: TextField(
                  controller: messageController,
                  focusNode: _focusNode,
                  enabled: !_isLoading,
                  decoration: InputDecoration(
                    hintText:
                        _isLoading ? 'Please wait...' : 'Ask me anything...',
                    hintStyle: TextStyle(
                      fontFamily: 'myFont',
                      fontSize: kFontSizeMedium,
                      color: kTextColorLow,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
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
                  onSubmitted: (value) {
                    if (!_isLoading && value.trim().isNotEmpty) {
                      _sendMessage(value);
                      messageController.clear();
                    }
                  },
                ),
              ),
            ),
            const SizedBox(width: 8),
            CustomIconButton(
              icon:
                  _isLoading
                      ? FontAwesomeIcons.spinner
                      : FontAwesomeIcons.paperPlane,
              onPressed:
                  _isLoading
                      ? null
                      : () {
                        final text = messageController.text.trim();
                        if (text.isNotEmpty) {
                          _sendMessage(text);
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
