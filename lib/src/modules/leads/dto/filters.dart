
class LeadsFilters{
  final String? fonte;
  final String? parceiro;
  final String? interesse;
  final String? status;

  LeadsFilters({
    this.fonte,
    this.parceiro,
    this.interesse,
    this.status,
  });

  factory LeadsFilters.fromQuery(Map<String, dynamic> query) {
    return LeadsFilters(
      fonte: query['fonte'],
      parceiro: query['parceiro'] ,
      interesse: query['interesse'],
      status: query['status'],
    );
  }
}