import 'package:api_leads/src/modules/leads/dto/filters.dart';
import 'package:api_leads/src/modules/leads/dto/leads_dto.dart';
import 'package:api_leads/src/modules/leads/dto/leads_total_dto.dart';

abstract class ILeadsService {

  Future<LeadDto> update(LeadDto lead);

  Future<LeadTotaisDto> getAllTotal(LeadsFilters filters, int limit);

  Future<List<LeadDto>> getAllByFilter(LeadsFilters filters, int limit, int offset);

}