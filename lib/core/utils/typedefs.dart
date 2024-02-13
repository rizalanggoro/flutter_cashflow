import 'package:dartz/dartz.dart';

import '../failure/failure.dart';

typedef FutureUseCase<Result> = Future<Either<Failure, Result>>;
typedef UseCase<Result> = Either<Failure, Result>;
