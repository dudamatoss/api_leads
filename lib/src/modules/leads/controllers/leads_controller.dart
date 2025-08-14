import 'package:api_leads/src/modules/leads/dto/filters.dart';
import 'package:api_leads/src/modules/leads/dto/leads_dto.dart';
import 'package:api_leads/src/modules/leads/dto/leads_total_dto.dart';
import 'package:api_leads/src/modules/leads/dto/pagination.dart';
import 'package:api_leads/src/modules/leads/services/i_leads_service.dart';
import 'package:vaden/vaden.dart';
@Api(tag: 'Leads', description: 'Controller para gerenciar leads')
@Controller('/leads')
class LeadsController {
  final ILeadsService _leadsService;

  LeadsController(this._leadsService);

  @ApiOperation(
      summary: 'Atualiza um lead',
      description: 'Recebe um lead e atualiza no banco de dados.'
  )
  @ApiResponse(200, description: 'Lead atualizado com sucesso', content: ApiContent(type: 'application/json', schema: LeadDto))
  @ApiResponse(400, description: 'Requisição inválida', content: ApiContent(type: 'application/json'))
  @ApiResponse(401, description: 'Não autorizado', content: ApiContent(type: 'application/json'))
  @ApiResponse(422, description: 'Lead já existe', content: ApiContent(type: 'application/json'))
  @ApiResponse(500, description: 'Erro interno do servidor', content: ApiContent(type: 'application/json'))
  @ApiSecurity(['apiKey'])
  @Put()
  Future<LeadDto> update(@Body() LeadDto lead) => _leadsService.update(lead);


  //filtros
  @ApiOperation(
      summary: 'mostra leads de acordo com o filtro',
      description: 'Busca todos os leads filtrando pela usuario.'
  )
  @ApiResponse(200, description: 'Leads encontrados com sucesso', content: ApiContent(type: 'application/json', schema: List<LeadDto>))
  @ApiResponse(400, description: 'Requisição inválida', content: ApiContent(type: 'application/json'))
  @ApiResponse(401, description: 'Não autorizado', content: ApiContent(type: 'application/json'))
  @ApiResponse(500, description: 'Erro interno do servidor', content: ApiContent(type: 'application/json'))
  @ApiSecurity(['apiKey'])
  @Get('/filtro')
  Future<List<LeadDto>> getAllByFilter(@Query('page') int? page, @Query('limit') int? limit,@Query('fonte') String? fonte,
  @Query('parceiro') String? parceiro, @Query('interesse')String? interesse, @Query('status') String? status, @Query('busca') String? busca) async {
    final pagination = Pagination.fromQuery(page, limit);
    final filters = LeadsFilters(
      fonte: fonte,
      status: status,
      interesse: interesse,
      parceiro: parceiro,
      busca: busca
    );
    return _leadsService.getAllByFilter(filters, pagination.limit, pagination.offset);
  }

  @ApiOperation(
      summary: 'Busca totais de leads',
      description: 'Busca totais de leads filtrando por interesse e status.'
  )
  @ApiResponse(200, description: 'Totais de leads encontrados com sucesso', content: ApiContent(type: 'application/json', schema: LeadTotaisDto))
  @ApiResponse(400, description: 'Requisição inválida', content: ApiContent(type: 'application/json'))
  @ApiResponse(401, description: 'Não autorizado', content: ApiContent(type: 'application/json'))
  @ApiResponse(500, description: 'Erro interno do servidor', content: ApiContent(type: 'application/json'))
  @ApiSecurity(['apiKey'])
  @Get('/totais')
  Future<LeadTotaisDto> getAllTotal(@Query('fonte') String? fonte, @Query('parceiro') String? parceiro,
      @Query('interesse') String? interesse, @Query('status') String? status, @Query('limit') int? limit, @Query('busca') String? busca) {
    final pagination = Pagination.fromQuery(null, limit);
    final filters = LeadsFilters(
      fonte: fonte,
      status: status,
      interesse: interesse,
      parceiro: parceiro,
      busca: busca
    );
    return _leadsService.getAllTotal(filters, pagination.limit);
  }
}