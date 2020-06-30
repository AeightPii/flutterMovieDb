import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_moviedb/movie.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  var url =
      "https://api.themoviedb.org/3/movie/top_rated?api_key=59e90160f05dc382b043b086e34c75c5";
  Moviedb moviedb;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    var data = await http.get(url);
    var jsonData = jsonDecode(data.body);
    moviedb = Moviedb.fromJson(jsonData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MovieDb'),
        backgroundColor: Colors.cyan,
      ),
      body: moviedb == null
      ? Center(
        child: CircularProgressIndicator()
        ) : GridView.count(
          crossAxisCount: 2,
          children: 
          moviedb.results.map((res) => Padding(
            padding: EdgeInsets.all(2.0),
            child: InkWell(
              onTap: (){
    
            Navigator.push(context,
            MaterialPageRoute(builder: (context) => 
            new Detail(results: res)
            )
            );
              },
              child: Hero(
                tag: res.posterPath,
                
                child: Card(
                
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        
                        height: 120.0,
                        child:Image.network("https://image.tmdb.org/t/p/w200${res.posterPath}",
                        //fit: BoxFit.fill
                        ),
                      ),
                      Text(
                        res.title,
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          
                        ),
                      )
                    ],
                  ),
                ),
                  
                ),
            ),
            )
          ).toList()
        
        ),
    );
  }
}

class Detail extends StatelessWidget {
  final Results results;
  Detail({this.results});
  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
        body: Center( 
          child: Container(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      
                      height: 400.0,
                      
                      child: Center(
                        child:Image.network(
                        "https://image.tmdb.org/t/p/w200${this.results.posterPath}",
                        fit: BoxFit.fill,
                      ),
                      )
                       
                    ),
                    AppBar(
                      backgroundColor: Colors.transparent,
                      leading: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.arrow_back_ios),
                      ),
                      elevation: 0,
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(height: 10.0,),
                      Text(this.results.title,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.2,
                        wordSpacing: 0.6
                      ),),
                      SizedBox(height: 20.0,),
                      Text(
                        this.results.overview,
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 16.0,
                          letterSpacing: 0.2,
                          wordSpacing: 0.3
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            this.results.releaseDate == null 
                            ? 'Unknown' : this.results.releaseDate,
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(this.results.originalTitle,
                          style: TextStyle(color: Colors.grey),)
                        ],
                      )
                    ],
                  ),                
                )
              ],
            ),
          ),
        ),
    );
  }
}
