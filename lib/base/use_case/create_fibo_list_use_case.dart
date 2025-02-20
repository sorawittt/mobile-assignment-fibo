import 'package:fibo/asset/interger.dart';

abstract class CreateFiboListUseCase {
  List<int> execute(List<int> list, int numbersToGenerate);
}

class CreateFiboListUseCaseImplement implements CreateFiboListUseCase {
  @override
  List<int> execute(List<int> list, int numbersToGenerate) {
    if (list.length >= maxSafeIntIndex) {
      return list;
    }

    if (list.length <= 2) {
      list = List.of([0, 1]);
      numbersToGenerate -= 2;
    }

    // Note: maxSafeIntIndex = max index that not hit integer overflow
    // can use BigInt for fix this, but trade off with memory

    while (numbersToGenerate > 0 && list.length <= maxSafeIntIndex) {
      final lastIndex = list.length - 1;
      final secondLastIndex = list.length - 2;

      list.add(list[lastIndex] + list[secondLastIndex]);
      numbersToGenerate--;
    }

    return list;
  }
}
