import 'package:api_leads/src/modules/leads/dto/leads_dto.dart';
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
  Future<List<LeadDto>> getAll(int page, int limit) async {
    return await _repository.getAll(page, limit);
  }
}
