import 'package:api_leads/src/modules/leads/dto/leads_dto.dart';
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
  Future<LeadDto> update(@Body() LeadDto lead) async {
    return await _leadsService.update(lead);
  }

  @ApiOperation(
      summary: 'Busca todos os leads',
      description: 'Busca todos os leads com paginação.'
  )
  @ApiResponse(200, description: 'Leads encontrados com sucesso', content: ApiContent(type: 'application/json', schema: List<LeadDto>))
  @ApiResponse(400, description: 'Requisição inválida', content: ApiContent(type: 'application/json'))
  @ApiResponse(401, description: 'Não autorizado', content: ApiContent(type: 'application/json'))
  @ApiResponse(500, description: 'Erro interno do servidor', content: ApiContent(type: 'application/json'))
  @ApiSecurity(['apiKey'])
  @Get()
  Future<List<LeadDto>> getAll(@Query('page') int page, @Query('limit') int limit) async {
    final pageNum  = page ?? 1;
    final leadForPage = limit ?? 15;
    // A pag 1 começa no item 0, entao subtrai 1 para calcular o inicio correto
    final offset = (pageNum - 1) * leadForPage;
    return await _leadsService.getAll(offset, leadForPage);
  }

}