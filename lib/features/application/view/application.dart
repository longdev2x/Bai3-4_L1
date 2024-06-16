import 'package:exercies3/common/utils/app_colors.dart';
import 'package:exercies3/features/application/provider/bottom_tabs_provider.dart';
import 'package:exercies3/features/application/view/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Application extends ConsumerWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int index = ref.watch(bottomTabsProvider);
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 1.w)),
        ),
        child: BottomNavigationBar(
            onTap: (index) {
              ref.read(bottomTabsProvider.notifier).update(index);
            },
            items: bottomTabs,
            currentIndex: index,
            elevation: 100,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.bgButton,
            // showSelectedLabels: false,
            // showUnselectedLabels: false,
          ),
      ),
    );
  }
}
