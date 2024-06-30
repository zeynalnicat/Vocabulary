import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class WordContainer extends StatefulWidget {
  final String word;
  final String text;
  final String partOf;
  final List<String> definition;
  final String audio;

  const WordContainer({
    Key? key,
    required this.word,
    required this.text,
    required this.partOf,
    required this.definition,
    required this.audio,
  }) : super(key: key);

  @override
  _WordContainerState createState() => _WordContainerState();
}

class _WordContainerState extends State<WordContainer> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playAudio(String url) async {
    if (_isPlaying) {
      await _audioPlayer.stop();
      setState(() {
        _isPlaying = false;
      });
    }

    int result = await _audioPlayer.play(url);
    if (result == 1) {
      print(result);
      setState(() {
        _isPlaying = true;
      });
    }else{
      print(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    widget.word,
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.lightBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    widget.text,
                    style: TextStyle(color: Colors.red),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    icon: Icon(Icons.headphones),
                    onPressed: () => _playAudio(widget.audio),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                widget.partOf,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.definition.length,
                itemBuilder: (context, index) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (index + 1).toString(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.definition[index],
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
