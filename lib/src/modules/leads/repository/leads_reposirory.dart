import 'package:api_leads/src/modules/leads/dto/filters.dart';
import 'package:api_leads/src/modules/leads/dto/leads_dto.dart';
import 'package:api_leads/src/modules/leads/dto/leads_total_dto.dart';
import 'package:api_leads/src/modules/leads/repository/i_leads_repository.dart';
import 'package:api_leads/src/shared/database/database.dart';
import 'package:vaden/vaden.dart';

@Scope(BindType.instance)
@Repository()
class LeadsRepository implements ILeadsRepository {
  final Database _database;

  static const String tableName = 'leads_comercial';

  LeadsRepository(this._database);

  @override
  Future<LeadDto> update(LeadDto entity) async {
    await _database.update(tableName: tableName, values: toMap(entity));
    return entity;
  }

 @override
  Future<LeadTotaisDto> getAllTotal(LeadsFilters filters, int limit) async {
    final parameters = <String, dynamic>{};

    final sql = StringBuffer('''
      SELECT
        COUNT(*) AS total_status,
        COUNT(*) FILTER (WHERE interesse = 'Revenda') AS total_revenda,
        COUNT(*) FILTER (WHERE interesse = 'Utilização') AS total_utilizacao,
        COUNT(*) AS total_geral
      FROM $tableName
      WHERE 1=1
    ''');
    _applyFilters(filters, sql, parameters);

    sql.write(';');

    final result = await _database.query(
      sql: sql.toString(),
      parameters: parameters,
    );
    return LeadTotaisDto.fromMap(result.first, limit);
  }

  //QUERY DINAMICA
  @override
  Future<List<LeadDto>> getAllByFilter(
    LeadsFilters filters,
    int limit,
    int offset,
  ) async {
    final sql = StringBuffer('''
    SELECT
      id_${tableName},
      data_hora,
      nome,
      email,
      cnpj,
      telefone,
      interesse,
      fonte,
      meio,
      anuncio,
      status,
      parceiro
    FROM $tableName
    WHERE 1=1
     
  ''');
    final parameters = <String, dynamic>{'limit': limit, 'offset': offset};

    _applyFilters(filters, sql, parameters);

    final whereClauses = <String>[];
    _applyFullTextSearch(filters.busca, whereClauses, parameters);
    if (whereClauses.isNotEmpty) {
      sql.write(' AND ${whereClauses.join(' AND ')}');
    }

    sql.write(' ORDER BY id_${tableName} ASC LIMIT @limit OFFSET @offset;');

    final rows = await _database.query(
      sql: sql.toString(),
      parameters: parameters,
    );
    return rows.map(fromMap).toList();
  }

  void _applyFilters(
      LeadsFilters filters,
      StringBuffer sql,
      Map<String, dynamic> parameters,
      ) {

    if (filters.fonte != null && filters.fonte!.isNotEmpty) {
      sql.write(' AND fonte = @fonte');
      parameters['fonte'] = filters.fonte;
    }

    if (filters.status != null && filters.status!.isNotEmpty) {
      sql.write(' AND status = @status');
      parameters['status'] = filters.status;
    }


    if (filters.interesse != null && filters.interesse!.isNotEmpty) {
      final interesseEnum = InteresseEnum.values.firstWhere(
        (e) => e.name.toLowerCase() == filters.interesse!.toLowerCase(),
        orElse: () => InteresseEnum.utilizacao,
      );
      sql.write(' AND interesse = @interesse');
      parameters['interesse'] = interesseEnum.toName();
    }

    if (filters.parceiro != null && filters.parceiro!.isNotEmpty) {
      sql.write(' AND parceiro = @parceiro');
      parameters['parceiro'] = filters.parceiro;
    }
  }

  void _applyFullTextSearch(
      String? busca,
      List<String> clauses,
      Map<String, dynamic> parameters,
      ) {
    if (busca == null || busca.trim().isEmpty) return;
    final termoDeBuscaTexto = busca.trim();
    final buscaLimpa = termoDeBuscaTexto.replaceAll(RegExp(r'[-./]'), '');

    var buscaData = termoDeBuscaTexto;
    final dataRegex = RegExp(r'^(\d{2})\/(\d{2})\/(\d{4})$');
    final match = dataRegex.firstMatch(termoDeBuscaTexto);
    if (match != null) {
      final dia = match.group(1)!;
      final mes = match.group(2)!;
      final ano = match.group(3)!;
      buscaData = '$ano-$mes-$dia';
    }

    final campos = [
      'nome',
      'email',
      'cnpj',
      'telefone',
      'origem',
      'fonte',
      'meio',
      'anuncio',
      'interesse',
      'status',
      'parceiro'
    ];

    final likes = campos.map((c) => "$c ILIKE @busca").join(' OR ');
    clauses.add('''
      ($likes OR
      TO_CHAR(data_hora, 'DD/MM/YYYY') ILIKE @buscaData OR
      TO_CHAR(data_hora, 'YYYY-MM-DD') ILIKE @buscaData)
    ''');

    parameters['busca'] = '%${buscaLimpa.trim()}%';
    parameters['buscaData'] = '%$buscaData%';
  }

  Map<String, dynamic> toMap(LeadDto entity) {
    final map = <String, dynamic>{};

    if (entity.id_leads_comercial != null) {
      map['id_leads_comercial'] = entity.id_leads_comercial;
    }

    if (entity.interesse != null) {
      map['interesse'] = entity.interesse!.toName();
    }

    if (entity.status != null) {
      map['status'] = entity.status!.name;
    }

    if (entity.parceiro != null) {
      map['parceiro'] = entity.parceiro;
    }
    return map;
  }

  LeadDto fromMap(Map<String, dynamic> map) => LeadDto(
    id_leads_comercial: map['id_leads_comercial'],
    nome: map['nome'],
    email: map['email'],
    telefone: map['telefone'],
    cnpj: map['cnpj'],
    anuncio: map['anuncio'],
    meio: map['meio'],
    status: StatusEnum.fromName(map['status']),
    fonte: map['fonte'],
    interesse: InteresseEnum.fromName(map['interesse'] ?? ''),
    data_hora: map['data_hora'],
    parceiro: map['parceiro'],
  );
}
