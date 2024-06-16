import 'package:exercies3/common/utils/image_res.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

List<String> iconPaths = [
  ImageRes.icBirth,
  ImageRes.icCoffee,
  ImageRes.icEat,
  ImageRes.icFight,
  ImageRes.icHospital,
  ImageRes.icLearn,
  ImageRes.icSport,
  ImageRes.icWork,
];


class IconStateNotifier extends StateNotifier<String> {
  IconStateNotifier(String iconInitial) : super(iconInitial);

  void updateIcon(String icon) {
    state = icon;
  }
}
final iconProviderFamily = StateNotifierProviderFamily<IconStateNotifier, String, String>((ref, iconInitial) => IconStateNotifier(iconInitial));