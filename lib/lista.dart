import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class PostList extends StatefulWidget {
  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  Dio dio = Dio();
  List<dynamic> posts = [];
  Map<int, double> ratings = {};

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      Response response =
          await dio.get('https://jsonplaceholder.typicode.com/posts');
      setState(() {
        posts = response.data;
        posts.forEach((post) {
          ratings[post['id']] = 0.0;
        });
      });
    } catch (error) {
      print('Error fetching posts: $error');
    }
  }

  List<dynamic> getPostsWithHighestRating() {
    // Obtiene el valor máximo de calificación
    double maxRating = ratings.values.isNotEmpty
        ? ratings.values.reduce((a, b) => a > b ? a : b)
        : 0.0;
    // Filtra los posts con la calificación más alta
    return posts.where((post) => ratings[post['id']] == maxRating).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('filtrar post:'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt),
            onPressed: () {
              // Filtra y muestra los posts con la calificación más alta
              List<dynamic> filteredPosts = getPostsWithHighestRating();
              setState(() {
                posts = filteredPosts;
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(posts[index]['title']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(posts[index]['body']),
                SizedBox(height: 8),
                RatingBar.builder(
                  initialRating: ratings[posts[index]['id']] ?? 0.0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 20,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      ratings[posts[index]['id']] = rating;
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
