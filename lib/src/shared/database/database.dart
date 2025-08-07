import 'package:postgres/postgres.dart';
import 'package:vaden/vaden.dart';

@Component()
 class Database {
  final Connection _connection;

  Database(this._connection);
  //ubserção ou atualização de registros na tabela de forma dinamica
  Future<void> update({
    required String tableName,
    required Map<String, dynamic> values,
    TxSession? txn,
  }) async {
    final updateValues = Map<String, dynamic>.from(values);
    final idColumn = 'id_$tableName';
    final idValue = updateValues.remove(idColumn);

    // Cria a lista de colunas e parâmetros para a query
    final columns = updateValues.keys.join(', ');
    final params = updateValues.keys.map((e) => '@$e').join(', ');
    // Verifica se a tabela possui o id e cria a query de inserção ou atualização
      final updateSet = updateValues.keys
          .map((key) => '$key = @$key')
          .join(', ');

      final query = '''
      UPDATE $tableName
      SET $updateSet
      WHERE $idColumn = @id_$tableName
       ''';
      updateValues['id_$tableName'] = idValue;

    await _executeQuery(query: query, parameters: updateValues, txn: txn);
  }
  // Metodo para executar uma query SQL e retornar o resultado
  Future<Result> _executeQuery({
    required String query,
    // Parâmetros opcionais para a query
    Map<String, dynamic>? parameters,
    TxSession? txn,
  }) async {
    final conn = txn ?? _connection;
    try {
      return await conn.execute(Sql.named(query), parameters: parameters);
    } on ServerException catch (e) {
      throw _tratarException(e);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
  //trata as exceções do servidor e retorna uma mensagem
  Exception _tratarException(ServerException e) {
    if (e.code == '3D000') {
      return Exception('Banco de dados não encontrado.');
    } else if (e.code == '28P01') {
      return Exception('Usuário ou senha inválidos.');
    } else if (e.code == '08006') {
      return Exception('Conexão recusada.');
    } else {
      return e;
    }
  }
  // Metodo para executar uma consulta SQL e retornar os resultados como uma lista de mapas
  Future<List<Map<String, dynamic>>> query({
    required String sql,
    Map<String, dynamic>? parameters,
    TxSession? txn,
  }) async {
    final result = await _executeQuery(
      query: sql,
      parameters: parameters,
      txn: txn,
    );
    return result.map((row) => row.toColumnMap()).toList();
  }
}