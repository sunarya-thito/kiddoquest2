import 'package:data_widget/data_widget.dart';
import 'package:flutter/material.dart';

import 'game_screen.dart';

class FlashLoadingScene extends StatelessWidget {
  const FlashLoadingScene({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameScreenInfo = Data.of<GameScreenInfo>(context);
    return Container(
      color: Colors.white.withOpacity(gameScreenInfo.progress),
    );
  }
}
