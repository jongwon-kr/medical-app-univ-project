import 'package:flutter/material.dart';
import 'package:medicalapp/chatGPT/model/model.dart';
import 'package:medicalapp/chatGPT/utils/colors.dart';

var chatBotImg =
    'https://github.com/jongwon-kr/flutterDEBG/blob/main/lib/assets/chatbot.png?raw=true';
var myQuestionImg =
    'https://github.com/jongwon-kr/flutterDEBG/blob/main/lib/assets/yellow%20question%20mark.png?raw=true';

class ChatMessageWidget extends StatelessWidget {
  const ChatMessageWidget(
      {super.key, required this.text, required this.chatMessageType});

  final String text;
  final ChatMessageType chatMessageType;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: const EdgeInsets.all(16),
      color: chatMessageType == ChatMessageType.bot
          ? ColorSets.botBackgroundColor
          : ColorSets.backgroundColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          chatMessageType == ChatMessageType.bot
              ? Container(
                  margin: const EdgeInsets.only(right: 16.0),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(chatBotImg),
                  ),
                )
              : Container(
                  margin: const EdgeInsets.only(right: 16.0),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(myQuestionImg),
                  ),
                ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  child: Text(
                    text,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
