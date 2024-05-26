import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:open_ai_chatgpt/constants/constants.dart';
import 'package:open_ai_chatgpt/widgets/ai_chat_stream_widget.dart';
import 'package:open_ai_chatgpt/widgets/comments_stream_widget.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key, required this.fromScreen, this.postData}) : super(key: key);

  final FromScreen fromScreen;
  final dynamic postData;

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final ScrollController messagesController = ScrollController();

  @override
  void dispose() {
    messagesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return widget.fromScreen == FromScreen.aIChatScreen
        ? AIChatStreamWidget(messagesController: messagesController)
        : CommentsStreamWidget(messagesController: messagesController, postData: widget.postData);
  }
}


