import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../shared/assets/shared_models.dart';

typedef LocalMessageSendExecutor =
    Future<void> Function(LocalMessageDraft draft);

class LocalMessageDraft {
  const LocalMessageDraft({required this.text, required this.createdAt});

  final String text;
  final DateTime createdAt;
}

class LocalChatController extends ChangeNotifier {
  LocalChatController({
    required List<ChatDetailMessage> initialMessages,
    required LocalSendBehavior localSendBehavior,
    required LocalMessageSendExecutor sendExecutor,
  }) : _messages = List<ChatDetailMessage>.of(initialMessages),
       _localSendBehavior = localSendBehavior,
       _sendExecutor = sendExecutor;

  final List<ChatDetailMessage> _messages;
  final LocalSendBehavior _localSendBehavior;
  final LocalMessageSendExecutor _sendExecutor;

  FailedLocalMessage? _failedMessage;
  bool _isSending = false;

  List<ChatDetailMessage> get messages =>
      List<ChatDetailMessage>.unmodifiable(_messages);

  FailedLocalMessage? get failedMessage => _failedMessage;

  bool get isSending => _isSending;

  Future<void> sendMessage({
    required String text,
    required DateTime createdAt,
    required String timeLabel,
  }) {
    final String trimmed = text.trim();
    if (trimmed.isEmpty || _isSending) {
      return Future<void>.value();
    }
    return _sendDraft(
      draft: LocalMessageDraft(text: trimmed, createdAt: createdAt),
      messageId: _messageId(createdAt),
      timeLabel: timeLabel,
    );
  }

  Future<void> retryFailedMessage() async {
    final FailedLocalMessage? failed = _failedMessage;
    if (failed == null || _isSending) {
      return;
    }
    await _sendDraft(
      draft: failed.draft,
      messageId: failed.messageId,
      timeLabel: failed.timeLabel,
      replacingFailedMessage: true,
    );
  }

  Future<void> _sendDraft({
    required LocalMessageDraft draft,
    required String messageId,
    required String timeLabel,
    bool replacingFailedMessage = false,
  }) async {
    final ChatDetailMessage pendingMessage = ChatDetailMessage(
      id: messageId,
      direction: ChatMessageDirection.outgoing,
      text: draft.text,
      timeLabel: timeLabel,
      deliveryLabel: _localSendBehavior.initialDeliveryState,
    );
    _isSending = true;
    _failedMessage = null;
    if (replacingFailedMessage) {
      _replaceMessage(pendingMessage);
    } else {
      _messages.add(pendingMessage);
    }
    notifyListeners();

    try {
      await _sendExecutor(draft);
      _replaceMessage(
        pendingMessage.copyWith(
          deliveryLabel: _localSendBehavior.settledDeliveryState,
        ),
      );
      _isSending = false;
      notifyListeners();
    } catch (_) {
      _replaceMessage(
        pendingMessage.copyWith(
          deliveryLabel: _localSendBehavior.failureDeliveryState,
        ),
      );
      _failedMessage = FailedLocalMessage(
        draft: draft,
        messageId: messageId,
        timeLabel: timeLabel,
      );
      _isSending = false;
      notifyListeners();
    }
  }

  String _messageId(DateTime createdAt) {
    return 'local-${createdAt.microsecondsSinceEpoch}';
  }

  void _replaceMessage(ChatDetailMessage message) {
    final int index = _messages.indexWhere(
      (ChatDetailMessage item) => item.id == message.id,
    );
    if (index == -1) {
      _messages.add(message);
      return;
    }
    _messages[index] = message;
  }
}

class FailedLocalMessage {
  const FailedLocalMessage({
    required this.draft,
    required this.messageId,
    required this.timeLabel,
  });

  final LocalMessageDraft draft;
  final String messageId;
  final String timeLabel;
}
