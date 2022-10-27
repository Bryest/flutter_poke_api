import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_infinite_list/posts/pokemons.dart';
import 'package:http/http.dart' as http;

class PokemonsPage extends StatelessWidget {
  const PokemonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PokemonAPI')),
      body: BlocProvider(
        create: (_) =>
            PokemonBloc(httpClient: http.Client())..add(PokemonFetched()),
        child: const PokemonList(),
      ),
    );
  }
}
