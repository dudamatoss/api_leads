import 'package:api_leads/src/modules/leads/dto/filters.dart';
import 'package:api_leads/src/modules/leads/dto/leads_dto.dart';

abstract class ILeadsService {

  Future<LeadDto> update(LeadDto lead);

  Future<List<LeadDto>> getAll(int offset, int limit);

  Future<List<LeadDto>> getAllByFilter(LeadsFilters filters, int limit, int offset);

}