import 'package:api_leads/src/modules/leads/dto/leads_dto.dart';

abstract class ILeadsRepository {

  Future<LeadDto> update(LeadDto entity);

  Future<List<LeadDto>> getAll(int page, int limit);
}