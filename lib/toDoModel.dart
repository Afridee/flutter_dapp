import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class TodoListModel extends ChangeNotifier {
  List<Task> todos = [];
  final String _rpcUrl = "https://eth-rinkeby.alchemyapi.io/v2/7GlQ2WphTEelJnbxHC3s0stsjNWqeBZh";
  final String _wsUrl = "wss://eth-rinkeby.ws.alchemyapi.io/v2/7GlQ2WphTEelJnbxHC3s0stsjNWqeBZh";
  final String _privateKey = "**********************************************************";

  Web3Client _client;
  int taskCount = 0;
  String _abiCode;
  bool isLoading = true;
  Credentials _credentials;
  EthereumAddress ContractAddress;
  EthereumAddress _ownAddress;
  DeployedContract _contract;
  ContractFunction _taskCount;
  ContractFunction _todos;
  ContractFunction _createTask;
  ContractEvent _taskCreatedEvent;

  TodoListModel() {
    initiateSetup();
  }

  Future<void> initiateSetup() async {
    _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });
    await getAbi();
    await getCredentials();
    await getDeployedContract();
  }

  Future<void> getAbi() async {
    String abiStringFile =
        await rootBundle.loadString("src/abis/TodoList.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);
    ContractAddress = EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);

  }

  Future<void> getCredentials() async {
    _credentials = await _client.credentialsFromPrivateKey(_privateKey);
    _ownAddress = await _credentials.extractAddress();
    print(_ownAddress);
  }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(ContractAbi.fromJson(_abiCode, "TodoList"), ContractAddress);

    _taskCount = _contract.function("taskCount");
    _createTask = _contract.function("createTask");
    _todos = _contract.function("todos");
    _taskCreatedEvent = _contract.event("TaskCreated");

    getTodos();
  }

  getTodos() async {
    List totalTasksList = await _client.call(contract: _contract, function: _taskCount, params: []);
    BigInt totalTasks = totalTasksList[0];
    taskCount = totalTasks.toInt();
    todos.clear();
    for (var i = 0; i < totalTasks.toInt(); i++) {
      var temp = await _client.call(
          contract: _contract, function: _todos, params: [BigInt.from(i)]);
      todos.add(Task(taskName: temp[0], isCompleted: temp[1]));
    }

    isLoading = false;
    notifyListeners();
  }

  addTask(String taskNamedata) async {
    isLoading = true;
    notifyListeners();
    await _client.sendTransaction(
      _credentials,
      Transaction.callContract(
          contract: _contract,
          function: _createTask,
          parameters: [taskNamedata]),
      chainId: 4
    );
    getTodos();
  }
}

class Task {
  String taskName;
  bool isCompleted;
  Task({this.taskName, this.isCompleted});
}
