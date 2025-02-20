import 'package:fibo/asset/dimens.dart';
import 'package:fibo/ui/fibo/model/fibo_list_item_model.dart';
import 'package:flutter/material.dart';

class FiboListViewItem extends StatelessWidget {
  final FiboListItemModel item;
  final bool isSeleted;
  final bool isLastReturnValue;
  final Function(FiboListItemModel) onItemClicked;

  const FiboListViewItem({
    super.key,
    required this.item,
    required this.isSeleted,
    required this.isLastReturnValue,
    required this.onItemClicked,
  });

  @override
  Widget build(BuildContext context) {
    return isSeleted
        ? SizedBox.shrink()
        : InkWell(
            onTap: () => onItemClicked(item),
            child: Container(
              height: listViewItemHeight,
              color: isLastReturnValue
                  ? Theme.of(context).colorScheme.primaryContainer
                  : null,
              padding: EdgeInsets.all(defaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text('index: ${item.index}, value: ${item.value}'),
                  ),
                  Icon(item.type.icon),
                ],
              ),
            ),
          );
  }
}
