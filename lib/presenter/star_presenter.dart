import 'package:tugas_akhirr/models/star_model.dart';
import 'package:tugas_akhirr/network/base_network.dart';

abstract class FilmView{
  void showLoading();
  void hideLoading();
  void showFilmList(List<Film> filmList);
  void showError(String message);
}

class FilmPresenter {
  final FilmView view;
  FilmPresenter(this.view);
  Future <void> loadFilmData(String endpoint) async {
    try {
      final List<dynamic> data = await BaseNetwork.getData(endpoint);
      final filmList = data.map((json) => Film.fromJson(json)).toList();
      view.showFilmList(filmList);
    } catch(e){
      view.showError(e.toString());
    }finally {
      view.hideLoading();
    }
  }
}


