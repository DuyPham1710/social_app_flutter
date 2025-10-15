abstract class UseCase<Type, Params> {
  Future<Type> call({Params? params});
}

/// UseCase cho synchronous operations (không cần Future)
abstract class SyncUseCase<Type, Params> {
  Type call({required Params params});
}

/// UseCase cho Stream operations
abstract class StreamUseCase<Type, Params> {
  Stream<Type> call({required Params params});
}

/// Class đại diện cho "không có params"
class NoParams {
  const NoParams();
}