import 'package:fibo/base/use_case/create_fibo_list_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fibo/asset/interger.dart';

void main() {
  late CreateFiboListUseCase useCase;

  setUp(() {
    useCase = CreateFiboListUseCaseImplement();
  });

  group('CreateFiboListUseCase', () {
    test('should initialize with [0, 1] when list is empty', () {
      final result = useCase.execute([], 3);
      expect(result, [0, 1, 1]);
    });

    test('should initialize with [0, 1] when list has one element', () {
      final result = useCase.execute([0], 3);
      expect(result, [0, 1, 1]);
    });

    test('should initialize with [0, 1] when list has two elements not [0, 1]',
        () {
      final result = useCase.execute([2, 3], 3);
      expect(result, [0, 1, 1]);
    });

    test('should generate correct Fibonacci sequence', () {
      final result = useCase.execute([], 8);
      expect(result, [0, 1, 1, 2, 3, 5, 8, 13]);
    });

    test('should respect numbersToGenerate parameter', () {
      final result = useCase.execute([], 3);
      expect(result, [0, 1, 1]);
    });

    test('should continue sequence from existing valid Fibonacci list', () {
      final result = useCase.execute([0, 1, 1, 2, 3], 3);
      expect(result, [0, 1, 1, 2, 3, 5, 8, 13]);
    });

    test('should return same list when length >= maxSafeIntIndex', () {
      final longList = List.generate(maxSafeIntIndex + 1, (index) => index);
      final result = useCase.execute(longList, 5);
      expect(result, longList);
    });

    test('should stop generating when reaching maxSafeIntIndex', () {
      final startList = [0, 1];
      final result = useCase.execute(startList, maxSafeIntIndex + 10);
      expect(result.length - 1, lessThanOrEqualTo(maxSafeIntIndex));
    });

    test('should handle zero numbersToGenerate', () {
      final result = useCase.execute([0, 1], 0);
      expect(result, [0, 1]);
    });

    test('should handle negative numbersToGenerate', () {
      final result = useCase.execute([0, 1], -1);
      expect(result, [0, 1]);
    });
  });
}
