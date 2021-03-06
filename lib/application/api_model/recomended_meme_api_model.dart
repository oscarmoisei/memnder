import 'package:flutter/material.dart';

class RecomendedMemeApiModel{
  final int id;
  final List<String> images;
  final int likes;
  final int dislikes;

  const RecomendedMemeApiModel(
    {
      @required this.id,
      @required this.images,
      @required this.likes,
      @required this.dislikes
    }
  );

  factory RecomendedMemeApiModel.fromJson(Map<String, dynamic> json){

    return RecomendedMemeApiModel(
      id: json["id"],
      images: (json["images"] as List).cast<String>(),
      likes: json["likes"],
      dislikes: json["dislikes"]
    );
  }

  RecomendedMemeApiModel copyWith({int id, int likes, int dislikes, List<String> images}){
    return RecomendedMemeApiModel(
      id: id ?? this.id,
      likes: likes ?? this.likes,
      dislikes: dislikes ?? this.dislikes,
      images: images ?? this.images
    );
  }
}