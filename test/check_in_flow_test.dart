import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sanative_vibez/screens/check_in_flow.dart';

const supportLabels = [
  'A quiet moment',
  'Clearer thoughts',
  'More energy',
  'Letting something go',
  'Better rest',
  'I am not sure',
];

const feelings = ['Grounded', 'Full', 'Weary'];
const intentionLabel = 'Slow down';

/// Router mirroring lib/nav.dart's check-in route, isolated for widget testing.
/// The real Home screen is swapped for a stub because it calls
/// GoogleFonts.inter() directly (network-fetched fonts), which is irrelevant
/// to check-in routing correctness and unstable in a test sandbox — the
/// Home shortcut path is exercised here via router.push with the same query
/// parameter Home's cards use, not by tapping through the real Home UI.
GoRouter _buildRouter() {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const Scaffold(body: SizedBox())),
      GoRoute(
        path: '/check-in',
        builder: (context, state) {
          final feeling = state.uri.queryParameters['feeling'];
          return CheckInFlowScreen(initialFeeling: feeling);
        },
      ),
    ],
  );
}

/// Uses plain Material 3 defaults rather than the app's theme, since
/// lib/theme.dart pulls in GoogleFonts (network-fetched fonts), which is
/// irrelevant to check-in routing correctness and unstable in a test sandbox.
Widget _wrap(GoRouter router) {
  return MaterialApp.router(
    theme: ThemeData(useMaterial3: true),
    routerConfig: router,
  );
}

/// Runs the full 3-step fresh check-in flow (feeling -> support -> intention)
/// starting from the Home screen, and returns the result-screen title text.
Future<String> _runFreshCheckIn(
  WidgetTester tester,
  GoRouter router,
  String feeling,
  String supportLabel,
) async {
  await tester.binding.setSurfaceSize(const Size(414, 2200));
  await tester.pumpWidget(_wrap(router));
  await tester.pumpAndSettle();

  // Enter via the full check-in flow (fresh path), not the Home shortcut cards.
  router.push('/check-in');
  await tester.pumpAndSettle();

  await tester.tap(find.text(feeling));
  await tester.pumpAndSettle();

  await tester.tap(find.text(supportLabel));
  await tester.pumpAndSettle();

  await tester.tap(find.text(intentionLabel));
  await tester.pumpAndSettle();

  return _currentResultTitle(tester);
}

/// Runs the pre-filled shortcut path (feeling already selected via query param).
Future<String> _runShortcutCheckIn(
  WidgetTester tester,
  GoRouter router,
  String feeling,
  String supportLabel,
) async {
  await tester.binding.setSurfaceSize(const Size(414, 2200));
  await tester.pumpWidget(_wrap(router));
  await tester.pumpAndSettle();

  router.push(Uri(path: '/check-in', queryParameters: {'feeling': feeling}).toString());
  await tester.pumpAndSettle();

  await tester.tap(find.text(supportLabel));
  await tester.pumpAndSettle();

  await tester.tap(find.text(intentionLabel));
  await tester.pumpAndSettle();

  return _currentResultTitle(tester);
}

String _currentResultTitle(WidgetTester tester) {
  final titleFinder = find.byWidgetPredicate(
    (w) => w is Text && w.style?.fontStyle != FontStyle.italic && (w.data?.isNotEmpty ?? false),
  );
  // The result title is the first large heading rendered under the AppBar;
  // reflection/action section labels ("Reflection", "Suggested Action") are
  // fixed strings we can exclude to isolate the practice title deterministically.
  final candidates = tester
      .widgetList<Text>(find.byType(Text))
      .map((t) => t.data)
      .whereType<String>()
      .toList();
  // The practice/result title is rendered first, immediately after the back
  // button, before "Reflection" and "Suggested Action" section labels.
  final reflectionIndex = candidates.indexOf('Reflection');
  expect(reflectionIndex, greaterThan(0), reason: 'Result screen did not render expected sections');
  return candidates[reflectionIndex - 1];
}

Future<void> _tapShowAnother(WidgetTester tester) async {
  // The result screen is a SingleChildScrollView; scroll the button into
  // view first or the tap misses it once content grows past the viewport.
  await tester.ensureVisible(find.text('Show me another option'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Show me another option'));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Check-in routing — both entry paths, every combination', () {
    for (final feeling in feelings) {
      for (final support in supportLabels) {
        testWidgets(
          'Fresh path: $feeling + "$support" resolves to a stable result',
          (tester) async {
            final router = _buildRouter();
            final title = await _runFreshCheckIn(tester, router, feeling, support);
            expect(title, isNotEmpty);
          },
        );

        testWidgets(
          'Shortcut path: $feeling + "$support" resolves to a stable result',
          (tester) async {
            final router = _buildRouter();
            final title = await _runShortcutCheckIn(tester, router, feeling, support);
            expect(title, isNotEmpty);
          },
        );

        testWidgets(
          'Both entry paths agree for $feeling + "$support"',
          (tester) async {
            final freshRouter = _buildRouter();
            final freshTitle = await _runFreshCheckIn(tester, freshRouter, feeling, support);

            final shortcutRouter = _buildRouter();
            final shortcutTitle = await _runShortcutCheckIn(tester, shortcutRouter, feeling, support);

            expect(
              freshTitle,
              equals(shortcutTitle),
              reason: 'Fresh and shortcut paths must route the same (feeling, support) pair '
                  'to the identical result — this is exactly the bug that was fixed.',
            );
          },
        );
      }
    }
  });

  group('"Show me another option" — no repeats within a category', () {
    for (final feeling in feelings) {
      testWidgets(
        '$feeling: cycling through all options never repeats until exhausted',
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(414, 2200));
          final router = _buildRouter();
          await tester.pumpWidget(_wrap(router));
          await tester.pumpAndSettle();

          router.push(Uri(path: '/check-in', queryParameters: {'feeling': feeling}).toString());
          await tester.pumpAndSettle();
          await tester.tap(find.text(supportLabels.first));
          await tester.pumpAndSettle();
          await tester.tap(find.text(intentionLabel));
          await tester.pumpAndSettle();

          final seenTitles = <String>{};
          String title = _currentResultTitle(tester);
          seenTitles.add(title);

          // Keep tapping "Show me another option" until it's no longer offered
          // (replaced by "Start a new check-in"), collecting every title shown.
          var guard = 0;
          while (find.text('Show me another option').evaluate().isNotEmpty && guard < 20) {
            await _tapShowAnother(tester);
            title = _currentResultTitle(tester);
            expect(
              seenTitles.contains(title),
              isFalse,
              reason: 'Practice "$title" repeated before all options in the '
                  '$feeling library were exhausted — this is the repeat bug.',
            );
            seenTitles.add(title);
            guard++;
          }

          // Once exhausted, the flow must offer a way to restart rather than
          // silently looping or dead-ending.
          expect(find.text('Start a new check-in'), findsOneWidget);
        },
      );
    }
  });
}
