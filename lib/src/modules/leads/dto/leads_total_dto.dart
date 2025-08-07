
import 'package:vaden/vaden.dart';

@DTO()
class LeadTotaisDto {
  final int totalAtivos;
  final int totalRevenda;
  final int totalUtilizacao;

  LeadTotaisDto({
    required this.totalAtivos,
    required this.totalRevenda,
    required this.totalUtilizacao,
  });

  factory LeadTotaisDto.fromMap(Map<String, dynamic> map) {
    return LeadTotaisDto(
      totalAtivos: map['total_ativos'] ?? 0,
      totalRevenda: map['total_revenda'] ?? 0,
      totalUtilizacao: map['total_utilizacao'] ?? 0,
    );
  }
}
