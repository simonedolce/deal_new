import 'package:flutter/material.dart';
import '../util/colors.dart';

class ElevatedCardExample extends StatelessWidget {
  const ElevatedCardExample({Key? key, required this.text})
      : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(100),
        onTap: () {
          Navigator.pushNamed(context, '/elencoDeal');
        },
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Theme.of(context).colorScheme.outline,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          child: SizedBox(
            width: 300,
            height: 200,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Text(text, style: const TextStyle(fontSize: 100)),
                  const Text('Deal',textAlign: TextAlign.center, style: TextStyle(fontSize: 20))
                ]
            ),
          ),
        ),
      )
    );
  }
}

