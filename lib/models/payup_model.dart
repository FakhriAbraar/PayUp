import 'package:isar/isar.dart';

part 'payup_model.g.dart';

@Collection()
class Bill {
  Id id = Isar.autoIncrement;
  late String title;
  late double totalAmount;
  late DateTime date;
  String? proofImageUrl; // Untuk menyimpan path foto dari kamera

  // Relasi: Satu tagihan punya banyak detail split (One-to-Many)
  final splitDetails = IsarLinks<SplitDetail>();
}

@Collection()
class SplitDetail {
  Id id = Isar.autoIncrement;
  late String personName;
  late double amountToPay;
  bool isPaid = false; // Fitur check apakah sudah bayar
}