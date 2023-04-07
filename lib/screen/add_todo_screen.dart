import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_unlinked/data_helper/todo_class_helper.dart';
import 'package:todo_unlinked/firebase/firestore_helper.dart';
import '../custom_widgets.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});
  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  var _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final textFormFieldProv = Provider.of<CustomTextFieldProvider>(context);
    DateTime now = new DateTime.now();

    return DismissKeyboard(
      context,
      child: Scaffold(
        appBar: CustomAppBar(
          title: Text("Buat Todo Mu"),
          actions: [
            IconButton(
              onPressed: () {
                textFormFieldProv.title = "";
                textFormFieldProv.description = "";
                Navigator.pop(context);
              },
              icon: Icon(Icons.close),
            )
          ],
          height: 175,
          light: true,
          bgImage:
              "https://images.unsplash.com/photo-1662027008658-b615840c7deb?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MzJ8fHRvZG98ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60",
        ),
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 1.5,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Title
                    CustomTextField(
                      label: "Title",
                    ),
                    // Description
                    CustomTextField(
                      label: "Description",
                    ),
                    SizedBox(height: 30),
                    // Tambahkan Button
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await TodosHelper.addData(
                                todo: TodoClass(
                              title: textFormFieldProv.title,
                              description: textFormFieldProv.description,
                              dateTime: now,
                            ));
                            textFormFieldProv.title = "";
                            textFormFieldProv.description = "";
                            Navigator.pushReplacementNamed(
                                context, "home_route");
                          }
                        },
                        child: Text("Tambahkan"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  final String label;
  bool? secure;
  bool? last;
  int? line;
  CustomTextField({
    super.key,
    required this.label,
    this.secure,
    this.last,
    this.line,
  });
  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var prov = Provider.of<CustomTextFieldProvider>(context);
    return TextFormField(
      minLines: 1,
      maxLines: widget.line ?? 5,
      obscureText: widget.secure != null
          ? widget.secure!
              ? true
              : false
          : false,
      controller: _controller,
      validator: (value) {
        if (value!.isEmpty) {
          return "Tidak Boleh Kosong";
        }
        return null;
      },
      onChanged: (value) async {
        switch (widget.label) {
          case "Title":
            prov.title = await value;
            break;
          case "Description":
            prov.description = await value;
            break;
        }
      },
      textInputAction: widget.last != null
          ? widget.last!
              ? TextInputAction.done
              : TextInputAction.next
          : null,
      decoration: InputDecoration(
        labelText: widget.label,
      ),
    );
  }
}

class CustomTextFieldProvider extends ChangeNotifier {
  bool _obscureText = true;
  bool get obscureText => this._obscureText;
  set setObscureText(bool obscureText) {
    this._obscureText = obscureText;
    notifyListeners();
  }

  String _title = "";
  String get title => this._title;
  set title(String value) {
    this._title = value;
    notifyListeners();
  }

  String _description = "";
  String get description => this._description;
  set description(String value) {
    this._description = value;
    notifyListeners();
  }
}
