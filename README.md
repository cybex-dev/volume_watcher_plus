Language: [English](README.md) | [中文简体](README-ZH.md)

Original maintainer [@salmanjones](https://github.com/salmanjones/volume_watcher) appears to have abandoned the project. This fork is to keep the project alive and updated under the name [volume_watcher_plus](https://pub.dev/packages/volume_watcher_plus). 

# volume_watcher_plus
* Support ios and android real-time return system volume value, maximum volume, initial volume, support set volume.

## Getting Started
```
dependencies:
  volume_watcher_plus: ^2.1.3
```

## Support Methods
```
VolumeWatcher.platformVersion
VolumeWatcher.getMaxVolume
VolumeWatcher.getCurrentVolume
VolumeWatcher.setVolume(0.0)
VolumeWatcher.addListener((double volume) {});
VolumeWatcher.removeListener(listenerId);
//Only valid on iOS
VolumeWatcher.hideVolumeView = true;
```

## Support Listener：
```
VolumeWatcher(
  onVolumeChangeListener: (double volume) {
    ///do sth.
  },
)
```

OR

```
final listenerId = VolumeWatcher.addListener((double volume) {});

// You can also cancel the listener with
VolumeWatcher.removeListener(listenerId);
```

## Super simple to use
```
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:volume_watcher_plus/volume_watcher_plus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  double currentVolume = 0;
  double initVolume = 0;
  double maxVolume = 0;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      VolumeWatcher.hideVolumeView = true;
      platformVersion = await VolumeWatcher.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    double initVolume = 0;
    double maxVolume = 0;
    try {
      initVolume = await VolumeWatcher.getCurrentVolume;
      maxVolume = await VolumeWatcher.getMaxVolume;
    } on PlatformException {
      platformVersion = 'Failed to get volume.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      this.initVolume = initVolume;
      this.maxVolume = maxVolume;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin Example App'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              VolumeWatcher(
                onVolumeChangeListener: (double volume) {
                  setState(() {
                    currentVolume = volume;
                  });
                },
              ),
              Text("System Version=$_platformVersion"),
              Text("Maximum Volume=$maxVolume"),
              Text("Initial Volume=$initVolume"),
              Text("Current Volume=$currentVolume"),
              ElevatedButton(
                onPressed: () {
                  VolumeWatcher.setVolume(maxVolume * 0.5);
                },
                child: Text("Set the volume to: ${maxVolume * 0.5}"),
              ),
              ElevatedButton(
                onPressed: () {
                  VolumeWatcher.setVolume(maxVolume * 0.0);
                },
                child: Text("Set the volume to: ${maxVolume * 0.0}"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
```