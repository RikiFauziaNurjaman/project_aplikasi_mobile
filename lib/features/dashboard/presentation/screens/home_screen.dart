import 'package:flutter/material.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Column(children: [],),
                SizedBox(width: 80),
                Column(children: [Text('Ahai')],),
                SizedBox(width: 80),
                Column(children: [Text('Ahai')],),
              ],
            ),
            Row(
              children: [
                Column(children: [],),
                Column(),
                Column()
              ],
            )
          ],
        ),
      ), 
    ); 
  }
}
