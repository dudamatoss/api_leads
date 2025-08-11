import 'package:api_leads/src/modules/leads/dto/filters.dart';
import 'package:api_leads/src/modules/leads/dto/leads_dto.dart';
import 'package:api_leads/src/modules/leads/dto/leads_total_dto.dart';

abstract class ILeadsRepository {

  Future<LeadDto> update(LeadDto entity);

  Future<LeadTotaisDto> getAllTotal(LeadsFilters filters);

  Future<List<LeadDto>> getAllByFilter(LeadsFilters filters, int limit, int offset);
}