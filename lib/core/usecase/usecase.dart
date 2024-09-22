import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sumify_clean/core/error/failure.dart';

abstract interface class UseCase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
