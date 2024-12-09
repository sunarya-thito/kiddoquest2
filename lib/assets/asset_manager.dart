import 'dart:async';
import 'dart:ui' as ui;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

String get assetUrl {
  if (kDebugMode) {
    // relative path based on the flutter assets directory
    return '/assets/';
  } else {
    // github pages url
    return 'https://kiddo-quest2.github.io/kiddo-quest/assets/';
  }
}

abstract class GameAsset {
  String get name;
  Future<Uint8List> loadBytes([bool cache = true]);
  String get uri;
}

class BlobAsset implements GameAsset {
  @override
  final String name;

  BlobAsset(this.name);

  Future<Uint8List>? _loadedFuture;
  Uint8List? _bytes;

  @override
  Future<Uint8List> loadBytes([bool cache = true]) {
    if (cache && _loadedFuture != null) {
      return _loadedFuture!;
    }
    AssetBundle assetBundle = rootBundle;
    _loadedFuture = assetBundle
        .load(name)
        .then((value) => value.buffer.asUint8List())
        .then((value) async {
      _bytes = value;
      await _onLoad();
      print('Loaded $name');
      return value;
    });
    return _loadedFuture!;
  }

  Future<void> _onLoad() {
    return Future.value();
  }

  Uint8List get bytes {
    assert(_bytes != null, 'Asset $name has not been loaded yet');
    return _bytes!;
  }

  @override
  String get uri => '$assetUrl$name';
}

final List<Future<void> Function()> audioLoadQueue = [];
bool audioCanBeLoaded = false;

class AudioAsset extends BlobAsset {
  final bool loop;
  AudioAsset(String name, [this.loop = false])
      : super('assets/audios/$name.mp3');

  AudioPlayer? _player;

  @override
  Future<void> _onLoad() async {
    if (!audioCanBeLoaded) {
      audioLoadQueue.add(_onLoad);
      return;
    }
    _player = AudioPlayer();
    await _player!.setSourceBytes(bytes);
    if (loop) {
      await _player!.setReleaseMode(ReleaseMode.loop);
    }
  }

  AudioSession playAudio({double volume = 1.0}) {
    if (_player == null) {
      _player = AudioPlayer();
      _player!.setSourceBytes(bytes);
      if (loop) {
        _player!.setReleaseMode(ReleaseMode.loop);
      }
    }
    _player!.setVolume(volume);
    _player!.seek(Duration.zero).then(
      (value) async {
        return _player!.resume();
      },
    );
    return AudioSession(_player!);
  }
}

class AudioSession {
  final AudioPlayer _player;

  AudioSession(this._player);

  Future<void> dispose() async {
    // await _player.seek(Duration.zero);
    await _player.stop();
  }

  Future<void> setVolume(double volume) {
    return _player.setVolume(volume);
  }
}

class ImageAsset extends BlobAsset {
  ImageAsset(String name) : super('assets/images/$name.png');

  ui.Image? _image;

  ui.Image get image {
    assert(_image != null, 'Image $name has not been loaded yet');
    return _image!;
  }

  Image createImage({BoxFit? fit}) {
    return Image.memory(bytes, fit: fit);
  }

  @override
  Future<void> _onLoad() async {
    Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(bytes, (image) {
      _image = image;
      completer.complete(image);
    });
    await completer.future;
  }
}

class AnimationAsset extends BlobAsset {
  AnimationAsset(String name) : super('assets/images/$name.gif');

  Image createImage({BoxFit? fit}) {
    return Image.memory(bytes, fit: fit);
  }
}

class VideoAsset implements GameAsset {
  @override
  final String name;

  VideoAsset(String name) : name = 'assets/videos/$name.mp4';

  @override
  Future<Uint8List> loadBytes([bool cache = true]) async {
    throw UnimplementedError('');
  }

  @override
  String get uri => '$assetUrl$name';
}
