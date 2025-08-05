class Pagination {
  final int page;
  final int limit;
  final int offset;

  Pagination (
    this.page ,
    this.limit,
  ) : offset = (page - 1) * limit;

  factory Pagination.fromQuery(int? page, int? limit) {
    final numPage = page ?? 1;
    final limitForPage = limit ?? 10 ;
    return Pagination(numPage, limitForPage);
  }
}