import 'dart:convert';
import 'package:dart_web3/dart_web3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web_socket_channel/io.dart';

import 'Fish.dart';

class FishController extends ChangeNotifier {
  List<Fish> fishes = [];
  bool isLoading = true;
  late int count;
  final String _rpcUrl = "http://192.168.1.13:7545";
  final String _wsUrl = "ws://192.168.1.13:7545";
  final String _privateKey =
      "0x428432da40e5e7308376a9308b8f682017c5073d6471abf76b10f22a68ad23cf";

  late Web3Client _client;
  late String _abiCode;
  late Credentials _credentials;
  late EthereumAddress _contractAddress;
  late DeployedContract _contract;
  // Define functions
  late ContractFunction _count;
  late ContractFunction _fishes;
  late ContractFunction _addFish;
  late ContractFunction _deleteFish;
  late ContractFunction _editFish;
  late ContractEvent _fishAddedEvent;
  late ContractEvent _fishDeletedEvent;

  FishController() {
    init();
  }

  Future<void> init() async {
    await getAbi();
    await getCredentials();
    await getDeployedContract();
  }

  Future<void> getAbi() async {
    String abiStringFile =
        await rootBundle.loadString("src/artifacts/SmartParking.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi['abi']);
    _contractAddress =
        EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);
  }

  Future<void> getCredentials() async {
    _credentials = EthPrivateKey.fromHex(_privateKey);
  }

  Future<void> getDeployedContract() async {
    _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "SmartParking"), _contractAddress);
    _count = _contract.function("fishCount");
    _fishes = _contract.function("fishes");
    _addFish = _contract.function("addFish");
    _deleteFish = _contract.function("deleteFish");
    _editFish = _contract.function("editFish");
    _fishAddedEvent = _contract.event("FishAdded");
    _fishDeletedEvent = _contract.event("FishDeleted");
    await getFishes();
  }

  Future<void> getFishes() async {
    List fishList =
        await _client.call(contract: _contract, function: _count, params: []);
    BigInt totalFishes = fishList[0];
    count = totalFishes.toInt();
    debugPrint("count $count");
    fishes.clear();
    for (int i = 0; i < count; i++) {
      var temp = await _client.call(
          contract: _contract, function: _fishes, params: [BigInt.from(i)]);
      if (temp[1] != "") {
        fishes.add(
          Fish(
            temp[0].toString(),
            typePoisson: temp[1],
            imageUrl: temp[2],
            localisation: temp[3],
          ),
        );
      }
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> addFish(Fish fish) async {
    debugPrint(
        "creating new Fish: type- ${fish.typePoisson}, imageUrl- ${fish.imageUrl}, location- ${fish.localisation}");
    isLoading = true;
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            function: _addFish,
            parameters: [fish.typePoisson, fish.imageUrl, fish.localisation],
            maxGas: 6721975),
        chainId: 1337,
        fetchChainIdFromNetworkId: false);

    await getFishes();
  }

  Future<void> deleteFish(int id) async {
    isLoading = true;
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            function: _deleteFish,
            parameters: [BigInt.from(id)],
            maxGas: 6721975),
        chainId: 1337,
        fetchChainIdFromNetworkId: false);

    await getFishes();
  }

  Future<void> editFish(Fish fish) async {
    isLoading = true;
    notifyListeners();
    print(BigInt.from(int.parse(fish.id)));
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            function: _editFish,
            parameters: [
              BigInt.from(int.parse(fish.id)),
              fish.typePoisson,
              fish.imageUrl,
              fish.localisation
            ],
            maxGas: 6721975),
        chainId: 1337,
        fetchChainIdFromNetworkId: false);

    await getFishes();
  }
}
