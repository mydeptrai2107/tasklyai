class Validator {
  static String? validPassword(String? password) {
    final rgLeast8Character = RegExp(r'^(?=.{8,}).*');

    if (password == null || password.isEmpty) {
      return 'Vui lòng không để trống mật khẩu';
    }
    // if (!rgLeast8Character.hasMatch(password)) {
    //   return 'Mật khẩu không hợp lệ';
    // }
    // final regexComplex = [
    //   RegExp(r'(?=.*?[A-Z])'),
    //   RegExp(r'(?=.*?[a-z])'),
    //   RegExp(r'(?=.*?[0-9])'),
    //   RegExp(r'(?=.*?[!@#\$&*~%^()_\-+=\[\]{}:;<>,.?/\\|])'),
    // ];

    // var point = 0;
    // for (var e in regexComplex) {
    //   point += e.hasMatch(password) ? 1 : 0;
    // }

    // if (point < 4) {
    //   return 'Mật khẩu không hợp lệ';
    // }

    return null;
  }

  static String? validEmail(String? email) {
    final regex = RegExp(
      r'^[a-z][a-z0-9-_\.]{1,32}@[a-z0-9]{2,}(\.[a-z0-9]{2,63}){1,2}$',
    );
    if (email == null || email.isEmpty) {
      return 'Vui lòng không để trống email';
    }
    final lowerEmail = email.toLowerCase();
    if (!regex.hasMatch(lowerEmail)) {
      return 'Email không hợp lệ';
    }
    return null;
  }
}
