import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/models/vehicle.dart';
import 'package:frontend/widgets/delete_confirmation_dialog.dart';

void main() {
  const testVehicle = Vehicle(
    id: 1,
    vehicleNumber: 'DHAKA-METRO-GA-11-2233',
    brand: 'Toyota',
    model: 'Hiace',
    manufactureYear: 2019,
    vehicleType: 'VAN',
    color: 'White',
  );

  testWidgets('DeleteConfirmationDialog shows vehicle info and cancels on Cancel tap', (tester) async {
    bool? dialogResult;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  dialogResult = await DeleteConfirmationDialog.show(context, testVehicle);
                },
                child: const Text('Open Dialog'),
              );
            },
          ),
        ),
      ),
    );

    // Open dialog
    await tester.tap(find.text('Open Dialog'));
    await tester.pumpAndSettle();

    expect(find.text('Delete Vehicle?'), findsOneWidget);
    expect(find.text('DHAKA-METRO-GA-11-2233'), findsOneWidget);
    expect(find.text('Toyota Hiace (2019)'), findsOneWidget);

    // Cancel
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(dialogResult, isFalse);
    expect(find.text('Delete Vehicle?'), findsNothing);
  });

  testWidgets('DeleteConfirmationDialog returns true on Delete Vehicle tap', (tester) async {
    bool? dialogResult;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  dialogResult = await DeleteConfirmationDialog.show(context, testVehicle);
                },
                child: const Text('Open Dialog'),
              );
            },
          ),
        ),
      ),
    );

    // Open dialog
    await tester.tap(find.text('Open Dialog'));
    await tester.pumpAndSettle();

    // Confirm Delete
    await tester.tap(find.text('Delete Vehicle'));
    await tester.pumpAndSettle();

    expect(dialogResult, isTrue);
    expect(find.text('Delete Vehicle?'), findsNothing);
  });
}

