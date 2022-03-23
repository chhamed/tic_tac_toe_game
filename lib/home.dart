import 'package:flutter/material.dart';
import 'package:tic_tac_toe/player.dart';
import 'package:tic_tac_toe/utils.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static final countMatrix = 3;
  static final double size = 92;
  List<List<String>>? matrix;
  String lastMove = Player.none;

  @override
  void initState() {
    super.initState();
    setEmptyFields();
  }

  void setEmptyFields() => setState(() => matrix = List.generate(
        countMatrix,
        (_) => List.generate(countMatrix, (_) => Player.none),
      ));

  Color getBackgroundColor() {
    final thisMove = lastMove == Player.X ? Player.O : Player.X;

    return getFieldColor(thisMove).withAlpha(150);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor:getBackgroundColor() ,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: Utils.modelBuilder(matrix!, (x, value) => buildRow(x)),
      ),
    );
  }
    Widget buildRow(int x) {
      final values = matrix![x];

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: Utils.modelBuilder(
          values,
          (y, value) => buildField(x, y),
        ),
      );
    }

    Color getFieldColor(String value) {
      switch (value) {
        case Player.O:
          return Colors.blue;
        case Player.X:
          return Colors.red;
        default:
          return Colors.white;
      }
    }

    Widget buildField(int x, int y) {
      final value = matrix![x][y];
      final color = getFieldColor(value);

      return Container(
        margin: const EdgeInsets.all(4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(size, size),
            primary: color,
          ),
          child: Text(value, style: const TextStyle(fontSize: 32)),
          onPressed: () => selectField(value, x, y),
        ),
      );
    }

  void selectField(String value, int x, int y) {
    if (value == Player.none) {
      final newValue = lastMove == Player.X ? Player.O : Player.X;

      setState(() {
        lastMove = newValue;
        matrix![x][y] = newValue;
      });

      if (isWinner(x, y)) {
        showEndDialog('Player $newValue Won');
      } else if (isEnd()) {
        showEndDialog('Tie !!');
      }
    }

    }






  bool isEnd() =>
      matrix!.every((values) => values.every((value) => value != Player.none));


  bool isWinner(int x, int y) {
    var col = 0, row = 0, diag = 0, rdiag = 0;
    final player = matrix![x][y];
    final n = countMatrix;

    for (int i = 0; i < n; i++) {
      if (matrix![x][i] == player) col++;
      if (matrix![i][y] == player) row++;
      if (matrix![i][i] == player) diag++;
      if (matrix![i][n - i - 1] == player) rdiag++;
    }

    return row == n || col == n || diag == n || rdiag == n;
  }

  Future showEndDialog(String title) => showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: const Text('Press to Restart the Game'),
      actions: [
        ElevatedButton(
          onPressed: () {
            setEmptyFields();
            Navigator.of(context).pop();
          },
          child: Text('Restart'),
        )
      ],
    ),
  );
  }

