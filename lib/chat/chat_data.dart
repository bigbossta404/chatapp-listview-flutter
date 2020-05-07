
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';


const String kMyAvatar = 'images/profile.png';
const String kMyName = 'saya';

List<String> _chatDetails = [
  'wkwkwk','Yoii','minta tolong dong','Haii',
  'halo','seru bangett','canda ya lu!?','wkwk ngakak', 'ehh dah dulu ya',
  'Udud skuy','beliin gw udud!','seru juga ya','gk',
  'ahh kata siapa lu!','kamu gpp?','mantapp','lawak lo badut!',
];
Random random = Random(DateTime.now().millisecondsSinceEpoch);

Map<String, List<ChatDetail>> _cachedChatDetails = {};

class ChatDetail<T> {
  bool current;
  T content;

  ChatDetail(this.content, {this.current: true});

  static List<ChatDetail> getInitChatDetails(String friendName) {
    _cachedChatDetails[friendName] ??= (){
      List<ChatDetail> list = [];
      for(var i = 1; i <= 50; i++) {
        if(random.nextInt(100) < 8) {
          list.add(TimeMessage(DateTime.now()));
        }
        list.add(randomChatDetail(i % 2 == 0));
      }
      return list;
    }();
    return _cachedChatDetails[friendName];
  }

  static ChatDetail randomChatDetail(bool current) {
    int v = random.nextInt(100);
    if (v < 50) {
      return EmojiChatDetail(Emoji(random.nextInt(emojiTotalCount)), current: current);
    }
    return StringChatDetail(_chatDetails[random.nextInt(_chatDetails.length)], current: current);
  }

}

class StringChatDetail extends ChatDetail<String>{

  StringChatDetail(content, {bool current: true,}): super(content, current: current);

}

const emojiTotalCount = 116;
class Emoji {
  int code;
  Emoji(this.code);

  String get file {
    return 'images/emoji/emoji_${code < 10 ? '0' : ''}$code.png';
  }
}


class ImageChatDetail extends ChatDetail<File> {
  ImageChatDetail(File content, {bool current: true,}) : super(content, current: current);
  static File getRandomImageFile(BuildContext context) {
  }
}

class EmojiChatDetail extends ChatDetail<Emoji> {
  EmojiChatDetail(Emoji content, {bool current: true,}) : super(content, current: current);
}

class TimeMessage extends ChatDetail<DateTime> {
  TimeMessage(DateTime content) : super(content);
}