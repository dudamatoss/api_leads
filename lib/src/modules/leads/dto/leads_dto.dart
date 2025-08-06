import 'package:vaden/vaden.dart';


@DTO()
class LeadDto {
  final int id_leads_comercial;
  DateTime data_hora;
  final String? nome;
  final String? email;
  final String? cnpj;
  final String? telefone;
  final InteresseEnum interesse;
  final String? fonte;
  final String? meio;
  final String? anuncio;
  final StatusEnum status;
  final String? parceiro;


  LeadDto({
    required this.id_leads_comercial,
    required this.data_hora,
    required this.nome,
    required this.email,
    required this.cnpj,
    required this.telefone,
    required this.interesse,
    required this.fonte,
    required this.meio,
    required this.anuncio,
    required this.status,
    required this.parceiro,
  });
}
enum InteresseEnum {
  utilizacao,
  revenda;

  static InteresseEnum fromName(String value) {
    return InteresseEnum.values.firstWhere(
          (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => InteresseEnum.utilizacao,
    );
  }

  String toName() {
    switch (this) {
      case InteresseEnum.utilizacao:
        return 'Utilização';
      case InteresseEnum.revenda:
        return 'Revenda';
    }
  }
}
enum StatusEnum {
  ativo,
  concluido;

  static StatusEnum fromName(String value){
    return StatusEnum.values.firstWhere(
          (e) => e.name == value,
      orElse: () => StatusEnum.ativo,
    );
  }

}