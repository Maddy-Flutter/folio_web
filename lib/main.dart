import 'package:follio/core/bootstrap.dart';
import 'package:follio/core/flavor_config.dart';

void main() {
  const String flavorStr = String.fromEnvironment('FLAVOR', defaultValue: 'user');
  final Flavor flavor = flavorStr.toLowerCase() == 'admin' ? Flavor.admin : Flavor.user;
  bootstrap(flavor);
}
