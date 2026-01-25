import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:tasklyai/core/theme/color_app.dart';

class VoiceToTextBottomSheet extends StatefulWidget {
  const VoiceToTextBottomSheet({super.key});

  @override
  State<VoiceToTextBottomSheet> createState() =>
      _VoiceToTextBottomSheetState();
}

class _VoiceToTextBottomSheetState extends State<VoiceToTextBottomSheet> {
  final SpeechToText _speech = SpeechToText();
  bool _isReady = false;
  bool _isRecording = false;
  String _text = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    final ready = await _speech.initialize();
    if (!mounted) return;
    setState(() => _isReady = ready);
  }

  Future<void> _startRecording() async {
    if (!_isReady) return;
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
    if (!mounted) return;
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
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(30),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.mic, color: primaryColor),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Voice to Text',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _isRecording ? _stopRecording : _startRecording,
              child: Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isRecording ? primaryColor : Colors.grey.shade200,
                  boxShadow: _isRecording
                      ? [
                          BoxShadow(
                            color: primaryColor.withAlpha(90),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ]
                      : [],
                ),
                child: Icon(
                  _isRecording ? Icons.stop : Icons.mic_none,
                  color: _isRecording ? Colors.white : primaryColor,
                  size: 36,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _isRecording ? 'Listening...' : 'Tap to start recording',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F3F7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _text.isEmpty ? 'Your text will appear here' : _text,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _text.trim().isEmpty
                        ? null
                        : () => Navigator.pop(context, _text.trim()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text('Use text'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
