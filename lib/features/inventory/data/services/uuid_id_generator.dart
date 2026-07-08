import '../../../../core/utils/uuid_generator.dart';
import '../../domain/services/id_generator.dart';

class UuidIdGenerator implements IdGenerator {
  @override
  String generate() => UuidGenerator.v4();
}

