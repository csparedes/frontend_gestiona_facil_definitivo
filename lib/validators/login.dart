class LoginValidator {
  static tieneCamposVacios(String email, String password) {
    if (email == '' || password == '') {
      return true;
    }
    return false;
  }
}
