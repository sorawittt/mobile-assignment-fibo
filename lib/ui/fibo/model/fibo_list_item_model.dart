import 'package:fibo/base/model/enum/fibo_icon_type.dart';

class FiboListItemModel {
  final int index;
  final int value;
  final FiboIconType type;

  FiboListItemModel({
    required this.index,
    required this.value,
    required this.type,
  });
}
