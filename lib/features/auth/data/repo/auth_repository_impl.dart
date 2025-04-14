import 'package:emails_sender/features/auth/data/remote/auth_remote_ds.dart';
import 'package:emails_sender/features/auth/domain/repo/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource dataSource;

  AuthRepositoryImpl(this.dataSource);

  @override
  Future<Map<String, String?>> signIn() async {
    return await dataSource.signIn();
  }

  @override
  Future<void> signOut() async {
    await dataSource.signOut();
  }
}
