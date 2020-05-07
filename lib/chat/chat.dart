
import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../listview/list_view.dart';
import '../chat/input_block.dart';
import 'package:provider/provider.dart';


import 'chat_data.dart';
import 'chat_item_builder.dart';


class Chat extends StatefulWidget {

  final String friendAvatar;
  final String friendName;

  Chat({@required this.friendAvatar, @required this.friendName});

  @override
  State<StatefulWidget> createState() => ChatState();

}

class ChatState extends State<Chat> {
  Random random = Random(DateTime.now().millisecondsSinceEpoch);
  StreamController<List<ChatDetail>> _streamController = StreamController<List<ChatDetail>>();
  List<ChatDetail> _list = [];

  @override
  void dispose() {
    super.dispose();
    _streamController?.close();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 200), () {
      _list = ChatDetail.getInitChatDetails(widget.friendName);
      _streamController.sink.add(_list.reversed.toList());
    });
  }

  void addChatDetail(ChatDetail chatDetail, [bool needsReply = true]) {
    if (chatDetail != null) {
      _list.add(chatDetail);
    }
    _streamController.sink.add(_list.reversed.toList());
    if (needsReply) {
      robotReply().then((chatDetail) {
        addChatDetail(chatDetail, false);
      });
    }
  }

  Future<ChatDetail> robotReply() async {
    var delay = random.nextInt(4) + 1;
    return await Future.delayed(Duration(seconds: delay), ()=> ChatDetail.randomChatDetail(false));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: Provider.of<InputState>(context).resizeToAvoidBottomPadding,
        appBar: AppBar(
          backgroundColor: Colors.indigo[800],
          title: Text(widget.friendName),),
        body: Container(
          color: Colors.grey[200],
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: (){
                    Provider.of<InputState>(context).showInputForm(inputTypeNone);
                  },
                  child: buildListView(),
                ),
              ),
              InputBlock(addChatDetail),
            ],
          ),
        ),
    );
  }

  StreamBuilder<List> buildListView() {
    final friendName = widget.friendName;
    final friendAvatar = widget.friendAvatar;
    return StreamBuilder(
      initialData: [],
      stream: _streamController.stream,
      builder: (context, snapshot) {
        return MultiTypeListView(
            reverse: true,
            items: snapshot.data,
            showDebugPlaceHolder: true,
            widgetBuilders: [
              StringChatDetailBuilder(friendName, friendAvatar), //builder for a string chat message
              EmojiChatDetailBuilder(friendName, friendAvatar), //builder for an emoji message
              ImageChatDetailBuilder(friendName, friendAvatar), //builder for an image message
              TimeMessageBuilder(), //builder to show time
            ],
            widgetBuilderForUnsupportedItemType: UnsupportedChatDetail(friendName, friendAvatar),
        );
      },
    );
  }

}

