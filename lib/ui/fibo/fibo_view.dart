import 'package:fibo/base/model/enum/fibo_icon_type.dart';
import 'package:fibo/base/use_case/create_fibo_list_use_case.dart';
import 'package:fibo/base/widget/list_bottom_sheet.dart';
import 'package:fibo/ui/fibo/fibo_view_model.dart';
import 'package:fibo/ui/fibo/model/fibo_list_item_model.dart';
import 'package:fibo/ui/fibo/widget/fibo_list_view_item.dart';
import 'package:flutter/material.dart';

class FiboView extends StatefulWidget {
  const FiboView({super.key});

  @override
  State<StatefulWidget> createState() => FiboViewState();
}

class FiboViewState extends State<FiboView> {
  static const _title = 'Fibo';

  final listViewKey = GlobalKey();

  final _viewModel = FiboViewModel(
    createFiboListUsecase: CreateFiboListUseCaseImplement(),
  );

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onViewModelChanged);
    _viewModel.loadInit();
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: ListView.separated(
        controller: _viewModel.scrollController,
        itemCount: _viewModel.viewState.fiboList.length,
        itemBuilder: (buttomSheetContext, index) {
          final type = FiboIconType.fromIndex(index);
          return FiboListViewItem(
            isSeleted: _viewModel.isSelectd(type, index),
            isLastReturnValue: index == _viewModel.viewState.lastReturnIndex,
            item: FiboListItemModel(
              index: index,
              value: _viewModel.viewState.fiboList[index],
              type: type,
            ),
            onItemClicked: (item) async {
              _viewModel.onFiboItemClicked(item);
              final selectedIndex = await showModalBottomSheet<int>(
                context: buttomSheetContext,
                builder: (_) => ListBottomSheet(
                  list: _viewModel.getSelectedList(item.type),
                  icon: FiboIconType.fromIndex(item.index).icon,
                  onItemClicked: (indexOfValue) {
                    _viewModel.onBottomSheetItemClicked(type, indexOfValue);
                    Navigator.of(buttomSheetContext).pop(indexOfValue);
                  },
                  lastAddIndex: _viewModel.viewState.lastAddIndex,
                ),
              );

              if (selectedIndex != null) {
                _viewModel.scrollToIndex(selectedIndex);
              }
            },
          );
        },
        separatorBuilder: (context, index) => Divider(
          height: 0,
        ),
      ),
    );
  }
}
