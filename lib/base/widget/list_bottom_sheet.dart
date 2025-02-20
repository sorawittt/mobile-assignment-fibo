import 'package:fibo/asset/dimens.dart';
import 'package:fibo/ui/fibo/model/fibo_list_item_model.dart';
import 'package:flutter/material.dart';

class ListBottomSheet extends StatelessWidget {
  final List<FiboListItemModel> list;
  final IconData icon;
  final Function(int) onItemClicked;
  final int? lastAddIndex;

  const ListBottomSheet({
    super.key,
    required this.list,
    required this.icon,
    required this.onItemClicked,
    this.lastAddIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: defaultPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(defaultBorderRadius),
          topRight: Radius.circular(defaultBorderRadius),
        ),
      ),
      child: Column(
        children: [
          Icon(icon),
          Flexible(
            child: ListView.separated(
              itemCount: list.length,
              itemBuilder: (context, index) => InkWell(
                onTap: () => onItemClicked(list[index].index),
                child: Container(
                    color: list[index].index == lastAddIndex
                        ? Theme.of(context).colorScheme.secondary
                        : null,
                    padding: EdgeInsets.all(defaultPadding),
                    child: Text(
                        'index: ${list[index].index}, value: ${list[index].value}')),
              ),
              separatorBuilder: (context, index) => Divider(
                height: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
