
import 'package:vaden/vaden.dart';

@DTO()
class LeadTotaisDto {
  final int totalStatus;
  final int totalRevenda;
  final int totalUtilizacao;
  final int totalGeral;

  LeadTotaisDto({
    required this.totalStatus,
    required this.totalRevenda,
    required this.totalUtilizacao,
    required this.totalGeral,
  });

  factory LeadTotaisDto.fromMap(Map<String, dynamic> map) {
    return LeadTotaisDto(
      totalStatus: map['total_status'] ?? 0,
      totalRevenda: map['total_revenda'] ?? 0,
      totalUtilizacao: map['total_utilizacao'] ?? 0,
      totalGeral: map['total_geral'] ?? 0,
    );
  }
}
