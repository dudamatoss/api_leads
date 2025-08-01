import 'package:api_leads/src/modules/leads/enum/interesse_enum.dart';
import 'package:api_leads/src/modules/leads/enum/ststus_enum.dart';
import 'package:vaden/vaden.dart';


@DTO()
class LeadDto {
  final String id_leads_comercial ;
  DateTime data_hora;
  final String nome;
  final String email;
  final String cnpj;
  final String telefone;
  final InteresseEnum interesse;
  final String fonte;
  final String meio;
  final String anuncio;
  final StatusEnum status;

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
  });
}