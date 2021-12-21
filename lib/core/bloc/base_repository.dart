import 'package:education_systems_mobile/core/http/api_provider.dart';

abstract class BaseRepository {
  BaseRepository(this.apiProvider);
  final ApiProvider apiProvider;
}
