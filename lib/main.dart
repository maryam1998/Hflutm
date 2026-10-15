import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';

// ── خدمات ──
import 'services/storage.dart';

// ── state ها ──
import 'state/theme_store.dart';
import 'state/emotion_store.dart';
import 'state/gratitude_store.dart';
import 'state/map_store.dart';
import 'state/motivation_store.dart';
import 'state/angels_store.dart';
import 'state/background_store.dart';
import 'state/abundance_store.dart';
import 'state/beliefs_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaghzRoot());
}

class MaghzRoot extends StatelessWidget {
  const MaghzRoot({super.key});

  @override
  Widget build(BuildContext context) {
    // ⚠️ اگر StorageService آرگومان می‌خواست، اینجا عوض کن
    final storage = StorageService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeStore()..load()),
        ChangeNotifierProvider(create: (_) => GratitudeStore()..load()),
        ChangeNotifierProvider(create: (_) => EmotionStore()),
        ChangeNotifierProvider(create: (_) => MotivationStore()..load()),
        ChangeNotifierProvider(create: (_) => AngelsStore()..load()),
        ChangeNotifierProvider(create: (_) => BackgroundStore()..load()),
        ChangeNotifierProvider(create: (_) => MapStore(storage)..load()),
        ChangeNotifierProvider(create: (_) => AbundanceStore()..load()),
        ChangeNotifierProvider(create: (_) => BeliefsStore()..load()),
      ],
      child: const _WireUp(child: MaghzApp()),
    );
  }
}

class _WireUp extends StatefulWidget {
  final Widget child;
  const _WireUp({required this.child});

  @override
  State<_WireUp> createState() => _WireUpState();
}

class _WireUpState extends State<_WireUp> {
  bool _wired = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_wired) return;
    _wired = true;
    try {
      final grat = context.read<GratitudeStore>();
      final emo = context.read<EmotionStore>();
      emo.onEmotionsCommitted = (ids, dayKey) async {
        await grat.updateDayEmotions(dayKey, ids);
      };
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
