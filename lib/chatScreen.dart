/*import 'package:flutter/material.dart';
import "package:dialogflow_flutter/dialogflowFlutter.dart";
import 'package:dialogflow_flutter/googleAuth.dart';
import 'package:dialogflow_flutter/language.dart';
import 'package:cms/database.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

class ChatroomScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        toolbarHeight: 100,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/avatar.png',
              width: 130, 
              height: 130.0, 
            ),
            SizedBox(width: 0.0),
            Text(
              'Chatbot',
              style: GoogleFonts.bebasNeue(
                  textStyle: TextStyle(fontSize: 20, color: Colors.black)),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: ChatroomWidget(
        databaseHelper: DatabaseHelper(),
      ), // Use ChatroomWidget as the body
    );
  }
}

// Widget for the chatroom
class ChatroomWidget extends StatefulWidget {
  final DatabaseHelper databaseHelper;
  const ChatroomWidget({required this.databaseHelper});

  @override
  _ChatroomWidgetState createState() => _ChatroomWidgetState(databaseHelper);
}

class _ChatroomWidgetState extends State<ChatroomWidget> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  DialogFlow? dialogFlow;
  late DatabaseHelper _databaseHelper;
  _ChatroomWidgetState(this._databaseHelper);

  // Initialize DialogFlow when the widget initializes
  @override
  void initState() {
    super.initState();
    _initializeDialogFlow();
  }

  // Method to initialize DialogFlow
  void _initializeDialogFlow() async {
    try {
      AuthGoogle authGoogle = await AuthGoogle(
        fileJson: "assets/cmsAppCreds.json",
      ).build();
      dialogFlow =
          DialogFlow(authGoogle: authGoogle, language: Language.english);
    } catch (error) {
      print("Error initializing DialogFlow: $error");
    }
  }

  // Method to send message to DialogFlow and get response
  void _sendMessage(String message) async {
    setState(() {
      _messages.add(ChatMessage(
        message: message,
        isUserMessage: true,
      ));
    });
    _controller.clear();

    if (dialogFlow != null) {
      _getDialogflowResponse(message);
    } else {
      print("DialogFlow is not initialized");
    }
  }

  void _getDialogflowResponse(String message) async {
    try {
      AIResponse response = await dialogFlow!.detectIntent(message);
      String responseText = response.getMessage() ?? 'No response';
      setState(() {
        _messages.add(ChatMessage(message: responseText, isUserMessage: false));
      });

      // Check if the response contains queryResult
      if (response.queryResult != null) {
        String intentName = response.queryResult!.intent?.displayName ?? '';
        if (intentName == 'contractRetrieve') {
          Map parameters = response.queryResult?.parameters ??
              {}; //changes to map<dynamic, dynamic>
          String contractName = parameters['contract_name'] ?? '';

          String contract = await _fetchContractFromDatabase(contractName);

          setState(() {
            _messages.add(ChatMessage(message: contract, isUserMessage: false));
          });
        }
      }
    } catch (error) {
      print("Error while fetching DialogFlow response: $error");
    }
  }

  Future<String> _fetchContractFromDatabase(String contractName) async {
    try {
      String contractInfo = await _databaseHelper.getContractInfo(contractName);
      return contractInfo;
    } catch (error) {
      print("Error retrieving contract information from database: $error");
      return 'Error: Unable to retrieve contract information';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!message.isUserMessage)
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/images/avatar.png'),
                          backgroundColor: Colors.white,
                          radius: 20,
                        ),
                      ),
                    Expanded(
                      child: Align(
                        alignment: message.isUserMessage
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: message.isUserMessage
                                ? Colors.red
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Text(message.message,
                              style: GoogleFonts.ptSans(
                                  textStyle: TextStyle(
                                      fontSize: 20,
                                      color: message.isUserMessage
                                          ? Colors.white
                                          : Colors.black))),
                        ),
                      ),
                    ),
                    if (message
                        .isUserMessage)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person),
                          foregroundColor: Colors.black,
                          radius: 20,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    _sendMessage(_controller.text);
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Model for a chat message
class ChatMessage {
  final String message;
  final bool isUserMessage;

  ChatMessage({
    required this.message,
    required this.isUserMessage,
  });
}
*/

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dialogflow_flutter/dialogflowFlutter.dart';
import 'package:dialogflow_flutter/googleAuth.dart';
import 'package:dialogflow_flutter/language.dart';
import 'package:cms/database.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatroomScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        toolbarHeight: 100,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/avatar.png',
              width: 130,
              height: 130.0,
            ),
            SizedBox(width: 0.0),
            Text(
              'Chatbot',
              style: GoogleFonts.bebasNeue(
                  textStyle: TextStyle(fontSize: 20, color: Colors.black)),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: ChatroomWidget(databaseHelper: DatabaseHelper()), // Use ChatroomWidget as the body
    );
  }
}

// Widget for the chatroom
class ChatroomWidget extends StatefulWidget {
  final DatabaseHelper databaseHelper;
  const ChatroomWidget({required this.databaseHelper});

  @override
  _ChatroomWidgetState createState() => _ChatroomWidgetState(databaseHelper);
}

class _ChatroomWidgetState extends State<ChatroomWidget> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  DialogFlow? dialogFlow;
  late DatabaseHelper _databaseHelper;

  _ChatroomWidgetState(this._databaseHelper);

  @override
  void initState() {
    super.initState();
    _initializeDialogFlow();
    _setUpWebhookEndpoint();
  }

  void _initializeDialogFlow() async {
    try {
      AuthGoogle authGoogle = await AuthGoogle(
        fileJson: "assets/cmsAppCreds.json",
      ).build();
      dialogFlow =
          DialogFlow(authGoogle: authGoogle, language: Language.english);
    } catch (error) {
      print("Error initializing DialogFlow: $error");
    }
  }

  Future<void> _setUpWebhookEndpoint() async {
    try {
      final server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);

      print('Webhook server listening on ${server.address}:${server.port}');

      await for (HttpRequest request in server) {
        _handleWebhookRequest(request);
      }
    } catch (e) {
      print('Error setting up webhook endpoint: $e');
    }
  }
  void _handleWebhookRequest(HttpRequest request) async {
  try {
    if (request.method == 'POST') {
      final payload = await utf8.decoder.bind(request).join();
      final data = jsonDecode(payload);

      // Extract parameters from the request
      final queryResult = data['queryResult'];
      final parameters = queryResult['parameters'];
      final contractName = parameters['contract_name'];

      // Fetch contract from the database
      final contractText = await _fetchContractFromDatabase(contractName);

      // Send response back to Dialogflow
      final response = jsonEncode({'fulfillmentText': contractText});
      request.response
        ..statusCode = HttpStatus.ok
        ..headers.contentType = ContentType.json
        ..write(response);
    } else {
      request.response
        ..statusCode = HttpStatus.methodNotAllowed
        ..write('Unsupported request method');
    }
  } catch (e) {
    print('Error handling webhook request: $e');
    request.response
      ..statusCode = HttpStatus.internalServerError
      ..write('Error handling request: $e');
  } finally {
    await request.response.close();
  }
}


  void _sendMessage(String message) async {
    setState(() {
      _messages.add(ChatMessage(
        message: message,
        isUserMessage: true,
      ));
    });
    _controller.clear();

    if (dialogFlow != null) {
      _getDialogflowResponse(message);
    } else {
      print("DialogFlow is not initialized");
    }
  }

  void _getDialogflowResponse(String message) async {
    try {
      AIResponse response = await dialogFlow!.detectIntent(message);
      String responseText = response.getMessage() ?? 'No response';
      setState(() {
        _messages.add(ChatMessage(message: responseText, isUserMessage: false));
      });

      // Check if the response contains queryResult
      if (response.queryResult != null) {
        String intentName = response.queryResult!.intent?.displayName ?? '';
        if (intentName == 'contractRetrieve') {
          Map parameters = response.queryResult?.parameters ??
              {}; //changes to map<dynamic, dynamic>
          String contractName = parameters['contract_name'] ?? '';

          String contract = await _fetchContractFromDatabase(contractName);

          setState(() {
            _messages.add(ChatMessage(message: contract, isUserMessage: false));
          });
        }
      }
    } catch (error) {
      print("Error while fetching DialogFlow response: $error");
    }
  }

  Future<String> _fetchContractFromDatabase(String contractName) async {
    try {
      String contractInfo = await _databaseHelper.getContractInfo(contractName);
      return contractInfo;
    } catch (error) {
      print("Error retrieving contract information from database: $error");
      return 'Error: Unable to retrieve contract information';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!message.isUserMessage)
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/images/avatar.png'),
                          backgroundColor: Colors.white,
                          radius: 20,
                        ),
                      ),
                    Expanded(
                      child: Align(
                        alignment: message.isUserMessage
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: message.isUserMessage
                                ? Colors.red
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Text(message.message,
                              style: GoogleFonts.ptSans(
                                  textStyle: TextStyle(
                                      fontSize: 20,
                                      color: message.isUserMessage
                                          ? Colors.white
                                          : Colors.black))),
                        ),
                      ),
                    ),
                    if (message
                        .isUserMessage)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person),
                          foregroundColor: Colors.black,
                          radius: 20,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    _sendMessage(_controller.text);
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Model for a chat message
class ChatMessage {
  final String message;
  final bool isUserMessage;

  ChatMessage({
    required this.message,
    required this.isUserMessage,
  });
}
