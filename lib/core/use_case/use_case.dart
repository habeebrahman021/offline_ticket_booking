import 'package:equatable/equatable.dart';

abstract class UseCase<Type, Params> {
  Future<Result<Type>> call(Params params) async {
    try {
      return Success(await execute(params));
    } on Exception catch (e) {
      return Failure(e);
    } catch (e, stackTrace) {
      return Failure(Exception('Unexpected error: $e\n$stackTrace'));
    }
  }

  Future<Type> execute(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}

sealed class Result<T> {}

class Success<T> extends Result<T> {
  Success(this.value);

  final T value;
}

class Failure<T> extends Result<T> {
  Failure(this.exception);

  final Exception exception;
}
