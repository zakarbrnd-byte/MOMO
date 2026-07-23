import '../data/datasources/user_data_source.dart';
import '../dto/user_dto.dart';
import '../models/user.dart';
import 'user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this._dataSource);

  final UserDataSource _dataSource;

  @override
  Future<User> getCurrentUser() {
    return _dataSource.getCurrentUser().then((user) {
      return UserDto.fromDomain(user).toDomain();
    });
  }
}
