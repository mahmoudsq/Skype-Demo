import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:skypeclone/provider/user_provider.dart';
import 'package:skypeclone/screens/callscreens/pickup/pickup_layout.dart';
import 'package:skypeclone/screens/pageviews/chat_list_screen.dart';
import 'package:skypeclone/utils/universal_variables.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController pageController ;
  int _page = 0;
  UserProvider userProvider;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      userProvider = Provider.of(context,listen: false);
      userProvider.refreshUser();
    });
    pageController = PageController();
  }
  void onPageChanged(int page){
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page){
    pageController.jumpToPage(page);
  }
  @override
  Widget build(BuildContext context) {
    double _lableFontSize = 10;
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        body: PageView(
          controller: pageController,
          onPageChanged: onPageChanged,
          physics: NeverScrollableScrollPhysics(),
          children: [
            Center(child: ChatListScreen(),),
            Center(child: Text('Call Logs', style: TextStyle(color: Colors.white)),),
            Center(child: Text('Contact Screen', style: TextStyle(color: Colors.white)),)
          ],
        ),
        bottomNavigationBar: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: CupertinoTabBar(
              backgroundColor: UniversalVariables.blackColor,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.chat,
                color: (_page == 0) ? UniversalVariables.lightBlueColor : UniversalVariables.greyColor,),
                title: Text('Chat',
                style: TextStyle(fontSize: _lableFontSize,
                color: (_page == 0) ? UniversalVariables.lightBlueColor : UniversalVariables.greyColor),
                )),
                BottomNavigationBarItem(
                    icon: Icon(Icons.call,
                      color: (_page == 1) ? UniversalVariables.lightBlueColor : UniversalVariables.greyColor,),
                    title: Text('Calls',
                      style: TextStyle(fontSize: _lableFontSize,
                          color: (_page == 1) ? UniversalVariables.lightBlueColor : UniversalVariables.greyColor),
                    )),
                BottomNavigationBarItem(
                    icon: Icon(Icons.contact_phone,
                      color: (_page == 2) ? UniversalVariables.lightBlueColor : UniversalVariables.greyColor,),
                    title: Text('Contacts',
                      style: TextStyle(fontSize: _lableFontSize,
                          color: (_page == 2) ? UniversalVariables.lightBlueColor : UniversalVariables.greyColor),
                    )),
              ],
              currentIndex: _page,
              onTap: navigationTapped,
            ),
          ),
        ),
      ),
    );
  }
}
