import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kangaroom/generated/l10n.dart';
import 'package:kangaroom/home/homescreen.dart';
import 'package:kangaroom/theme.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart'; // Yatay mod kontrolü için

class Etkinlik extends StatefulWidget {
  final ogrenciId;
  final List<ImageModel> images; // Receive images from HomeScreen

  Etkinlik({required this.images, required this.ogrenciId});
  @override
  _EtkinlikState createState() => _EtkinlikState();
}

class _EtkinlikState extends State<Etkinlik> {
  List<ActivityModel> activities = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    //  fetchActivities(widget.ogrenciId);
  }

  Future<void> fetchActivities(int ogrenciId) async {
    try {
      final response = await http.get(Uri.parse(
          'http://37.148.210.227:8001/api/KangaroomDers/ders/$ogrenciId'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          activities =
              data.map((item) => ActivityModel.fromJson(item)).toList();
          isLoading = false;
        });
      } else {
        print('Failed to load activities');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching activities: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ekranGenisligi = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: IconThemeData(
          color: Colors.white, // Geri dönüş okunun rengini beyaz yapar
        ),
        title: Text(
          S.of(context).dersresimleri,
          style: titleTextStyle,
        ),
        centerTitle: true, // Başlığı ortalar
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitFadingCircle(
                    color: Theme.of(context).primaryColor,
                    size: 50.0,
                  ),
                  SizedBox(height: 10),
                  Text(
                    S.of(context).verilerYukleniyor,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: widget.images.length,
              itemBuilder: (context, index) {
                final image = widget.images[index];
                bool isVideo =
                    image.resimVerisi.toLowerCase().endsWith('.mp4') ||
                        image.resimVerisi.toLowerCase().endsWith('.mov') ||
                        image.resimVerisi.toLowerCase().endsWith('.avi') ||
                        image.resimVerisi.toLowerCase().endsWith('.mkv') ||
                        image.resimVerisi.toLowerCase().endsWith('.wmv') ||
                        image.resimVerisi.toLowerCase().endsWith('.flv') ||
                        image.resimVerisi.toLowerCase().endsWith('.webm');

                return Card(
                  margin: EdgeInsets.all(6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      isVideo
                          ? GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullScreenVideoPage(
                                        url: image.resimVerisi),
                                  ),
                                );
                              },
                              child: SizedBox(
                                  height: ekranGenisligi / 1.5,
                                  width: ekranGenisligi,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      VideoPlayerWidget(url: image.resimVerisi),
                                      Icon(
                                        Icons.play_circle_filled,
                                        color: Colors.white.withOpacity(0.7),
                                        size: 64.0,
                                      ),
                                    ],
                                  )))
                          : GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullScreenImage(
                                        imageUrl: image.resimVerisi),
                                  ),
                                );
                              },
                              child: Image.network(
                                image.resimVerisi,
                                fit: BoxFit.fill,
                                height: ekranGenisligi / 1.5,
                                width: ekranGenisligi,
                              ),
                            )
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class ActivityModel {
  final int dersId;
  final String ad;
  final num puan;

  ActivityModel({required this.dersId, required this.ad, required this.puan});

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      dersId: json['dersId'],
      ad: json['ad'],
      puan: json['puan'] is int ? json['puan'].toDouble() : json['puan'],
    );
  }
}

class FullScreenVideoPage extends StatefulWidget {
  final String url;
  FullScreenVideoPage({required this.url});

  @override
  _FullScreenVideoPageState createState() => _FullScreenVideoPageState();
}

class _FullScreenVideoPageState extends State<FullScreenVideoPage> {
  late VideoPlayerController _controller;
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  // Yatay ve dikey mod arasında geçiş
  void _toggleFullScreen() {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    } else {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
  }

  // Oynat/Durdur düğmesi
  void _playPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  // Video süresi göstermek için
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _controller.value.isInitialized
          ? Stack(
              children: [
                Center(
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                ),
                Positioned(
                  top: 40.0,
                  right: 20.0,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.white, size: 30),
                    onPressed: () {
                      // Sayfayı kapat ve cihazı dikey moda geri döndür
                      SystemChrome.setPreferredOrientations(
                          [DeviceOrientation.portraitUp]);
                      Navigator.pop(context);
                    },
                  ),
                ),
                Positioned(
                  top: 40.0,
                  left: 20.0,
                  child: IconButton(
                    icon: Icon(Icons.download, color: Colors.white, size: 30),
                    onPressed: () {
                      _saveVideo(widget.url);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('dosya indirildi'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                  ),
                ),
                // Play/Pause, Süre ve Yatay/Dikey Mod Düğmeleri
                Positioned(
                  bottom: 10.0,
                  left: 20.0,
                  right: 20.0,
                  child: Column(
                    children: [
                      VideoProgressIndicator(
                        _controller,
                        allowScrubbing: true,
                        colors: VideoProgressColors(
                          playedColor: Colors.red,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(
                              _isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                            ),
                            onPressed: _playPause,
                          ),
                          Text(
                            _formatDuration(_controller.value.duration),
                            style: TextStyle(color: Colors.white),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.fullscreen,
                              color: Colors.white,
                            ),
                            onPressed: _toggleFullScreen,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String url;

  VideoPlayerWidget({required this.url});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        setState(
            () {}); // Ensure the first frame is shown after the video is initialized
      });
    _controller.setLooping(true);
    // _controller.play(); // Auto play the video
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : Center(child: CircularProgressIndicator());
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  FullScreenImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Image Viewer'),
        actions: [
          IconButton(
            icon: Icon(Icons.download, color: Colors.white),
            onPressed: () {
              _saveImage(imageUrl);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('dosya indirildi'),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Center(
        child: PhotoView(
          imageProvider: NetworkImage(imageUrl),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 2,
        ),
      ),
    );
  }
}

_saveImage(String url) async {
  var response =
      await Dio().get(url, options: Options(responseType: ResponseType.bytes));
  String picturesPath = getFileNameFromUrl(url);
  debugPrint(picturesPath);
  final result = await SaverGallery.saveImage(
    Uint8List.fromList(response.data),
    quality: 60,
    fileName: picturesPath,
    androidRelativePath: "Pictures/kangaroom/",
    skipIfExists: false,
  );
  print(result.toString());
}

_saveVideo(String url) async {
  var appDocDir = await getTemporaryDirectory();
  String fileName = getFileNameFromUrl(url);
  String savePath = appDocDir.path + fileName;
  await Dio().download(url, savePath);
  final result = await SaverGallery.saveFile(
      filePath: savePath,
      fileName: fileName,
      androidRelativePath: "Movies/kangaroom/",
      skipIfExists: true);
  print(result);
}

String getFileNameFromUrl(String url) {
  return url.split('/').last;
}
