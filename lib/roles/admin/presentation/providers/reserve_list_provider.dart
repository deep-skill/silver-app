import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silverapp/roles/admin/infraestructure/entities/reserve_list.dart';
import 'package:silverapp/roles/admin/infraestructure/models/reserves_list_response.dart';

final dio = Dio(BaseOptions(
  baseUrl:
      'http://${dotenv.env['YOUR_IP']}:${dotenv.env['SERVER_PORT']}/silver-api/',
));

List<ReserveList> _jsonToReserves(Map<String, dynamic> json) {
  final reserveListResponse = ReservesListResponse.fromJson(json);
  final List<ReserveList> reserves = reserveListResponse.rows.toList();
  return reserves;
}

final reservesListProvider =
    StateNotifierProvider<ReservesNotifier, List<ReserveList>>((ref) {
  Future<List<ReserveList>> getReserves({int page = 0}) async {
    final response = await dio.get('reserves/admin-reserves', queryParameters: {
      'page': page,
    });
    return _jsonToReserves(response.data);
  }

  final fetchMoreReserves = getReserves;
  return ReservesNotifier(fetchMoreReserves: fetchMoreReserves);
});

typedef ReserveCallback = Future<List<ReserveList>> Function({int page});

class ReservesNotifier extends StateNotifier<List<ReserveList>> {
  int currentPage = 0;
  bool isLoading = false;
  ReserveCallback fetchMoreReserves;

  ReservesNotifier({
    required this.fetchMoreReserves,
  }) : super([]);

  Future<void> loadNextPage() async {
    if (isLoading) return;
    //print('Loading new pages');
    isLoading = true;
    final List<ReserveList> reserves =
        await fetchMoreReserves(page: currentPage);
    currentPage++;
    state = [...state, ...reserves];
    await Future.delayed(const Duration(milliseconds: 400));
    isLoading = false;
  }
}
