import 'package:crypto_tosentai/core/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('GradientButton shows label and fires onPressed', (tester) async {
    var taps = 0;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: GradientButton(
          label: 'Sign In',
          onPressed: () => taps++,
        ),
      ),
    ));

    expect(find.text('Sign In'), findsOneWidget);
    await tester.tap(find.byType(GradientButton));
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('GradientButton renders spinner when loading', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: GradientButton(
          label: 'Loading',
          onPressed: () {},
          loading: true,
        ),
      ),
    ));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Loading'), findsNothing);
  });
}
