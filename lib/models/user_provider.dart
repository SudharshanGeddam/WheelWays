import 'package:flutter_riverpod/legacy.dart';

class UserProvider {
  final String? name;
  final String? email;
  final String? role;

  UserProvider({this.name, this.email, this.role});

}
final userProvider = StateProvider<UserProvider?>((ref) => null);