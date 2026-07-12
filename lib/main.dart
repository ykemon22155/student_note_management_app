import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/notes_dashboard.dart';

// থিম পরিবর্তনের লজিক গ্লোবালি হ্যান্ডেল করার জন্য একটি ভ্যালু নোটিফায়ার
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const CustomNotesApp());
}

class CustomNotesApp extends StatelessWidget {
  const CustomNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ValueListenableBuilder থিমের স্টেট পরিবর্তন লাইভ ট্র্যাক করবে
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, currentMode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Notes Manager',

          // ১. লাইট থিম কনফিগারেশন (যখন ইউজার লাইট মোড সিলেক্ট করবেন)
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color(0xFFF5F5F5), // হালকা গ্রে ব্যাকগ্রাউন্ড
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black),
              titleTextStyle: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),

          // ২. ডার্ক থিম কনফিগারেশন (আপনার স্ক্রিনশটের মতো প্রিমিয়াম ডার্ক লুক)
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF1F1F1F), // ডার্ক ব্যাকগ্রাউন্ড
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.white),
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),

          // বর্তমান থিম মোড সেট করা (ডিফল্ট ডার্ক থাকবে)
          themeMode: currentMode,
          home: const NotesDashboard(),
        );
      },
    );
  }
}