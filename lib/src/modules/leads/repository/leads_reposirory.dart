import 'package:api_leads/src/modules/leads/dto/filters.dart';
import 'package:api_leads/src/modules/leads/dto/leads_dto.dart';
import 'package:api_leads/src/modules/leads/repository/i_leads_repository.dart';
import 'package:api_leads/src/shared/database/database.dart';
import 'package:vaden/vaden.dart';

@Scope(BindType.instance)
@Repository()
class LeadsRepository implements ILeadsRepository {
  final Database _database;

  String get tableName => 'leads_comercial';

  LeadsRepository(this._database);

  @override
  Future<LeadDto> update(LeadDto entity) async {
    await _database.update(tableName: tableName, values: toMap(entity));
    return entity;
  }

  @override
  Future<List<LeadDto>> getAll( int offset, int limit) async {
    final result  = await _database.query(
    sql: ''' SELECT 
    id_${tableName},
    data_hora, nome,
    email,
    cnpj,
    telefone,
    interesse,
    fonte,
    meio,
    anuncio,
    status,
    parceiro
	  FROM $tableName ORDER BY id_${tableName} ASC  LIMIT @limit OFFSET @offset ; ''',
      parameters: {'limit': limit, 'offset': offset},
    )
    .then((rows) => rows.map((map) => fromMap(map)).toList());
    return result;
  }

  //QUERY DINAMICA
  @override
  Future<List<LeadDto>> getAllByFilter (LeadsFilters filters, int offset, int limit) async {

    final result = StringBuffer('''
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
    final parameters = <String, dynamic>{
      'limit': limit,
      'offset': offset,
    };

    if (filters.fonte != null && filters.fonte!.isNotEmpty) {
      result.write(' AND fonte = @fonte');
      parameters['fonte'] = filters.fonte;

      print("📥 Fonte recebida: ${filters.fonte}");
    }

    if (filters.status != null && filters.status!.isNotEmpty) {
      result.write(' AND status = @status');
      parameters['status'] = filters.status;
    }
    print("📥 Status recebido: ${filters.status}");

    if (filters.interesse != null && filters.interesse!.isNotEmpty) {
      final interesseEnum = InteresseEnum.values.firstWhere(
            (e) => e.name.toLowerCase() == filters.interesse!.toLowerCase(),
        orElse: () => InteresseEnum.utilizacao,
      );
      result.write(' AND interesse = @interesse');
      parameters['interesse'] = interesseEnum.toName();
    }
    print("📥 Interesse recebido: ${filters.interesse}");

    if (filters.parceiro != null && filters.parceiro!.isNotEmpty) {
      result.write(' AND parceiro = @parceiro');
      parameters['parceiro'] = filters.parceiro;
    }

    result.write(' ORDER BY id_${tableName} ASC LIMIT @limit OFFSET @offset;');

    final rows = await _database.query(
      sql: result.toString(),
      parameters: parameters,
    );
    return rows.map(fromMap).toList();

  }


  Map<String, dynamic> toMap(LeadDto entity) {
    return {
      'id_lead': entity.id_leads_comercial,
      'interesse': entity.interesse.toName(),
      'status': entity.status.name,
      'parceiro': entity.parceiro,
    };
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