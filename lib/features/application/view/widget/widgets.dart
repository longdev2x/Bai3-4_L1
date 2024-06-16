import 'package:exercies3/common/utils/app_colors.dart';
import 'package:exercies3/common/utils/image_res.dart';
import 'package:exercies3/common/widgets/app_icon.dart';
import 'package:exercies3/features/tasks/view/tasks_screen.dart';
import 'package:flutter/material.dart';

const List<BottomNavigationBarItem> bottomTabs = [
  BottomNavigationBarItem(
      icon: AppIcon(path: ImageRes.icHome),
      activeIcon: AppIcon(path: ImageRes.icHome, iconColor: AppColors.bgButton,),
      label: "Home"),
  BottomNavigationBarItem(
      icon: AppIcon(path: ImageRes.icCalendar),
      activeIcon: AppIcon(path: ImageRes.icCalendar, iconColor: AppColors.bgButton),
      label: "Calendar"),
  BottomNavigationBarItem(
      icon: AppIcon(path: ImageRes.icPersonal),
      activeIcon: AppIcon(path: ImageRes.icPersonal, iconColor: AppColors.bgButton),
      label: "Profile"),
];


const List<Widget> screens = [
  Center(child: TasksScreen(),),
  Center(child: Text("Calendar Screen", style: TextStyle(fontSize: 30),)),
  Center(child: Text("Profile Screen", style: TextStyle(fontSize: 30),)),
];