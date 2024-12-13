import 'dart:async';
import 'dart:js_interop';

import 'package:animation_toolkit/animation_toolkit.dart';
import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:audioplayers/audioplayers.dart';
import 'package:data_widget/data_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:kiddoquest2/assets/asset_manager.dart';
import 'package:kiddoquest2/assets/audios.dart';
import 'package:web/web.dart';

class MusicManager extends StatefulWidget {
  final Widget child;

  const MusicManager({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<MusicManager> createState() => _MusicManagerState();
}

const kMusicVolume = #volume_music;
const kSfxVolume = #volume_sfx;
const kMusicStack = #music_stack;

class _MusicManagerState extends State<MusicManager>
    implements _MusicContainer {
  final ValueNotifier<double> musicVolume = ValueNotifier(1.0);
  final ValueNotifier<double> sfxVolume = ValueNotifier(1.0);
  final ValueNotifier<List<_Music>> musicStack = ValueNotifier([]);

  @override
  Widget build(BuildContext context) {
    return Data<_MusicContainer>.inherit(
      data: this,
      child: MultiModel(
        data: [
          ModelNotifier<double>(kMusicVolume, musicVolume),
          ModelNotifier<double>(kSfxVolume, sfxVolume),
          ModelNotifier<List<_Music>>(kMusicStack, musicStack),
        ],
        child: ListenableBuilder(
            listenable: Listenable.merge([musicVolume, musicStack]),
            builder: (context, child) {
              return AnimatedValueBuilder<_Music?>(
                  value:
                      musicStack.value.isEmpty ? null : musicStack.value.first,
                  duration: const Duration(seconds: 1),
                  lerp: _Music.lerp,
                  builder: (context, music, child) {
                    return _MusicPlayer(
                      volume: musicVolume.value,
                      music: music,
                      child: widget.child,
                    );
                  });
            }),
      ),
    );
  }

  @override
  set stack(List<_Music> stack) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      musicStack.value = stack;
    });
  }
}

class _Music {
  final AudioAsset music;
  final double volumeMultiplier;

  const _Music({
    required this.music,
    required this.volumeMultiplier,
  });

  _Music copyWith({
    AudioAsset? music,
    double? volumeMultiplier,
  }) {
    return _Music(
      music: music ?? this.music,
      volumeMultiplier: volumeMultiplier ?? this.volumeMultiplier,
    );
  }

  static _Music? lerp(_Music? a, _Music? b, double t) {
    if (a == null) {
      if (b == null) {
        return null;
      }
      return b.copyWith(volumeMultiplier: t);
    }
    if (b == null) {
      return a.copyWith(volumeMultiplier: 1 - t);
    }
    if (a.music == b.music) {
      return t < 0.5 ? a : b;
    }
    if (t < 0.5) {
      return a.copyWith(
        volumeMultiplier: (0.5 - t) * 2, // fades out
      );
    } else {
      return b.copyWith(
        volumeMultiplier: (t - 0.5) * 2, // fades in
      );
    }
  }
}

mixin _MusicContainer {
  set stack(List<_Music> stack);
}

class MusicScene extends StatefulWidget {
  final AudioAsset music;
  final bool play;
  final Widget child;

  const MusicScene({
    Key? key,
    required this.music,
    this.play = true,
    required this.child,
  }) : super(key: key);

  @override
  State<MusicScene> createState() => _MusicSceneState();
}

// Map<String, AudioPlayer> _sfxGroups = {};
Map<String, ap.AudioContext> _sfxGroups = {};

Future<void> playSound(AudioAsset audio, [String group = 'default']) async {
  // AudioPlayer? player = _sfxGroups[group];
  // if (player == null) {
  //   player = AudioPlayer();
  //   _sfxGroups[group] = player;
  // }
  AudioPlayer player = AudioPlayer();
  // await player.pause();
  // await player.setSourceBytes(audio.bytes);
  // await player.seek(Duration.zero);
  // await player.resume();
  ap.AudioContext? context = _sfxGroups[group];
  if (context == null) {
    context = ap.AudioContext();
    _sfxGroups[group] = context;
  }
  await player.play(BytesSource(audio.bytes), ctx: _sfxGroups[group]);
  Duration? duration = await player.getDuration();
  print('Playing sound ($group): ${audio.name} (duration: $duration)');
  await Future.delayed((await player.getDuration())!);
  await player.dispose();
}

Future<void> playVoiceline(AudioAsset audio) {
  return playSound(audio, 'voiceline');
}

void playUISound(AudioAsset audio) {
  playSound(audio, 'ui');
}

enum GameCharacter { tama, amel }

Future<void> playCountdown(int count) {
  switch (count) {
    case 5:
      return playSound(countdown5, 'voiceline');
    case 4:
      return playSound(countdown4, 'voiceline');
    case 3:
      return playSound(countdown3, 'voiceline');
    case 2:
      return playSound(countdown2, 'voiceline');
    case 1:
      return playSound(countdown1, 'voiceline');
    default:
      return Future.value();
  }
}

Future<void> playCountSound(int count, GameCharacter character,
    [String group = 'default']) async {
  List<AudioAsset> singles;
  AudioAsset belasan;
  AudioAsset puluhan;
  AudioAsset ten;
  AudioAsset eleven;
  if (character == GameCharacter.tama) {
    singles = [
      tamaSatu,
      tamaDua,
      tamaTiga,
      tamaEmpat,
      tamaLima,
      tamaEnam,
      tamaTujuh,
      tamaDelapan,
      tamaSembilan,
    ];
    belasan = tamaBelas;
    puluhan = tamaPuluh;
    ten = tamaSepuluh;
    eleven = tamaSebelas;
  } else {
    // TODO amel
    singles = [];
    belasan = tamaBelas;
    puluhan = tamaPuluh;
    ten = tamaSepuluh;
    eleven = tamaSebelas;
  }
  if (count < 10) {
    await playSound(singles[count - 1], group);
  } else if (count == 10) {
    await playSound(ten, group);
  } else if (count == 11) {
    await playSound(eleven, group);
  } else if (count < 20) {
    await playSound(singles[count - 11], group);
    await playSound(belasan, group);
  } else if (count % 10 == 0) {
    await playSound(singles[count ~/ 10 - 1], group);
    await playSound(ten, group);
  }
}

Future<void> playRoundSound(int count, GameCharacter character,
    [String group = 'voiceline']) async {
  List<AudioAsset> singles;
  AudioAsset prefix;
  AudioAsset satu;
  AudioAsset belasan;
  AudioAsset puluhan;
  AudioAsset ten;
  AudioAsset eleven;
  if (character == GameCharacter.tama) {
    prefix = tamaBabakKe;
    satu = tamaRound1;
    singles = [
      tamaSatu,
      tamaDua,
      tamaTiga,
      tamaEmpat,
      tamaLima,
      tamaEnam,
      tamaTujuh,
      tamaDelapan,
      tamaSembilan,
    ];
    belasan = tamaBelas;
    puluhan = tamaPuluh;
    ten = tamaSepuluh;
    eleven = tamaSebelas;
  } else {
    // TODO amel
    prefix = tamaBabakKe;
    satu = tamaRound1;
    singles = [];
    belasan = tamaBelas;
    puluhan = tamaPuluh;
    ten = tamaSepuluh;
    eleven = tamaSebelas;
  }
  if (count == 1) {
    await playSound(satu, group);
    return;
  }
  await playSound(tamaBabakKe);
  if (count < 10) {
    await playSound(singles[count - 1], group);
  } else if (count == 10) {
    await playSound(ten, group);
  } else if (count == 11) {
    await playSound(eleven, group);
  } else if (count < 20) {
    await playSound(singles[count - 11], group);
    await playSound(belasan, group);
  } else if (count % 10 == 0) {
    await playSound(singles[count ~/ 10 - 1], group);
    await playSound(ten, group);
  }
}

SpeechSynthesisVoice? _indonesianVoice;

bool prepareTTS() {
  final synth = window.speechSynthesis;
  if (_indonesianVoice == null) {
    for (var voice in synth.getVoices().toDart) {
      print('Voice: ${voice.name} (${voice.lang})');
      if (voice.lang == 'id-ID') {
        _indonesianVoice = voice;
        break;
      }
    }
  }
  if (_indonesianVoice == null) {
    print('No Indonesian voice found');
  }
  return _indonesianVoice != null;
}

Future<void> playTTS(String text) async {
  prepareTTS();
  print('Playing TTS: $text');
  var utterThis = SpeechSynthesisUtterance(text);
  Completer<void> completer = Completer();
  void onEnd() {
    completer.complete();
  }

  utterThis.onend = onEnd.toJS;
  var synth = window.speechSynthesis;
  if (_indonesianVoice != null) {
    utterThis.voice = _indonesianVoice;
    utterThis.lang = 'id-ID';
    utterThis.rate = 1.0;
    synth.speak(utterThis);
  } else {
    print('No Indonesian voice found');
    return;
  }
  return completer.future;
}

abstract class SoundPart {
  const SoundPart();
}

class SoundAssetPart extends SoundPart {
  final AudioAsset audio;

  const SoundAssetPart(this.audio);
}

class SilentPart extends SoundPart {
  final Duration duration;

  const SilentPart(this.duration);
}

class _MusicSceneState extends State<MusicScene> implements _MusicContainer {
  late _MusicContainer _parent;
  List<_Music> _localStack = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _parent = Data.of(context);
    _parent.stack = [
      if (widget.play) _Music(music: widget.music, volumeMultiplier: 1),
      ..._localStack,
    ];
  }

  @override
  void didUpdateWidget(covariant MusicScene oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.music != oldWidget.music || widget.play != oldWidget.play) {
      _parent.stack = [
        if (widget.play) _Music(music: widget.music, volumeMultiplier: 1),
        ..._localStack,
      ];
    }
  }

  @override
  set stack(List<_Music> stack) {
    _localStack = stack;
    _parent.stack = [
      if (widget.play) _Music(music: widget.music, volumeMultiplier: 1),
      ..._localStack,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Data<_MusicContainer>.inherit(
      data: this,
      child: widget.child,
    );
  }
}

class _MusicPlayer extends StatefulWidget {
  final _Music? music;
  final Widget child;
  final double volume;

  const _MusicPlayer({
    Key? key,
    required this.music,
    required this.child,
    required this.volume,
  }) : super(key: key);

  @override
  State<_MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<_MusicPlayer> {
  AudioSession? player;
  late ModelProperty<double> musicVolume;
  Future? _operation;

  @override
  void initState() {
    super.initState();
    if (widget.music != null) {
      _createPlayer();
    }
  }

  Future<T> _push<T>(Future<T> Function() future) {
    if (_operation == null) {
      final operation = future();
      _operation = operation;
      return operation;
    }
    return _operation!.then((_) {
      final operation = future();
      _operation = operation;
      return operation;
    });
  }

  void _disposePlayer() {
    // player?.dispose();
    if (player != null) {
      _push(player!.dispose);
    }
    player = null;
  }

  void _createPlayer() {
    double volume = widget.music!.volumeMultiplier * widget.volume;
    player = widget.music!.music.playAudio(volume: volume);
  }

  @override
  void didUpdateWidget(covariant _MusicPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.music?.music != oldWidget.music?.music) {
      print('Music changed to ${widget.music?.music.name}');
      _disposePlayer();
      if (widget.music != null) {
        _createPlayer();
      }
    }
    if ((widget.music?.volumeMultiplier != oldWidget.music?.volumeMultiplier ||
            widget.volume != oldWidget.volume) &&
        player != null &&
        widget.music != null) {
      var volume = widget.music!.volumeMultiplier * widget.volume;
      _push(() {
        return player!.setVolume(volume);
      });
    }
  }

  @override
  void dispose() {
    _disposePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class WebAudioToggler extends StatelessWidget {
  final Widget child;

  WebAudioToggler({required this.child});

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (event) {
        if (!audioCanBeLoaded) {
          audioCanBeLoaded = true;
          audioLoadQueue.forEach((audio) {
            audio();
          });
          audioLoadQueue.clear();
        }
      },
      child: child,
    );
  }
}
