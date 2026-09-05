part of '../portfolio_app.dart';

/// Product modules, not separate apps or claims of sole product ownership.
class _GrozziieModuleDetails extends StatelessWidget {
  const _GrozziieModuleDetails();

  @override
  Widget build(BuildContext context) {
    const modules = [
      (
        icon: Icons.mic_rounded,
        title: 'Voice-enabled chatbot',
        summary: 'A multilingual conversation experience inside Grozziie.',
        points: [
          (
            'Speak, transcribe, respond',
            'Integrated speech-to-text and text-to-speech with hold-to-talk input, live transcription, and automatic spoken responses.',
          ),
          (
            'Coordinated audio & controls',
            'Coordinated recording and playback so replies do not interfere with microphone input. Added permissions, voice/keyboard switching, and saved language and audio preferences.',
          ),
        ],
        tags: ['Flutter', 'speech_to_text', 'flutter_tts'],
      ),
      (
        icon: Icons.sync_rounded,
        title: 'Real-time FaceAttendance',
        summary: 'Connected attendance workflows inside Grozziie.',
        points: [
          (
            'People & devices in sync',
            'Implemented STOMP over WebSockets for admin and employee notifications, employee profile updates, and attendance-device synchronization status.',
          ),
          (
            'Connection lifecycle & unread messages',
            'Added role-specific subscriptions, automatic reconnection, message acknowledgments, and subscription cleanup. Stored notifications locally with unread-count tracking.',
          ),
        ],
        tags: ['Flutter', 'STOMP', 'WebSockets', 'Local persistence'],
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Inside Grozziie: modules I built',
          style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 10),
        const Text(
          'Two parts of the same production app, with different engineering challenges.',
          style: TextStyle(color: _muted, fontSize: 16, height: 1.5),
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 820 ? 2 : 1;
            final width = (constraints.maxWidth - 18 * (columns - 1)) / columns;
            return Wrap(
              spacing: 18,
              runSpacing: 18,
              children: [
                for (final module in modules)
                  Container(
                    width: width,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: _panel,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: _mint.withValues(alpha: 0.25)),
                      boxShadow: _cardShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(module.icon, color: _mint, size: 30),
                        const SizedBox(height: 18),
                        Text(
                          module.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          module.summary,
                          style: const TextStyle(
                            color: _muted,
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 22),
                          child: Divider(height: 1, color: _line),
                        ),
                        for (final point in module.points)
                          _ThtImpactPoint(
                            icon: Icons.check_rounded,
                            title: point.$1,
                            description: point.$2,
                          ),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final tag in module.tags)
                              _Tag(label: tag, color: _mint),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
