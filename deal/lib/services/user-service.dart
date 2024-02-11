import 'package:deal/dao/user-dao.dart';

import '../model/user.dart';

class UserService extends UserDao {

  Future<bool> isInitiated() async {
    return getAll().isNotEmpty ;
  }

}