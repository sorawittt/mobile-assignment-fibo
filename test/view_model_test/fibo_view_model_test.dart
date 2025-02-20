import 'package:fibo/asset/dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:fibo/base/use_case/create_fibo_list_use_case.dart';
import 'package:fibo/base/model/enum/fibo_icon_type.dart';
import 'package:fibo/ui/fibo/model/fibo_list_item_model.dart';
import 'package:fibo/ui/fibo/fibo_view_model.dart';

import 'fibo_view_model_test.mocks.dart';

@GenerateMocks([CreateFiboListUseCase])
void main() {
  late FiboViewModel viewModel;
  late MockCreateFiboListUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockCreateFiboListUseCase();
    viewModel = FiboViewModel(createFiboListUsecase: mockUseCase);
  });

  tearDown(() {
    viewModel.dispose();
  });

  group('FiboViewModel initialization', () {
    test('should initialize with empty fiboList', () {
      expect(viewModel.viewState.fiboList, isEmpty);
      expect(viewModel.viewState.selectedList, isNull);
      expect(viewModel.viewState.lastAddIndex, isNull);
      expect(viewModel.viewState.lastReturnIndex, isNull);
    });

    test('should initialize ScrollController', () {
      expect(viewModel.scrollController, isNotNull);
      expect(viewModel.scrollController, isA<ScrollController>());
    });
  });

  group('loadInit', () {
    test('should load initial data and update state', () {
      final mockList = List.generate(40, (index) => index);
      when(mockUseCase.execute([], 40)).thenReturn(mockList);

      viewModel.loadInit();

      verify(mockUseCase.execute([], 40)).called(1);
      expect(viewModel.viewState.fiboList, equals(mockList));
    });
  });

  group('onFiboItemClicked', () {
    test('should add item to selectedList when clicked first time', () {
      final item = FiboListItemModel(
        index: 0,
        value: 0,
        type: FiboIconType.square,
      );

      viewModel.onFiboItemClicked(item);

      expect(viewModel.viewState.selectedList?[FiboIconType.square], [item]);
      expect(viewModel.viewState.lastAddIndex, 0);
    });

    test('should append item to existing list when clicked again', () {
      final item1 = FiboListItemModel(
        index: 0,
        value: 0,
        type: FiboIconType.square,
      );
      final item2 = FiboListItemModel(
        index: 1,
        value: 1,
        type: FiboIconType.circle,
      );

      viewModel.onFiboItemClicked(item1);
      viewModel.onFiboItemClicked(item2);

      expect(
        viewModel.viewState.selectedList?[FiboIconType.square],
        [item1],
      );
      expect(
        viewModel.viewState.selectedList?[FiboIconType.circle],
        [item2],
      );
      expect(viewModel.viewState.lastAddIndex, 1);
    });
  });

  group('getSelectedList', () {
    test('should return empty list when no items selected', () {
      expect(viewModel.getSelectedList(FiboIconType.square), isEmpty);
    });

    test('should return selected items for given type', () {
      final item = FiboListItemModel(
        index: 0,
        value: 0,
        type: FiboIconType.square,
      );

      viewModel.onFiboItemClicked(item);

      expect(viewModel.getSelectedList(FiboIconType.square), [item]);
      expect(viewModel.getSelectedList(FiboIconType.circle), isEmpty);
    });
  });

  group('isSelected', () {
    test('should return false when no items selected', () {
      expect(viewModel.isSelectd(FiboIconType.square, 0), isFalse);
    });

    test('should return true when item is selected', () {
      final item = FiboListItemModel(
        index: 0,
        value: 0,
        type: FiboIconType.square,
      );

      viewModel.onFiboItemClicked(item);

      expect(viewModel.isSelectd(FiboIconType.square, 0), isTrue);
      expect(viewModel.isSelectd(FiboIconType.square, 1), isFalse);
    });
  });

  group('onBottomSheetItemClicked', () {
    test('should remove item from selectedList', () {
      final item = FiboListItemModel(
        index: 0,
        value: 0,
        type: FiboIconType.square,
      );

      viewModel.onFiboItemClicked(item);
      viewModel.onBottomSheetItemClicked(FiboIconType.square, 0);

      expect(viewModel.viewState.selectedList?[FiboIconType.square], isEmpty);
      expect(viewModel.viewState.lastReturnIndex, 0);
    });
  });

  group('scrollToIndex', () {
    testWidgets('should scroll to correct position',
        (WidgetTester tester) async {
      // Build a simple widget with ListView to test scrolling
      await tester.pumpWidget(
        MaterialApp(
          home: ListView.builder(
            controller: viewModel.scrollController,
            itemCount: 100,
            itemBuilder: (context, index) =>
                SizedBox(height: listViewItemHeight),
          ),
        ),
      );

      // Test scrolling to index 0
      viewModel.scrollToIndex(0);
      await tester.pumpAndSettle();
      expect(viewModel.scrollController.offset, 0);

      // Test scrolling to index with no selected items
      viewModel.scrollToIndex(5);
      await tester.pumpAndSettle();
      expect(viewModel.scrollController.offset, 5 * listViewItemHeight);

      // Test scrolling with selected items
      final item = FiboListItemModel(
        index: 2,
        value: 2,
        type: FiboIconType.square,
      );
      viewModel.onFiboItemClicked(item);

      viewModel.scrollToIndex(10);
      await tester.pumpAndSettle();
      expect(viewModel.scrollController.offset,
          (10 * listViewItemHeight) - listViewItemHeight);
    });
  });
}
