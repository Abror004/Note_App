import 'dart:async';

import 'package:flutter/material.dart';

import 'note_model/note_model.dart';
import 'note_services/note_services.dart';

class Note_Page extends StatefulWidget {
  static const String id = "Note_Page";

  @override
  _Note_PageState createState() => _Note_PageState();
}
class _Note_PageState extends State<Note_Page> {
  bool edit = false;
  bool delete = false;
  bool mode = true;
  late int note_Index;
  List deleteList = [];

  bool isLoading = true;
  List<Note> listofNotes = [];
  TextEditingController textController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  void _createNotes() async {
    String name = nameController.text.toString().trim();
    String text = textController.text.toString().trim();
    listofNotes.add(Note(
        date: DateTime.now().toString(),
        notes: text, name: name));
    listofNotes.sort((a, b) => b.date!.compareTo(a.date!));
    loadList();
  }

  Future<void> loadList() async {
    String notes = Note.encode(listofNotes);
    Prefs.storeNotes(notes);
    listofNotes = Note.decode(await Prefs.loadNotes() as String);
    listofNotes.sort((a, b) => b.date!.compareTo(a.date!));
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(
        const Duration(seconds: 2),
            () =>
            setState(() {
              isLoading = false;
            }));
    loadList();

    setState(() {});
  }

  Scaffold write(index) {
    nameController.text = listofNotes[index].name!;
    textController.text = listofNotes[index].notes!;
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: mode ? Colors.blue.shade900 :  Colors.amber.shade900,
        backgroundColor: Colors.yellow,
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                nameController.clear();
                textController.clear();
                deleteList.clear();
                edit = false;
              });
            },
            child: Text(
              "Cancel", style: TextStyle(color: mode ? Colors.white : Colors.blue.shade900, fontSize: 15),),
          ),
          TextButton(
            onPressed: () {
              listofNotes[index].name = nameController.text;
              listofNotes[index].notes = textController.text;
              listofNotes[index].date = DateTime.now().toString();
              loadList();
              nameController.clear();
              textController.clear();
              deleteList.clear();
              edit = false;
            },
            child: Text(
              "Save", style: TextStyle(color: mode ? Colors.white : Colors.blue.shade900, fontSize: 15),),
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        // color: mode ? Colors.indigo.shade900 : Colors.white,
        color: Colors.yellow,
        padding: EdgeInsets.only(left: 10),
        alignment: Alignment.topLeft,
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.zero,
                hintText: "Title",
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
              style: TextStyle(fontSize: 20,color: mode ? Colors.white : Colors.black),
            ),
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.zero,
                hintText: "Enter your note name!",
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
              style: TextStyle(color: mode ? Colors.white : Colors.black),
              minLines: 10,
              maxLines: 10,
            ),
          ],
        ),
      ),
    );
  }

  void _androidDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            // contentPadding: const EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 10.0),
            backgroundColor: mode ? Colors.indigoAccent : Colors.amber.shade900,
            title: const Text(
              "New Note ",
              style: TextStyle(color: Colors.white),
            ),
            content: Container(
              color: Colors.white,
              height: 200,
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        hintText: "Title",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none)),
                  ),
                  Divider(color: Colors.black87,),
                  TextField(
                    controller: textController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      hintText: "Enter your note name!",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                    minLines: 5,
                    maxLines: 5,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "CANCEL",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  )),
              TextButton(
                  onPressed: () {
                    setState(() {
                      _createNotes();
                      Navigator.pop(context);
                      nameController.clear();
                      textController.clear();
                    });
                  },
                  child: const Text(
                    "SAVE",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  )),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return edit ? write(note_Index) : Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: mode ? Colors.blue.shade900 : Colors.amber.shade900,
        title: const Text("Notes",style: TextStyle(color: Colors.white),),
        actions: [
          delete ? TextButton(
              onPressed: () {
                setState(() {
                  delete = false;
                });
              },
              child: Text(
                "Cancel", style: TextStyle(color: Colors.white, fontSize: 15),)
          ) :
          Container(),
          delete ? TextButton(
              onPressed: () {
                setState(() {
                  print(deleteList);
                  deleteList.sort();
                  deleteList = deleteList.reversed.toList();
                  print(deleteList);
                  deleteList.forEach((index) {
                    listofNotes.removeAt(index);
                    print(listofNotes);
                  });
                  loadList();
                  deleteList.clear();
                  delete = false;
                  print(deleteList);
                });
              },
              child: Text("Delete",style: TextStyle(color: Colors.white,fontSize: 15),)) :
          IconButton(
              onPressed: _androidDialog,
              icon: Icon(Icons.add, color: Colors.white, size: 30,)),
        ],
      ),
      backgroundColor: mode ? Colors.indigo.shade900 : Colors.transparent,
      body: listofNotes.isEmpty
          ? Center(
        child: isLoading
            ? const CircularProgressIndicator.adaptive()
            : const Text(
          "There are not any notes",
          style: TextStyle(color: Colors.grey, fontSize: 20),
        ),
      )
          : ListView.builder(
        physics: BouncingScrollPhysics(),
          itemCount: listofNotes.length,
          itemBuilder: (context, index) {
            return _notes(index);
          }),
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     toolbarHeight: 60,
    //     shadowColor: Colors.teal,
    //     backgroundColor: Colors.blueAccent,
    //     title: Text("Notes",style:  TextStyle(color: Colors.white,fontSize: 20),),
    //     actions: [
    //       IconButton(
    //         onPressed: () {
    //           setState(() {
    //             _androidDialog();
    //           });
    //         },
    //         icon: Icon(Icons.add,size: 30,color: Colors.white,),
    //
    //       ),
    //     ],
    //   ),
    //   body: SingleChildScrollView(
    //     child: Container(
    //       height: MediaQuery.of(context).size.height-60,
    //       child: listofNotes.isEmpty ? Center(
    //         child: isLoading
    //             ? const CircularProgressIndicator.adaptive()
    //             : const Text(
    //           "There are not any notes",
    //           style: TextStyle(color: Colors.grey, fontSize: 20),
    //         ),
    //       ) :
    //       ListView.builder(
    //         itemCount: listofNotes.length,
    //         itemBuilder: (context,index){
    //           return Container(
    //             // margin: EdgeInsets.only(bottom: 10),
    //             decoration: BoxDecoration(
    //               color: Colors.white,
    //               // borderRadius: BorderRadius.horizontal(right: Radius.circular(50)),
    //               boxShadow: [
    //                 BoxShadow(
    //                     blurRadius: 1,
    //                     spreadRadius: 2,
    //                     blurStyle: BlurStyle.outer,
    //                     color: Colors.cyan
    //                 ),
    //               ],
    //             ),
    //             height: 100,
    //             padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
    //             alignment: Alignment.topLeft,
    //             child: Column(
    //               mainAxisAlignment: MainAxisAlignment.start,
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Text(listofNotes[index].name! != null ? listofNotes[index].name! : "" ,style: TextStyle(color: Colors.black,fontSize: 20),),
    //                 SizedBox(height: 10,),
    //                 Text(listofNotes[index].notes!,style: TextStyle(),maxLines: 3,overflow: TextOverflow.ellipsis,),
    //               ],
    //             ),
    //           );
    //         },
    //       ),
    //     ),
    //   ),
    // );
  }

  Widget _notes(int index) {
    return !delete ? MaterialButton(
      minWidth: MediaQuery
          .of(context)
          .size
          .width,
      onPressed: () {
        setState(() {
          edit = true;
          note_Index = index;
        });
      },
      onLongPress: () {
        setState(() {
          deleteList.add(index);
          delete = true;
        });
      },
      padding: EdgeInsets.all(0),
      child: Container(
        // margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: mode ? Colors.indigo.shade900  : Colors.white,
          // borderRadius: BorderRadius.horizontal(right: Radius.circular(50)),
          boxShadow: [
            mode ? BoxShadow() : BoxShadow(
                blurRadius: 1,
                spreadRadius: 2,
                blurStyle: BlurStyle.outer,
                color: Colors.amber.shade900
            ),
          ],
        ),
        height: 100,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        alignment: Alignment.topLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: "${listofNotes[index].name! != ""
                          ? listofNotes[index].name!.length > 11 ?
                      listofNotes[index].name!.substring(0, 11) + "..." :
                      listofNotes[index].name!
                          : ""}",
                        style: TextStyle(color: mode ? Colors.white : Colors.black, fontSize: 20),),
                      TextSpan(text: "${listofNotes[index].name! != ""
                          ? " | "
                          : ""}",
                          style: TextStyle(color: mode ? Colors.white : Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w300)),
                      TextSpan(
                        text: "${listofNotes[index].date!.substring(0, 19)}",
                        style: TextStyle(color: mode ? Colors.white : Colors.black, fontSize: 10),),
                      //
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 10,),
            Text(listofNotes[index].notes!, style: TextStyle(color: mode ? Colors.white : Colors.black),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,),
          ],
        ),
      ),
    ) :
    MaterialButton(
      minWidth: MediaQuery.of(context).size.width,
      onPressed: () {
        setState(() {
          deleteList.contains(index) ? deleteList.remove(index) :  deleteList.add(index);
        });
      },
      padding: EdgeInsets.all(0),
      child: Container(
        // margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          // borderRadius: BorderRadius.horizontal(right: Radius.circular(50)),
          boxShadow: [
            BoxShadow(
                blurRadius: 1,
                spreadRadius: 2,
                blurStyle: BlurStyle.outer,
                color: Colors.amber.shade900
            ),
          ],
        ),
        height: 100,
        padding: EdgeInsets.only(left: 0,right: 10,top: 5,bottom: 5),
        alignment: Alignment.topLeft,
        child: Row(
          children: [
            Container(
              width: 30,
              // color: Colors.green,
              child: IconButton(
                onPressed: () {},
                icon: Icon(deleteList.contains(index) ? Icons.circle : Icons.circle_outlined ,size: 15,color: deleteList.contains(index) ? Colors.red : Colors.grey,),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width-60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(text: "${listofNotes[index].name! != ""
                                ? listofNotes[index].name!.length > 10 ?
                            listofNotes[index].name!.substring(0, 10) + "..." :
                            listofNotes[index].name!
                                : ""}",
                              style: TextStyle(color: Colors.black, fontSize: 20),),
                            TextSpan(text: "${listofNotes[index].name! != ""
                                ? " | "
                                : ""}",
                                style: TextStyle(color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w300)),
                            TextSpan(
                              text: "${listofNotes[index].date!.substring(0, 19)}",
                              style: TextStyle(color: Colors.black, fontSize: 10),),
                            //
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10,),
                  Text(listofNotes[index].notes!, style: TextStyle(),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
