import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
Future<CategoryList> parseCategory(var response){
  final parsed = jsonDecode(utf8.decode(response.bodyBytes)).cast<Map<String, dynamic>>();
  return parsed.map<CategoryList>((json)=>CategoryList.fromMap(json)).toList();
}
Future<List<CategoryList>> fetchCategory() async {
 var uri= Uri.parse('http://127.0.0.1:8000/app/category-list/?format=json') ;
     http.Response response = await http.get(uri);

  if (response.statusCode == 200) {
    return parseCategory(response);
  } else {
    throw Exception('Failed to load album');
  }
}

class CategoryList {
  final String url;
  final int id;
  final String name;

  CategoryList({
     required this.url,
     required this.id,
     required this.name,
  });

  factory CategoryList.fromMap(Map<String, dynamic> json) {
    return CategoryList(
      url: json['url'],
      id: json['pk'],
      name: json['name'],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
   // List<CategoryList> parseCategory = [];

  @override
  void initState() {
    super.initState();
     fetchCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
      body: FutureBuilder(

      builder:  (context, snapshot){
        if (snapshot.hasData){
          return ListView.builder(
              itemCount: snapshot.data!.name.length,
              itemBuilder: (context, index){
                var categories = snapshot.data!.name[index];
            return Container(
              height: 100,
             child: Row(
               children:<Widget> [
                 Text(categories)
                ]
                 ),


            );
          });
        }else{
          return const Center(child: CircularProgressIndicator());
        }

      })
        );
  }
}
