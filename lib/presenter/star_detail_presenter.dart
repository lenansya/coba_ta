import 'package:tugas_akhirr/network/base_network.dart';

abstract class FilmDetailView {
  void showLoading();
  void hideLoading();
  void showDetailData(Map<String, dynamic> detailData);
  void showError(String message);
}

class FilmDetailPresenter {
  final FilmDetailView view;
  FilmDetailPresenter(this.view);

  Future<void> loadDetailData(String endpoint, int id) async {
    view.showLoading();
    try {
      final data = await BaseNetwork.getDetailData(endpoint, id);
      view.showDetailData(data);
    } catch (e) {
      view.showError(e.toString());
    } finally {
      view.hideLoading();
    }
  }
}