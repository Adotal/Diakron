class Validators {
  // Empty Check
  static String? required(String? value) =>
      (value == null || value.isEmpty) ? 'Este campo es obligatorio' : null;

  // Email (Billing)
  static String? email(String? value) {
    final emptyField = required(value);
    if (emptyField != null) {
      return emptyField;
    }
    final bool emailValid = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$',
    ).hasMatch(value ?? '');
    return emailValid ? null : 'Correo electrónico no válido';
  }

  // RFC (Mexico - 12 or 13 chars)
  static String? rfc(String? value) {
    /*
    Regex retrieved and fixed from
    https://wwwmat.sat.gob.mx/cs/Satellite?blobcol=urldata&blobkey=id&blobtable=MungoBlobs&blobwhere=1461175750735&ssbinary=true
    
    Rfc contribuyente (original):
    ˆ([A-ZÑ]|\&){3,4}[0-9]{2}(0[1-9]|1[0-2])([12][0-9]|0[1-9]|3[01])[A-Z0-9]{3}$
      */

    final emptyField = required(value);
    if (emptyField != null) {
      return emptyField;
    }

    final bool rfcValid = RegExp(
      r'^([A-ZÑ&]{3,4})([0-9]{2})(0[1-9]|1[0-2])(0[1-9]|[12][0-9]|3[01])[A-Z\d]{3}$',
    ).hasMatch(value ?? '');
    return rfcValid ? null : 'RFC no válido';
  }

  // CLABE (18 digits)
  static String? clabe(String? value) {
    final emptyField = required(value);
    if (emptyField != null) {
      return emptyField;
    }
    final bool clabeValid = RegExp(r'^\d{18}$').hasMatch(value ?? '');
    return clabeValid ? null : 'CLABE debe tener 18 dígitos';
  }

  static String? postCode(String? value) {
    final emptyField = required(value);
    if (emptyField != null) {
      return emptyField;
    }
    final bool postCodeValid = RegExp(r'^\d{5}$').hasMatch(value ?? '');
    return postCodeValid ? null : 'Código postal debe tener 5 dígitos';
  }

  static String? number(String? value){
    
    final emptyField = required(value);
    if (emptyField != null) {
      return emptyField;
    }
    final bool isNumber = RegExp(r'^[1-9]\d*$').hasMatch(value ?? '');
    return isNumber ? null : 'Debes escribir un número mayor a cero';
  }
    static String? phoneNumber(String? value){
    
    final emptyField = required(value);
    if (emptyField != null) {
      return emptyField;
    }
  
    final bool isNumber = RegExp(r'^\d{10}$').hasMatch(value ?? '');
    return isNumber ? null : 'Número telefónico de 10 dígitos';
  }
}