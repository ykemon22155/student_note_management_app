import 'package:flutter/material.dart';
// আপনার কাস্টম ফাইলগুলো রিলেটিভ পাথের মাধ্যমে ইম্পোর্ট করা হলো
import '../managers/note_blueprint.dart';
import '../managers/firestore_manager.dart';

class NoteEditor extends StatefulWidget {
  final NoteBlueprint? targetNote;

  const NoteEditor({super.key, this.targetNote});

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  final _formValidationKey = GlobalKey<FormState>();
  final FirestoreManager _repo = FirestoreManager();

  late TextEditingController _titleController;
  late TextEditingController _descController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.targetNote?.title ?? '');
    _descController = TextEditingController(text: widget.targetNote?.description ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _processSave() async {
    if (!_formValidationKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    final validatedNote = NoteBlueprint(
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
    );

    try {
      if (widget.targetNote == null) {
        await _repo.addNote(validatedNote); // Create
      } else {
        await _repo.updateNote(widget.targetNote!.id!, validatedNote); // Update
      }

      if (mounted) Navigator.pop(context);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Action failed: $error')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // বর্তমান থিম মোড (Dark নাকি Light) তা চেক করার লজিক
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // থিম অনুযায়ী ব্যাকগ্রাউন্ড কালার পরিবর্তন হবে (ডার্ক হলে গাঢ় কালো, লাইট হলে হালকা সাদা)
      backgroundColor: isDarkMode ? const Color(0xFF1F1F1F) : const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: isDarkMode ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check, color: isDarkMode ? Colors.white : Colors.black, size: 28),
            onPressed: _processSave,
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: _isSaving
          ? Center(child: CircularProgressIndicator(color: isDarkMode ? Colors.white : Colors.black))
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
        child: Form(
          key: _formValidationKey,
          child: Column(
            children: [
              // থিম অনুযায়ী টাইটেল টেক্সট ও হিন্ট কালার চেঞ্জ হবে
              TextFormField(
                controller: _titleController,
                style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 26,
                    fontWeight: FontWeight.bold
                ),
                decoration: InputDecoration(
                  hintText: 'Title',
                  hintStyle: TextStyle(color: isDarkMode ? Colors.grey : Colors.grey.shade600, fontSize: 26),
                  border: InputBorder.none,
                ),
                validator: (value) => value == null || value.isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 12),
              // থিম অনুযায়ী বিবরণ (Description) এরিয়া এবং লেখার কালার চেঞ্জ হবে
              Expanded(
                child: TextFormField(
                  controller: _descController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                      fontSize: 18,
                      height: 1.4
                  ),
                  decoration: InputDecoration(
                    hintText: 'Start typing...',
                    hintStyle: TextStyle(color: isDarkMode ? Colors.grey : Colors.grey.shade600, fontSize: 18),
                    border: InputBorder.none,
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Description is required' : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}