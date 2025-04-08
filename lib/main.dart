import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'screens/home_screen.dart';
import 'providers/location_provider.dart';
import 'services/location_service.dart';

// Register headless task handler
@pragma('vm:entry-point')
void headlessTaskCallback(bg.HeadlessEvent headlessEvent) async {
  print('⚙️ [Headless Task] - ${headlessEvent.name}');
  await LocationService.headlessTask(headlessEvent);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Register the headless task BEFORE any configuration
  bg.BackgroundGeolocation.registerHeadlessTask(headlessTaskCallback);
  
  // Disable debug mode - this is critical for sound prevention
  // but keep the critical background tracking settings
  await bg.BackgroundGeolocation.setConfig(bg.Config(
    debug: false,
    logLevel: bg.Config.LOG_LEVEL_OFF,
    stopOnTerminate: false,
    startOnBoot: true,
    enableHeadless: true,
    // Critical background mode settings
    heartbeatInterval: 60,
    preventSuspend: true,
    foregroundService: true
  ));
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LocationProvider(),
      child: MaterialApp(
        title: 'Location Tracker',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
