
import 'package:vaden/vaden.dart';

@DTO()
class LeadTotaisDto {
  final int totalStatus;
  final int totalRevenda;
  final int totalUtilizacao;
  final int totalGeral;
  final int totalPaginas;

  LeadTotaisDto({
    required this.totalStatus,
    required this.totalRevenda,
    required this.totalUtilizacao,
    required this.totalGeral,
    required this.totalPaginas,
  });


  factory LeadTotaisDto.fromMap(Map<String, dynamic> map, int limit) {
    final totalGeral = map['total_geral'] ?? 0;
    final totalPaginas = limit > 0 ? (totalGeral / limit).ceil() : 0;
    return LeadTotaisDto(
      totalStatus: map['total_status'] ?? 0,
      totalRevenda: map['total_revenda'] ?? 0,
      totalUtilizacao: map['total_utilizacao'] ?? 0,
      totalGeral: totalGeral,
      totalPaginas: totalPaginas,
    );
  }
}