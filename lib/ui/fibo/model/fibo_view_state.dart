import 'package:fibo/base/model/enum/fibo_icon_type.dart';
import 'package:fibo/ui/fibo/model/fibo_list_item_model.dart';

class FiboViewState {
  final List<int> fiboList;
  final Map<FiboIconType, List<FiboListItemModel>>? selectedList;
  final int? lastAddIndex;
  final int? lastReturnIndex;

  const FiboViewState({
    required this.fiboList,
    this.selectedList,
    this.lastAddIndex,
    this.lastReturnIndex,
  });

  FiboViewState copyWith({
    List<int>? fiboList,
    Map<FiboIconType, List<FiboListItemModel>>? selectedList,
    int? lastAddIndex,
    int? lastReturnIndex,
  }) =>
      FiboViewState(
        fiboList: fiboList ?? this.fiboList,
        selectedList: selectedList ?? this.selectedList,
        lastAddIndex: lastAddIndex ?? this.lastAddIndex,
        lastReturnIndex: lastReturnIndex ?? this.lastReturnIndex,
      );
}
