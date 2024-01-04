import 'package:flutter/material.dart';
import 'package:kchat/Providers/ChatsProvider.dart';
import 'package:kchat/services/ws_manager.dart';
import 'package:kchat/widgets/MessageBox.dart';
import 'package:provider/provider.dart';
import '../models/chat.dart';
import 'package:collection/collection.dart';

class MessageView extends StatefulWidget {
  MessageView({super.key, required this.onChatIDChanged, this.showExtraData = false});

  final int? Function() onChatIDChanged;
  final bool showExtraData;

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  final ScrollController _scrollController = ScrollController();
  bool isChatOpening = true;
  double scrollValue = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<ChatsProvider, int>(
        selector: (_, provider) => provider.GetChatLength(widget.onChatIDChanged()),
        builder: (_, msgCount, __) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            int? actualChatID = widget.onChatIDChanged();
            if (actualChatID != null) {
              context.read<WS_Manager>().MarkMessagesAsRead(actualChatID);
              context.read<ChatsProvider>().UpdateUnreadMsgCount(widget.onChatIDChanged()!, 0);
            }
          });

          Chat? chat = context
              .read<ChatsProvider>()
              .chats
              .firstWhereOrNull((e) => e.chatID == widget.onChatIDChanged());

          if (chat == null || msgCount == 0 && chat.isMessagesLoaded) {
            return Center(child: Text('No messages yet.'));
          }
          else if (!chat.isMessagesLoaded) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            reverse: true,
            controller: _scrollController,
            itemCount: msgCount,
            itemBuilder: (context, index) {
              return MessageBox(chatID: chat.chatID, msg: chat.messages[(msgCount-1)-index], showExtraData: widget.showExtraData);
            });
        });
  }
}
