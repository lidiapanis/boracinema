import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  group('Favorites Tests', () {
    late SharedPreferences sharedPreferences;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.remove('favorites');
    });

    test('Add and remove from favorites', () async {
      dynamic movie = {'title': 'Movie Title', 'director': 'Director'};

      // Adicionar filme aos favoritos
      List<dynamic> favorites = [];
      favorites.add(movie);
      List<String> favoriteStrings =
          favorites.map((e) => json.encode(e)).toList();
      await sharedPreferences.setStringList('favorites', favoriteStrings);

      // Verificar se o filme foi adicionado aos favoritos
      List<String>? storedFavorites =
          sharedPreferences.getStringList('favorites');
      expect(storedFavorites, isNotNull);
      expect(storedFavorites!.length, 1);
      expect(
          storedFavorites[0], '{"title":"Movie Title","director":"Director"}');

      // Remover filme dos favoritos
      favorites.remove(movie);
      favoriteStrings = favorites.map((e) => json.encode(e)).toList();
      await sharedPreferences.setStringList('favorites', favoriteStrings);

      // Verificar se o filme foi removido dos favoritos
      storedFavorites = sharedPreferences.getStringList('favorites');
      expect(storedFavorites, isNotNull);
      expect(storedFavorites!.length, 0);
    });
  });
}
