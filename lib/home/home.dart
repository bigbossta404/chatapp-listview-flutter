
import 'package:flutter/material.dart';
import '../listview/list_view.dart';
import '../chat/chat.dart';
import '../chat/input_block.dart';
import 'package:provider/provider.dart';

import 'home_data.dart';
import 'home_item_builder.dart';

class Home extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Home> {
  var items = [];
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _initData().then((list){
      setState(() {
        items = list;
      });
    });
  }

  Future<List> _initData() async{
    var messages = Message.getMessages();
    var bannerItems = BannerItem.getBannerItems();
    return [
      messages[0],
      GroupMessage(messages),
      ...messages.sublist(1, 8)
    ];
  }

  @override
  Widget build(BuildContext context) {
    var onMessageTap = (context, item, index){
      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => InputState(),)
            ],
            child:Chat(friendName: item.title, friendAvatar: item.avatar,)
        );
      }));
    };
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[800],
        title: const Text('Chating Skuy'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              // do something
            },
          )
        ],
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: Text('Rd. Fakhri Fadhlan D'),
              accountEmail: Text('chatskuy@gmail.com'),
              currentAccountPicture: GestureDetector(
                child: new CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: ExactAssetImage('images/profile.jpg'),
                ),
              ),
              decoration: new BoxDecoration(
                color: Colors.indigo[800],
                border: Border(
                    bottom: BorderSide(
                        color: Colors.red[800],// set border color
                        width: 10.0
                    )
                ),
              ),
            ),
            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('Beranda'),
                leading: Icon(Icons.home),
              ),
            ),

            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('Akun Saya'),
                leading: Icon(Icons.person),
              ),
            ),

            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('Save File'),
                leading: Icon(Icons.bookmark),
              ),
            ),

            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('Favorit'),
                leading: Icon(Icons.favorite),
              ),
            ),
            Divider(),

            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('Pengaturan'),
                leading: Icon(Icons.settings),
              ),
            ),
            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('Tentang'),
                leading: Icon(Icons.help),
              ),
            ),
          ],
        ),
      ),
      body: MultiTypeListView(
        items: items,
        widgetBuilders: [
          GroupMessageItemBuilder(controller: controller, onItemTap: onMessageTap),
          MessageBuilder(onMessageTap),
        ],
        showDebugPlaceHolder: true,
        widgetBuilderForUnsupportedItemType: UpgradeAppVersionBuilder(),
        widgetWrapper: (widget, item, index) {
          return Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[200], width: 1),
              ),
            ),
            child: widget,
          );
        },
        // All parameters of the ListView.builder are supported except [ itemBuilder ]
        controller: controller,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }
}
