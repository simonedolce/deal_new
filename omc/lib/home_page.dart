import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:omc/elenco_debiti.dart';
import 'package:omc/quick_overview_screen.dart';
import 'elenco_deal.dart';
import 'util/colors.dart';

class HomePage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<HomePage> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();


  final List<BottomNavigationBarItem> _bottomNavBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.search),
      label: 'Cerca',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Profilo',
    ),
  ];

  final List<Widget> _screens = [
    const QuickOverview(),
    const ElencoDeal(),
    const ElencoDebiti(),
  ];

  @override
  void initState() {
    super.initState();
  }

  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final _key = GlobalKey<ExpandableFabState>();
    return  Scaffold(
      body: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 300),
        reverse: false,
        transitionBuilder: (child, animation, secondaryAnimation) {
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            child: child,
          );
        },
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.highlight,
        selectedItemColor: AppColors.background,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.remove_red_eye),
            label: 'Quick Overview',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Lista Deal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on_rounded),
            label: 'Debiti',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}




