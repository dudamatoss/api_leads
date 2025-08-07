import 'package:api_leads/src/modules/leads/dto/filters.dart';
import 'package:api_leads/src/modules/leads/dto/leads_dto.dart';
import 'package:api_leads/src/modules/leads/dto/leads_total_dto.dart';
import 'package:api_leads/src/modules/leads/repository/i_leads_repository.dart';
import 'package:api_leads/src/modules/leads/services/i_leads_service.dart';
import 'package:vaden/vaden.dart';

@Scope(BindType.instance)
@Service()
 class LeadsService implements ILeadsService {
  final ILeadsRepository _repository;

  LeadsService(this._repository);

  @override
  Future<LeadDto> update(LeadDto entity) async {
    return await _repository.update(entity);
  }
  @override
  Future<List<LeadDto>> getAll(int offset, int limit) async {
    return await _repository.getAll(offset, limit);
  }

  @override
  Future<LeadTotaisDto> getAllTotal(LeadsFilters filters) async {
    return await _repository.getAllTotal(filters);
  }

  @override
  Future<List<LeadDto>> getAllByFilter(LeadsFilters filters, int limit, int offset) async {
    return await _repository.getAllByFilter(filters, limit, offset);
  }
}
