class UserRepository {
  static final Map<String, String> _users = {}; // username -> password

  static void register(String username, String password) {
    _users[username] = password;
  }

  static bool authenticate(String username, String password) {
    return _users[username] == password;
  }

  static bool userExists(String username) {
    return _users.containsKey(username);
  }
}
