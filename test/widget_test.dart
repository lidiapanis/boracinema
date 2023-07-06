import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teste/routes/route_paths.dart';
import 'package:teste/screens/sign_in_screen.dart';

void main() {
  testWidgets('Test Sign In Screen', (WidgetTester tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    await tester.pumpWidget(MaterialApp(
      home: SignInScreen(),
      routes: {
        RoutePaths.MOVIELIST: (_) => Scaffold(),
        RoutePaths.REGISTER: (_) => Scaffold(),
      },
    ));
    expect(find.byType(TextField), findsNWidgets(2));
    await tester.enterText(find.byType(TextField).first, 'teste@teste.com');
    await tester.enterText(find.byType(TextField).last, '123456');
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pump(Duration(seconds: 2));
    expect(find.text('Usuário Autenticado'), findsOneWidget);
    expect(find.text('teste@teste.com'), findsNothing);
    expect(find.text('123456'), findsNothing);
    expect(find.byType(Scaffold), findsOneWidget);
    await tester.tap(find.text('Cadastre-se'));
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });
}
