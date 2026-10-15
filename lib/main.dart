import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'state/emotion_store.dart';
import 'state/gratitude_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaghzRoot());
}

class MaghzRoot extends StatelessWidget {
  const MaghzRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GratitudeStore()..load()),
        ChangeNotifierProvider(create: (_) => EmotionStore()),
        // بقیه‌ی storeها را اگر قبلاً داشتی، با آرگومان درست اضافه کن
        // ChangeNotifierProvider(create: (_) => MapStore(/* args */)..load()),
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
    final grat = context.read<GratitudeStore>();
    final emo = context.read<EmotionStore>();
    emo.onEmotionsCommitted = (ids, dayKey) async {
      await grat.updateDayEmotions(dayKey, ids);
    };
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
