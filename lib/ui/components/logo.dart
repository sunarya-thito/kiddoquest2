import 'package:flutter/widgets.dart';
import 'package:kiddoquest2/assets/images.dart';
import 'package:kiddoquest2/ui/components/entry.dart';

class KiddoQuestLogo extends StatelessWidget {
  final bool yellowBackground;
  final bool plusSign;

  const KiddoQuestLogo({
    super.key,
    this.yellowBackground = false,
    this.plusSign = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      clipBehavior: Clip.none,
      children: [
        Entry.scale(
          reverseDelay: Duration(milliseconds: 600),
          child: (yellowBackground ? imageLogoSplash : imageLogoSplashWhite)
              .createImage(),
        ),
        Positioned(
          top: 160,
          left: 340,
          right: -100,
          child: Entry.scale(
            delay: Duration(milliseconds: 600),
            reverseDelay: Duration.zero,
            child: imageLogoVersion.createImage(),
          ),
        ),
        Positioned(
          top: 30,
          left: 80,
          right: 100,
          child: Entry.scale(
            delay: Duration(milliseconds: 200),
            reverseDelay: Duration(milliseconds: 400),
            child: imageLogoUpper.createImage(fit: BoxFit.contain),
          ),
        ),
        Positioned(
          top: 100,
          left: 0,
          right: 120,
          child: Entry.scale(
            delay: Duration(milliseconds: 400),
            reverseDelay: Duration(milliseconds: 200),
            child: imageLogoLower.createImage(),
          ),
        ),
      ],
    );
  }
}
