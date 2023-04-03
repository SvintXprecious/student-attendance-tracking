class UserInformation{

  const UserInformation();

   static String generateStudentID(String email){
     int index = email.indexOf('@');
     return email.substring(0, index).toUpperCase();

   }

  static String generateProgramCode(String email){
    int indexAt = email.indexOf('@');
    int indexDash = email.indexOf('-');
    String year = email.substring(indexAt - 2, indexAt);
    String code = email.substring(0, indexDash).toUpperCase();
    return code + year;

  }

   static bool studentEmailValidation(String email) {
     RegExp expression=RegExp(r'\w+-\d+-\d+@must.ac.mw');
     return expression.hasMatch(email);
   }

  static bool lecturerEmailValidation(String email) {
    RegExp expression=RegExp(r'\w+@must.ac.mw');
    return expression.hasMatch(email);
  }

}