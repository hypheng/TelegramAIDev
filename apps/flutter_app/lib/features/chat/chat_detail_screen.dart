import 'dart:async';

import 'package:flutter/material.dart';

import '../../shared/assets/shared_models.dart';
import 'local_chat_controller.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({
    super.key,
    required this.conversation,
    required this.chatDetailCopy,
    required this.chatDetailData,
    required this.onBack,
    this.sendExecutor,
    this.now,
  });

  final ChatConversation conversation;
  final ChatDetailCopy chatDetailCopy;
  final ChatDetailData chatDetailData;
  final VoidCallback onBack;
  final LocalMessageSendExecutor? sendExecutor;
  final DateTime Function()? now;

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  late final TextEditingController _textController;
  late final ScrollController _scrollController;
  late final LocalChatController _localChatController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _scrollController = ScrollController();
    _localChatController = LocalChatController(
      initialMessages: widget.chatDetailData.messages,
      localSendBehavior: widget.chatDetailData.localSendBehavior,
      sendExecutor: widget.sendExecutor ?? _defaultSendExecutor,
    )..addListener(_handleChatChanged);
    _textController.addListener(_handleComposerChanged);
  }

  @override
  void dispose() {
    _textController
      ..removeListener(_handleComposerChanged)
      ..dispose();
    _localChatController
      ..removeListener(_handleChatChanged)
      ..dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return AnimatedBuilder(
      animation: _localChatController,
      builder: (BuildContext context, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: widget.onBack,
              tooltip: 'Back',
              icon: const Icon(Icons.arrow_back_rounded),
            ),
            titleSpacing: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  widget.conversation.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  widget.chatDetailData.subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    key: PageStorageKey<String>(
                      'chat-detail-${widget.conversation.id}',
                    ),
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    itemCount: _localChatController.messages.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return _DateSeparator(
                          label: widget.chatDetailData.dateLabel,
                        );
                      }
                      final ChatDetailMessage message =
                          _localChatController.messages[index - 1];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _MessageBubble(message: message),
                      );
                    },
                  ),
                ),
                if (_localChatController.failedMessage != null)
                  _SendFailureNotice(
                    message: widget.chatDetailCopy.sendFailureNotice,
                    onRetry: _retryFailedMessage,
                  ),
                _ComposerBar(
                  controller: _textController,
                  placeholder: widget.chatDetailData.composerPlaceholder.isEmpty
                      ? widget.chatDetailCopy.composerPlaceholder
                      : widget.chatDetailData.composerPlaceholder,
                  sendLabel: widget.chatDetailCopy.sendLabel,
                  isSending: _localChatController.isSending,
                  canSend:
                      _textController.text.trim().isNotEmpty &&
                      !_localChatController.isSending,
                  onSend: _sendCurrentMessage,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _sendCurrentMessage() async {
    final DateTime createdAt = (widget.now ?? DateTime.now)();
    await _localChatController.sendMessage(
      text: _textController.text,
      createdAt: createdAt,
      timeLabel: _formatTime(createdAt),
    );
    if (!mounted) {
      return;
    }
    if (widget.chatDetailData.localSendBehavior.clearComposerOnSuccess &&
        _localChatController.failedMessage == null) {
      _textController.clear();
    }
  }

  Future<void> _retryFailedMessage() async {
    await _localChatController.retryFailedMessage();
    if (!mounted) {
      return;
    }
    if (widget.chatDetailData.localSendBehavior.clearComposerOnSuccess &&
        _localChatController.failedMessage == null) {
      _textController.clear();
    }
  }

  void _handleChatChanged() {
    if (!mounted) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) {
        return;
      }
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
      );
    });
  }

  void _handleComposerChanged() {
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Future<void> _defaultSendExecutor(LocalMessageDraft draft) {
    return Future<void>.delayed(const Duration(milliseconds: 350));
  }

  String _formatTime(DateTime value) {
    final String hour = value.hour.toString().padLeft(2, '0');
    final String minute = value.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class _DateSeparator extends StatelessWidget {
  const _DateSeparator({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final ChatDetailMessage message;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool outgoing = message.isOutgoing;
    final Color bubbleColor = outgoing
        ? theme.colorScheme.primaryContainer
        : theme.colorScheme.surfaceContainerLow;
    final Color textColor = outgoing
        ? theme.colorScheme.onPrimaryContainer
        : theme.colorScheme.onSurface;

    return Align(
      alignment: outgoing ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  message.text,
                  style: theme.textTheme.bodyLarge?.copyWith(color: textColor),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      message.timeLabel,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: textColor.withValues(alpha: 0.7),
                      ),
                    ),
                    if (message.deliveryLabel != null) ...<Widget>[
                      const SizedBox(width: 6),
                      Tooltip(
                        message: _deliveryLabel(message.deliveryLabel!),
                        child: Icon(
                          _deliveryIcon(message.deliveryLabel!),
                          size: 16,
                          color: textColor.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _deliveryIcon(String label) {
    switch (label) {
      case 'pending':
      case 'pending-local':
        return Icons.schedule_rounded;
      case 'failed':
        return Icons.error_outline_rounded;
      case 'sent-read':
        return Icons.done_all_rounded;
      case 'sent':
      default:
        return Icons.done_rounded;
    }
  }

  String _deliveryLabel(String label) {
    switch (label) {
      case 'pending':
      case 'pending-local':
        return 'Pending';
      case 'failed':
        return 'Failed';
      case 'sent-read':
        return 'Read';
      case 'sent':
      default:
        return 'Sent';
    }
  }
}

class _ComposerBar extends StatelessWidget {
  const _ComposerBar({
    required this.controller,
    required this.placeholder,
    required this.sendLabel,
    required this.isSending,
    required this.canSend,
    required this.onSend,
  });

  final TextEditingController controller;
  final String placeholder;
  final String sendLabel;
  final bool isSending;
  final bool canSend;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(
            top: BorderSide(color: theme.colorScheme.outlineVariant),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: TextField(
                key: const ValueKey<String>('chat-composer-input'),
                controller: controller,
                enabled: !isSending,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.send,
                onSubmitted: canSend ? (_) => onSend() : null,
                decoration: InputDecoration(
                  hintText: placeholder,
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            IconButton.filled(
              key: const ValueKey<String>('chat-composer-send'),
              onPressed: canSend ? onSend : null,
              tooltip: sendLabel,
              icon: isSending
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send_rounded),
            ),
          ],
        ),
      ),
    );
  }
}

class _SendFailureNotice extends StatelessWidget {
  const _SendFailureNotice({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 12, 4),
      color: theme.colorScheme.errorContainer,
      child: Row(
        children: <Widget>[
          Icon(
            Icons.error_outline_rounded,
            size: 18,
            color: theme.colorScheme.onErrorContainer,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
