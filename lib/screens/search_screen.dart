import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skypeclone/models/userModel.dart';
import 'package:skypeclone/resources/firebase_repository.dart';
import 'package:skypeclone/utils/universal_variables.dart';
import 'package:skypeclone/widgets/custom_tile.dart';

import 'chatscreens/chat_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  FirebaseRepository _repository = FirebaseRepository();

  List<UserModel> userList;
  String query = "";
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _repository.getCurrentUser().then((User value) {
      _repository.fetchAllUsers(value).then((List<UserModel> list) {
        setState(() {
          userList = list;
        });
      });
    });
  }

  searchAppBar(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  UniversalVariables.gradientColorStart,
                  UniversalVariables.gradientColorEnd,
                ],
              ),
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight + 20),
            child: Padding(
              padding: EdgeInsets.only(left: 20),
              child: TextField(
                controller: searchController,
                onChanged: (val) {
                  setState(() {
                    query = val;
                  });
                },
                cursorColor: UniversalVariables.blackColor,
                autofocus: true,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 35,
                ),
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      WidgetsBinding.instance.addPostFrameCallback(
                          (_) => searchController.clear());
                    },
                  ),
                  border: InputBorder.none,
                  hintText: "Search",
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                    color: Color(0x88ffffff),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  buildSuggestions(String query) {
    final List<UserModel> suggestionList = query.isEmpty
        ? []
        : userList
            .where((element) =>
                (element.username
                    .toLowerCase()
                    .contains(query.toLowerCase())) ||
                (element.name.toLowerCase().contains(query.toLowerCase())))
            .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        UserModel searchUser = UserModel(
            username: suggestionList[index].username,
            name: suggestionList[index].name,
            uid: suggestionList[index].uid,
            profilePhoto: suggestionList[index].profilePhoto);
        return CustomTile(
          mini: false,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(receiver: searchUser,),));
    },
          leading: CircleAvatar(
            backgroundImage: NetworkImage(searchUser.profilePhoto),
            backgroundColor: Colors.grey,
          ),
          title: Text(
            searchUser.username,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            searchUser.name,
            style: TextStyle(color: UniversalVariables.greyColor),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        //appBar: searchAppBar(context),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 150,
                child: searchAppBar(context),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                height: 500,
                child: buildSuggestions(query),
              )
            ],
          ),
        ));
  }
}

/*
class searchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final searchController;
  String query = "";

  searchAppBar(this.searchController);

  @override
  _searchAppBarState createState() => _searchAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 40);
}

class _searchAppBarState extends State<searchAppBar> {
  @override
  Widget build(BuildContext context) {
    return  NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    UniversalVariables.gradientColorStart,
                    UniversalVariables.gradientColorEnd,
                  ],
                ),
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: widget.preferredSize,
              child: Padding(
                padding: EdgeInsets.only(left: 20),
                child: TextField(
                  controller: widget.searchController,
                  onChanged: (val) {
                    setState(() {
                      widget.query = val;
                    });
                  },
                  cursorColor: UniversalVariables.blackColor,
                  autofocus: true,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 35,
                  ),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        WidgetsBinding.instance
                            .addPostFrameCallback((_) => widget.searchController.clear());
                      },
                    ),
                    border: InputBorder.none,
                    hintText: "Search",
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                      color: Color(0x88ffffff),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ];
      },
      body: Text(''),
    );
  }

}
*/
