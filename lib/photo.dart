import 'package:objectbox/objectbox.dart';

@Entity()
class Photo {
  int id;
  final String? poto;

  Photo({this.id = 0, this.poto = 'no name'});
}
