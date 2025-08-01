import 'package:api_leads/src/modules/leads/dto/leads_dto.dart';

abstract class ILeadsService {

  Future<LeadDto> update(LeadDto lead);

  Future<List<LeadDto>> getAll(int page, int limit);

}