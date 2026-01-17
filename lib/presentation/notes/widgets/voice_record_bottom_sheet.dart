import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:tasklyai/core/theme/color_app.dart';
import 'package:tasklyai/models/area_model.dart';
import 'package:tasklyai/presentation/task_project/provider/ai_provider.dart';

class VoiceRecordBottomSheet extends StatefulWidget {
  const VoiceRecordBottomSheet(this.areaModel, {super.key});

  final AreaModel areaModel;

  @override
  State<VoiceRecordBottomSheet> createState() => _VoiceRecordBottomSheetState();
}

class _VoiceRecordBottomSheetState extends State<VoiceRecordBottomSheet> {
  final SpeechToText _speech = SpeechToText();
  bool _isRecording = false;
  String _text = 'Xây dưng ứng dụng quản lý công việc';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    await _speech.initialize();
  }

  Future<void> _startRecording(BuildContext context) async {
    setState(() => _isRecording = true);

    await _speech.listen(
      localeId: 'vi_VN',
      onResult: (result) {
        setState(() {
          _text = result.recognizedWords;
        });
      },
    );
  }

  Future<void> _stopRecording() async {
    await _speech.stop();
    setState(() => _isRecording = false);
  }

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Drag handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
            ),

            /// Mic animation
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isRecording ? primaryColor : Colors.grey.shade300,
              ),
              child: IconButton(
                iconSize: 40,
                icon: Icon(
                  _isRecording ? Icons.stop : Icons.mic,
                  color: Colors.white,
                ),
                onPressed: () {
                  _isRecording ? _stopRecording() : _startRecording(context);
                },
              ),
            ),

            const SizedBox(height: 16),

            Text(
              _isRecording ? 'Listening...' : 'Tap to start recording',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 16),

            /// Transcribed text
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _text.isEmpty ? 'Your text will appear here' : _text,
                style: const TextStyle(fontSize: 14),
              ),
            ),

            const SizedBox(height: 24),

            /// Use text
            Consumer<AiProvider>(
              builder: (context, value, child) {
                return SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _text.isEmpty || value.aiIsLoading
                        ? null
                        : () {
                            context.read<AiProvider>().analyzeNote(
                              context,
                              widget.areaModel,
                              _text,
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Row(
                      spacing: 8,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Use this text',
                          style: TextStyle(fontSize: 15),
                        ),
                        if (value.aiIsLoading)
                          Center(
                            child: SizedBox(
                              width: 15,
                              height: 15,
                              child: CircularProgressIndicator(
                                color: primaryColor,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
