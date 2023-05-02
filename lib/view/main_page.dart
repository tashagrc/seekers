import 'package:flutter/material.dart';
import 'package:seekers/view/history_page.dart';
import 'package:seekers/view/impaired/game_impaired_page.dart';
import 'package:seekers/view/peer/game_peer_page.dart';
import 'package:seekers/view/peer/home_peer_page.dart';
import 'package:seekers/view/profile_page.dart';

import 'impaired/explore_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  //ROLES DARI DATABASE, 1 = VISUALLY IMPAIRED, 2 = SIGHTED PEER
  int userRoles = 1;
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        animationDuration: const Duration(milliseconds: 1000),
        destinations:  <Widget> [
          (userRoles == 1) 
          ? const NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            label: 'Explore',
          )
          : const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          (userRoles==1)
          ? const NavigationDestination(
              icon: Icon(Icons.gamepad_outlined),
              label: 'Game',
            )
          : const NavigationDestination(
              icon: Icon(Icons.gamepad_outlined),
              label: 'Game',
            ),
          const NavigationDestination(
            icon: Icon(Icons.access_time),
            label: 'History',
          ),
          const NavigationDestination(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Profile',
          )
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
      ),

      body: <Widget>[
        (userRoles == 1)
        ? const ExplorePage()
        : const HomePeerPage(),
        (userRoles == 1)
        ? const GameImpaired()
        : const GamePeer(),
        const HistoryPage(),
        const ProfilePage(),
        //add page here
      ][currentPageIndex],
    );
  }
}