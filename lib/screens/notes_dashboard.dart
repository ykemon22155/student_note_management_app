import 'package:flutter/material.dart';
import '../managers/note_blueprint.dart';
import '../managers/firestore_manager.dart';
import '../main.dart'; // themeNotifier পাওয়ার জন্য মেইন ফাইল ইম্পোর্ট করা হলো
import 'note_editor.dart';

class NotesDashboard extends StatefulWidget {
  const NotesDashboard({super.key});

  @override
  State<NotesDashboard> createState() => _NotesDashboardState();
}

class _NotesDashboardState extends State<NotesDashboard> {
  final FirestoreManager _repo = FirestoreManager();

  // আপনার স্ক্রিনশটের মতো আকর্ষণীয় পেস্টেল কালার লিস্ট
  final List<Color> cardColors = [
    const Color(0xFFFFAB91), // সফট অরেঞ্জ
    const Color(0xFFFFCC80), // সফট হলুদ
    const Color(0xFFE6EE9C), // সফট লাইট গ্রিন
    const Color(0xFF80DEEA), // সফট ব্লু
    const Color(0xFFCF93D9), // সফট পার্পল
    const Color(0xFFF48FB1), // সফট পিঙ্ক
  ];

  @override
  Widget build(BuildContext context) {
    // বর্তমান থিম ডার্ক নাকি লাইট তা চেক করার জন্যbool
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          // থিম টগল বাটন যা ইউজার ক্লিক করে মোড চেঞ্জ করবেন
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              size: 26,
            ),
            onPressed: () {
              // এক ক্লিকে ডার্ক থেকে লাইট অথবা লাইট থেকে ডার্ক হবে
              themeNotifier.value = isDarkMode ? ThemeMode.light : ThemeMode.dark;
            },
          ),
          IconButton(
            icon: const Icon(Icons.search, size: 26),
            onPressed: () {},
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: StreamBuilder<List<NoteBlueprint>>(
        stream: _repo.getNotesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Something went wrong!', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: isDarkMode ? Colors.white : Colors.black));
          }

          final allNotes = snapshot.data ?? [];

          if (allNotes.isEmpty) {
            return const Center(
              child: Text('No notes available. Create one!', style: TextStyle(color: Colors.grey, fontSize: 16)),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: allNotes.length,
            itemBuilder: (context, index) {
              final currentNote = allNotes[index];
              final selectColor = cardColors[index % cardColors.length];

              return InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => NoteEditor(targetNote: currentNote)),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: selectColor,
                    borderRadius: BorderRadius.circular(16),
                    // লাইট মোডে হালকা শ্যাডো দিলে কার্ডগুলো সুন্দর ভেসে উঠবে
                    boxShadow: isDarkMode
                        ? []
                        : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentNote.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Text(
                          currentNote.description,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.7),
                            fontSize: 14,
                            height: 1.3,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.delete_outline, color: Colors.black54, size: 20),
                            onPressed: () async {
                              if (currentNote.id != null) {
                                await _repo.deleteNote(currentNote.id!);
                              }
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        // থিম অনুযায়ী ব্যাকগ্রাউন্ড এবং প্লাস আইকন কালার অটো চেঞ্জ হবে
        backgroundColor: isDarkMode ? const Color(0xFF252525) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NoteEditor()),
        ),
        child: Icon(Icons.add, color: isDarkMode ? Colors.white : Colors.black, size: 28),
      ),
    );
  }
}