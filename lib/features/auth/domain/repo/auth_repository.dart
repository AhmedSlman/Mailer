abstract class AuthRepository {
  Future<Map<String, String?>> signIn();
  Future<void> signOut();
}
