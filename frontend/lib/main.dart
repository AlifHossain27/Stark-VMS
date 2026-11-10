import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:provider/provider.dart';
import 'providers/vehicle_provider.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

void main() {
  usePathUrlStrategy();
  runApp(const StarkVmsApp());
}

class StarkVmsApp extends StatelessWidget {
  const StarkVmsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VehicleProvider()),
      ],
      child: MaterialApp.router(
        title: 'Stark Group VMS',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
