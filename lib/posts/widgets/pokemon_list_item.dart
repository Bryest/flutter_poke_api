import 'package:flutter/material.dart';
import 'package:flutter_infinite_list/posts/models/models.dart';

class PokemonListItem extends StatelessWidget {
  const PokemonListItem({super.key, required this.pokemon});

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Material(
      child: Card(
        child: Column(
          children: [
            ListTile(
              leading: Text('${pokemon.id}', style: textTheme.caption),
              trailing: Image.network(
                pokemon.sprite,
                fit: BoxFit.fill,
              ),
              title: Text(pokemon.name),
              isThreeLine: true,
              subtitle: Text(pokemon.url),
              dense: true,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(width: 20),
                for (var type in pokemon.types)
                  Row(children: [
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent),
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      child: Text(
                        CapitalizeString(type["type"]["name"].toString()),
                      ),
                    ),
                    SizedBox(width: 5),
                  ]),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

String CapitalizeString(String str) {
  if (str.length <= 1) {
    return str.toUpperCase();
  }
  return '${str[0].toUpperCase()}${str.substring(1)}';
}
