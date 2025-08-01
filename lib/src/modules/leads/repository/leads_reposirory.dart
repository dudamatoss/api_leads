import 'package:api_leads/src/modules/leads/dto/leads_dto.dart';
import 'package:api_leads/src/modules/leads/enum/interesse_enum.dart';
import 'package:api_leads/src/modules/leads/enum/ststus_enum.dart';
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
  Future<List<LeadDto>> getAll( int page, int limit) async {
    int offset = page * limit;
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
    anuncio
	  FROM $tableName LIMIT @limit OFFSET @offset; ''',
      parameters: {'limit': limit, 'offset': offset},
    )
    .then((rows) => rows.map((map) => fromMap(map)).toList());
    print(result);
    return result;
  }

  Map<String, dynamic> toMap(LeadDto entity) {
    return {
      'id_lead': entity.id_leads_comercial,
      'interesse': entity.interesse,
      'status': entity.status,
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
    status: StatusEnum.values.firstWhere(
          (e) => e.name == map['status'],
      orElse: () => StatusEnum.pendente,
    ),
    fonte: map['fonte'],
    interesse: InteresseEnum.values.firstWhere(
          (e) => e.name == map['interesse'],
      orElse: () => InteresseEnum.utilizacao,
    ),
    data_hora: map['data_hora'],
  );

}