import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_infinite_list/posts/pokemons.dart';

class PokemonList extends StatefulWidget {
  const PokemonList({super.key});

  @override
  State<PokemonList> createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PokemonBloc, PokemonState>(
      builder: (context, state) {
        switch (state.status) {
          case PokemonStatus.failure:
            return const Center(child: Text('failed to fetch pokemons'));
          case PokemonStatus.success:
            if (state.pokemons.isEmpty) {
              return const Center(child: Text('no pokemons'));
            }
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return index >= state.pokemons.length
                    ? const BottomLoader()
                    : PokemonListItem(pokemon: state.pokemons[index]);
              },
              itemCount: state.hasReachedMax
                  ? state.pokemons.length
                  : state.pokemons.length + 1,
              controller: _scrollController,
            );
          case PokemonStatus.initial:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<PokemonBloc>().add(PokemonFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
