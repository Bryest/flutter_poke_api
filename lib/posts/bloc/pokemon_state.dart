part of 'pokemon_bloc.dart';

enum PokemonStatus { initial, success, failure }

class PokemonState extends Equatable {
  const PokemonState({
    this.status = PokemonStatus.initial,
    this.pokemons = const <Pokemon>[],
    this.hasReachedMax = false,
  });

  final PokemonStatus status;
  final List<Pokemon> pokemons;
  final bool hasReachedMax;

  PokemonState copyWith({
    PokemonStatus? status,
    List<Pokemon>? pokemons,
    bool? hasReachedMax,
  }) {
    return PokemonState(
      status: status ?? this.status,
      pokemons: pokemons ?? this.pokemons,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''PokemonState { status: $status, hasReachedMax: $hasReachedMax, pokemons: ${pokemons.length} }''';
  }

  @override
  List<Object> get props => [status, pokemons, hasReachedMax];
}
