import 'package:flutter/material.dart';
import 'package:jareb/Fenetre/sql_helper.dart';



class Crudmem extends StatefulWidget {
  const Crudmem({Key? key}) : super(key: key);

  @override
  _CrudmemState createState() => _CrudmemState();
}

class _CrudmemState extends State<Crudmem> {
  List<Map<String, dynamic>> _journals = [];

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals(); // Loading the diary when the app starts
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _num1Controller = TextEditingController();
  final TextEditingController _num2Controller = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingJournal =
      _journals.firstWhere((element) => element['id'] == id);
      _titleController.text = existingJournal['nom'];
      _descriptionController.text = existingJournal['prenom'];
      _num1Controller.text = existingJournal['num1'];
      _num2Controller.text = existingJournal['num2'];
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        builder: (_) => Container(
          padding: const EdgeInsets.all(15),
          width: double.infinity,
          height: 300,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(hintText: 'Title'),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _descriptionController,
                  decoration:
                  const InputDecoration(hintText: 'Description'),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _num1Controller,
                  decoration:
                  const InputDecoration(hintText: 'Numéro Tel 1'),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _num2Controller,
                  decoration:
                  const InputDecoration(hintText: 'Numéro Tel 2'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Save new journal
                    if (id == null) {
                      await _addItem();
                    }

                    if (id != null) {
                      await _updateItem(id);
                    }

                    // Clear the text fields
                    _titleController.text = '';
                    _descriptionController.text = '';
                    _num1Controller.text = '';
                    _num2Controller.text = '';

                    // Close the bottom sheet
                    Navigator.of(context).pop();
                  },
                  child: Text(id == null ? 'Create New' : 'Update'),
                )
              ],
            ),
          ),
        ));
  }

// Insert a new journal to the database
  Future<void> _addItem() async {
    await SQLHelper.createMembre(
        _titleController.text, _descriptionController.text,_num1Controller.text,
        _num2Controller.text);
    _refreshJournals();
  }

  // Update an existing journal
  Future<void> _updateItem(int id) async {
    await SQLHelper.updateMembre(
        id, _titleController.text, _descriptionController.text,_num1Controller.text,
        _num2Controller.text);
    _refreshJournals();
  }

  // Delete an item
  void _deleteItem(int id) async {
    await SQLHelper.deleteMembre(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a journal!'),
    ));
    _refreshJournals();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: _journals.length,
        itemBuilder: (context, index) => Card(
          color: Colors.orange[200],
          margin: const EdgeInsets.all(15),
          child: ListTile(
              title: Text("nom: "+_journals[index]['title']),
              subtitle: Text(_journals[index]['description']),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showForm(_journals[index]['id']),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () =>
                          _deleteItem(_journals[index]['id']),
                    )],

                ),
              )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }
}


