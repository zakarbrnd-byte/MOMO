import '../data/datasources/profile_data_source.dart';
import '../dto/profile_dto.dart';
import '../models/profile.dart';
import 'profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._dataSource);

  final ProfileDataSource _dataSource;

  @override
  Future<Profile> load() {
    return _dataSource.getProfile().then((profile) {
      return ProfileDto.fromDomain(profile).toDomain();
    });
  }
}
