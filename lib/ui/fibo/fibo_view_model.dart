import 'dart:async';

import 'package:fibo/asset/dimens.dart';
import 'package:fibo/base/model/enum/fibo_icon_type.dart';
import 'package:fibo/base/use_case/create_fibo_list_use_case.dart';
import 'package:fibo/ui/fibo/model/fibo_list_item_model.dart';
import 'package:fibo/ui/fibo/model/fibo_view_state.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class FiboViewModel extends ChangeNotifier {
  final CreateFiboListUseCase createFiboListUsecase;

  FiboViewState _viewState = FiboViewState(
    fiboList: [],
  );
  FiboViewState get viewState => _viewState;

  final _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  final int _pageSize = 40;

  Timer? _scrollDebounce;

  FiboViewModel({required this.createFiboListUsecase});

  void loadInit() {
    scrollController.addListener(_scrollChangeListener);
    final fiboList = createFiboListUsecase.execute([], _pageSize);
    _viewState = _viewState.copyWith(
      fiboList: fiboList,
    );
    notifyListeners();
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollChangeListener);
    super.dispose();
  }

  void _scrollChangeListener() {
    _scrollDebounce?.cancel();
    _scrollDebounce = Timer(Durations.short1, () {
      if (_scrollController.position.extentAfter < 200) {
        _loadMore();
      }
    });
  }

  void _loadMore() {
    final newList =
        createFiboListUsecase.execute(_viewState.fiboList, _pageSize);
    _viewState = _viewState.copyWith(
      fiboList: newList,
    );
    notifyListeners();
  }

  void onFiboItemClicked(FiboListItemModel item) {
    final type = FiboIconType.fromIndex(item.index);
    var currentSelectedList = _viewState.selectedList ?? {};

    if (currentSelectedList[type] case List<FiboListItemModel> list) {
      list += [item];
      currentSelectedList[type] = list;
    } else {
      currentSelectedList[type] = [item];
    }

    _viewState = _viewState.copyWith(
      selectedList: currentSelectedList,
      lastAddIndex: item.index,
    );
    notifyListeners();
  }

  List<FiboListItemModel> getSelectedList(FiboIconType type) {
    if (_viewState.selectedList?.containsKey(type) ?? false) {
      return _viewState.selectedList?[type] ?? [];
    }

    return [];
  }

  bool isSelectd(FiboIconType type, int index) {
    if (_viewState.selectedList?[type] case List<FiboListItemModel> list) {
      final result = list.firstWhereOrNull((item) => item.index == index);
      return result != null;
    }

    return false;
  }

  void onBottomSheetItemClicked(FiboIconType type, int index) {
    var currentSelectedList = _viewState.selectedList ?? {};
    final newSelectedList = (_viewState.selectedList?[type] ?? [])
        .where((item) => item.index != index)
        .toList();

    currentSelectedList[type] = newSelectedList;
    _viewState = _viewState.copyWith(
      selectedList: currentSelectedList,
      lastReturnIndex: index,
    );
    notifyListeners();
  }

  void scrollToIndex(int index) {
    if (index == 0) {
      _scrollController.jumpTo(0);
    }

    final selectedValueCount = (_viewState.selectedList?.values ?? [])
        .flattened
        .toList()
        .map((value) => value.index)
        .length;

    final originalIndex = index * listViewItemHeight;
    final hideIndex = selectedValueCount * listViewItemHeight;

    final targetOffset = originalIndex - hideIndex;

    _scrollController.jumpTo(targetOffset);
  }
}
