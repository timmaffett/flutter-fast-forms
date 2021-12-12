import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  testWidgets('renders FastDropdown', (WidgetTester tester) async {
    await tester.pumpWidget(buildMaterialTestApp(
      const FastDropdown<String>(id: 'dropdown', items: []),
    ));

    expect(find.byType(typeOf<FastDropdown<String>>()), findsOneWidget);
    expect(
        find.byType(typeOf<DropdownButtonFormField<String>>()), findsOneWidget);
    expect(find.byType(typeOf<DropdownButton<String>>()), findsOneWidget);
  });

  testWidgets('updates FastDropdown', (WidgetTester tester) async {
    const testIndex = 2;
    const itemsLength = 3;
    final items = List.generate(itemsLength, (int index) => 'item $index');

    await tester.pumpWidget(buildMaterialTestApp(
      FastDropdown<String>(id: 'dropdown', items: items),
    ));

    final state = tester.state(find.byType(typeOf<FastDropdown<String>>()))
        as FastDropdownState<String>;

    final itemsFinder = find.byType(typeOf<DropdownMenuItem<String>>());

    expect(itemsFinder, findsNWidgets(itemsLength));

    await tester.tap(find.byType(typeOf<DropdownButton<String>>()));
    await tester.pumpAndSettle();

    expect(itemsFinder, findsNWidgets(itemsLength * 2));

    await tester.tap(itemsFinder.at(itemsLength + testIndex),
        warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(state.value, items[testIndex]);
  });

  testWidgets('validates FastDropdown', (WidgetTester tester) async {
    const invalidItem = 'invalid item';
    const errorText = 'Do not touch this';

    await tester.pumpWidget(buildMaterialTestApp(
      FastDropdown<String>(
        id: 'dropdown',
        items: const ['item', invalidItem],
        validator: (value) => value == invalidItem ? errorText : null,
      ),
    ));

    final state =
        tester.state(find.byType(typeOf<DropdownButtonFormField<String>>()))
            as FormFieldState<String>;

    final errorTextFinder = find.text(errorText);
    expect(errorTextFinder, findsNothing);

    state.didChange(invalidItem);
    await tester.pumpAndSettle();

    expect(errorTextFinder, findsOneWidget);
  });
}
