import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'state/emotion_store.dart';
import 'state/gratitude_store.dart';
import 'state/map_store.dart';
// بقیه‌ی storeها را اگر داری import کن
import 'state/abundance_store.dart';
import 'state/beliefs_store.dart';
import 'state/motivation_store.dart';
import 'state/theme_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaghzApp());
}

class MaghzApp extends StatelessWidget {
  const MaghzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeStore()..load()),
        ChangeNotifierProvider(create: (_) => MapStore()..load()),
        ChangeNotifierProvider(create: (_) => GratitudeStore()..load()),
        ChangeNotifierProvider(create: (_) => AbundanceStore()..load()),
        ChangeNotifierProvider(create: (_) => BeliefsStore()..load()),
        ChangeNotifierProvider(create: (_) => MotivationStore()..load()),
        ChangeNotifierProvider(create: (_) => EmotionStore()),
      ],
      child: const _WireUp(child: App()),
    );
  }
}

/// اتصال EmotionStore به GratitudeStore برای رنگ‌آمیزی تقویم
class _WireUp extends StatefulWidget {
  final Widget child;
  const _WireUp({required this.child});
  final Widget child;

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
    final grat = context.read<GratitudeStore>();
    final emo = context.read<EmotionStore>();
    emo.onEmotionsCommitted = (ids, dayKey) async {
      await grat.updateDayEmotions(dayKey, ids);
    };
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// این فقط برای اطمینان است؛ فایل app.dart خودت باید MaterialApp را بسازد.
class Localizations extends StatelessWidget {
  final Widget child;
  const Localizations({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return Localizations.override(
      context: context,
      locale: const Locale('fa', 'IR'),
      child: child,
    );
  }
}
