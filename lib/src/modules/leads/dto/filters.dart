
class LeadsFilters{
  final String? fonte;
  final String? parceiro;
  final String? interesse;
  final String? status;
  final String? busca;

  LeadsFilters({
    this.fonte,
    this.parceiro,
    this.interesse,
    this.status,
    this.busca,
  });

  factory LeadsFilters.fromQuery(Map<String, dynamic> query) {
    return LeadsFilters(
      fonte: query['fonte'],
      parceiro: query['parceiro'] ,
      interesse: query['interesse'],
      status: query['status'],
      busca: query['busca'],
    );
  }
}