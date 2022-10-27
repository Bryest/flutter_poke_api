import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_infinite_list/posts/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:stream_transform/stream_transform.dart';

part 'pokemon_event.dart';
part 'pokemon_state.dart';

const _postLimit = 20;
int index = 0;
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  PokemonBloc({required this.httpClient}) : super(const PokemonState()) {
    on<PokemonFetched>(
      _onPokemonFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final http.Client httpClient;

  Future<void> _onPokemonFetched(
    PokemonFetched event,
    Emitter<PokemonState> emit,
  ) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == PokemonStatus.initial) {
        final pokemons = await _fetchPokemons();
        return emit(
          state.copyWith(
            status: PokemonStatus.success,
            pokemons: pokemons,
            hasReachedMax: false,
          ),
        );
      }
      final pokemons = await _fetchPokemons(state.pokemons.length);
      pokemons.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
              state.copyWith(
                status: PokemonStatus.success,
                pokemons: List.of(state.pokemons)..addAll(pokemons),
                hasReachedMax: false,
              ),
            );
    } catch (_) {
      emit(state.copyWith(status: PokemonStatus.failure));
    }
  }

  //https://pokeapi.co/api/v2/pokemon?limit=100000&offset=0
  Future<List<Pokemon>> _fetchPokemons([int startIndex = 0]) async {
    final response = await http.get(
      Uri.https(
        'pokeapi.co',
        '/api/v2/pokemon',
        <String, String>{'limit': '$_postLimit', 'offset': '$startIndex'},
      ),
    );
    if (response.statusCode == 200) {
      return getPokemon(response);
    }
    throw Exception('error fetching pokemon');
  }

  Future<List<Pokemon>> getPokemon(http.Response response) async {
    List<Pokemon> pokemons = List<Pokemon>.empty(growable: true);
    // Url almacena la lista de Url de los pokemon.
    final url = await getUrl(response);
    //Aca se deberia hacer un fetch de esos URL obtenidos.
    for (var i = 0; i < 19; i++) {
      final detail =
          await getUrl(response).then((value) => getDetails(value[i]));
      pokemons.add(detail);
    }

    return pokemons;
  }

  Future<List<String>> getUrl(http.Response response) async {
    final body = json.decode(response.body)['results'] as List;
    return body.map((dynamic json) {
      final map = json as Map<String, dynamic>;
      return map['url'] as String;
    }).toList();
  }

  Future<Pokemon> getDetails(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      final pokemon = Pokemon.fromMap(body, url);
      return pokemon;
    }
    throw Exception('error fetchin pokemon');
  }
}
