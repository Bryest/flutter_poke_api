// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class Pokemon extends Equatable {
  const Pokemon({
    required this.id,
    required this.name,
    required this.url,
    required this.sprite,
    required this.types,
  });

  final int id;
  final String name;
  final String url;
  final String sprite;
  final List types;

  @override
  List<Object> get props => [id, name, url, sprite];

  factory Pokemon.fromMap(Map<String, dynamic> map, url) {
    return Pokemon(
      id: map['id'] as int,
      name: map['name'] as String,
      url: url as String,
      sprite: map['sprites']['front_default'] as String,
      types: map['types'] as List,
    );
  }
}
