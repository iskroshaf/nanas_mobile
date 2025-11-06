import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> isOnline() async {
  final result = await Connectivity().checkConnectivity();

  return !result.contains(ConnectivityResult.none) && result.isNotEmpty;
}

Future<bool> isOnlineAlternative() async {
  final result = await Connectivity().checkConnectivity();

  return result.any(
    (connectivity) =>
        connectivity == ConnectivityResult.mobile ||
        connectivity == ConnectivityResult.wifi ||
        connectivity == ConnectivityResult.ethernet ||
        connectivity == ConnectivityResult.vpn ||
        connectivity == ConnectivityResult.bluetooth ||
        connectivity == ConnectivityResult.other,
  );
}

Future<bool> isOnlineComprehensive() async {
  final result = await Connectivity().checkConnectivity();

  return result.isNotEmpty &&
      result.any((connectivity) => connectivity != ConnectivityResult.none);
}
