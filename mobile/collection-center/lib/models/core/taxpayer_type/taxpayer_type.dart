enum TaxpayerType {
  moral('Persona Moral'),
  physical('Persona Física');  

  final String label;
  const TaxpayerType(this.label);

   static TaxpayerType fromString(String label) {
    return TaxpayerType.values.firstWhere(
      (v) => v.label == label,
      orElse: () => TaxpayerType.physical,
    );
  }
}