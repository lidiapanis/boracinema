import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:formatdate_pk/formatdate_pk.dart';

class MovieList extends StatefulWidget {
  const MovieList({super.key});

  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  List<dynamic> movies = [];
  List<dynamic> favorites = [];
  dynamic selectedMovie;

  @override
  void initState() {
    super.initState();
    fetchMovies();
    getFavorites();
  }

  Future<void> fetchMovies() async {
    final url = Uri.https(
      'api.themoviedb.org',
      '/3/movie/popular',
      {'api_key': 'c715b2f5b27f2ac57979bfdae56f5feb', 'language': 'pt-BR'},
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        movies = jsonData['results'];
      });
    } else {
      throw Exception('Failed to fetch movies');
    }
  }

  void getFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriteStrings = prefs.getStringList('favorites');

    if (favoriteStrings != null) {
      setState(() {
        favorites = favoriteStrings.map((e) => json.decode(e)).toList();
      });
    }
  }

  Future<void> addToFavorites(dynamic movie) async {
    setState(() {
      favorites.add(movie);
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteStrings =
        favorites.map((e) => json.encode(e)).toList();
    await prefs.setStringList('favorites', favoriteStrings);
  }

  Future<void> removeFromFavorites(dynamic movie) async {
    setState(() {
      favorites.remove(movie);
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteStrings =
        favorites.map((e) => json.encode(e)).toList();
    await prefs.setStringList('favorites', favoriteStrings);
  }

  void buildMovieList() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        String date = selectedMovie['release_date'] as String;
        date = formatDate(date);
        return Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                selectedMovie['title'],
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text(
                'Lançamento:' + formatDate(date),
                style: TextStyle(fontSize: 16.0),
                selectionColor: Colors.grey,
              ),
              SizedBox(height: 8.0),
              Text(
                'Avaliação: ${selectedMovie['vote_average']}/10',
                style: TextStyle(fontSize: 16.0),
                selectionColor: Colors.grey,
              ),
              SizedBox(height: 16.0),
              Text(
                'Sinopse: ${selectedMovie['overview']}',
                style: TextStyle(fontSize: 16.0),
              ),
              //SizedBox(height: 16.0),
              /*ElevatedButton(
                child: Text('Encontrar cinema próximo'),
                onPressed: () {
                  //findNearestCinema();
                },
              ),*/
            ],
          ),
        );
      },
    );
  }

  Widget buildMovieWidget(dynamic movie) {
    final isFavorite = favorites.contains(movie);

    return InkWell(
      onTap: () {
        setState(() {
          selectedMovie = movie;
        });
        buildMovieList();
      },
      child: Column(
        children: [
          Container(
            height: 300.0,
            width: 200.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(
                'https://image.tmdb.org/t/p/w200${movie['poster_path']}',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 4.0),
          Text(
            movie['title'],
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: () {
              if (isFavorite) {
                removeFromFavorites(movie);
              } else {
                addToFavorites(movie);
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text('Bora para o Cinema?'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.only(top: 16),
                child: Text(
                  'Arraste para o lado para navegar entre os filmes.\nClique no cartaz para ter mais informações sobre o filme.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                )),
            SizedBox(height: 30.0),
            CarouselSlider.builder(
              itemCount: movies.length,
              itemBuilder: (BuildContext context, int index, int realIndex) {
                final movie = movies[index];
                return buildMovieWidget(movie);
              },
              options: CarouselOptions(
                height: 400.0,
                enableInfiniteScroll: false,
                viewportFraction: 0.8,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Favoritos',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            favorites.isEmpty
                ? Text('Nenhum filme favorito.')
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: favorites.length,
                    itemBuilder: (BuildContext context, int index) {
                      final movie = favorites[index];

                      return ListTile(
                        leading: Container(
                          height: 50.0,
                          width: 30.0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4.0),
                            child: Image.network(
                              'https://image.tmdb.org/t/p/w200${movie['poster_path']}',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(movie['title']),
                        trailing: IconButton(
                          icon: Icon(Icons.remove_circle),
                          color: Color.fromARGB(255, 255, 159, 159),
                          onPressed: () {
                            removeFromFavorites(movie);
                          },
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    ));
  }
}
