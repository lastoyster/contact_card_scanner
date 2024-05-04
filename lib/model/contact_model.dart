// ignore_for_file: public_member_api_docs, sort_constructors_first
const String tblContact = 'tbl_contact';
const String tblContactColId = 'id';
const String tblContactColName = 'name';
const String tblContactColMobile = 'mobile';
const String tblContactColEmail = 'email';
const String tblContactColDesignation = 'designation';
const String tblContactColCompany = 'company';
const String tblContactColAddress = 'address';
const String tblContactColWeb = 'website';
const String tblContactColFavorite = 'favorite';
const String tblContactColImage = 'image';

class ContactModel {
  int id;
  String name;
  String mobile;
  String email;
  String designation;
  String company;
  String address;
  String website;
  String image;
  bool favorite;

  ContactModel(
      {this.id = -1,
      required this.name,
      required this.mobile,
      this.email = '',
      this.designation = '',
      this.company = '',
      this.address = '',
      this.website = '',
      this.image = '',
      this.favorite = false});
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      tblContactColName: name,
      tblContactColMobile: mobile,
      tblContactColEmail: email,
      tblContactColDesignation: designation,
      tblContactColCompany: company,
      tblContactColAddress: address,
      tblContactColWeb: website,
      tblContactColImage: image,
      tblContactColFavorite: favorite ? 1 : 0,
    };
    if (id != 0) {
      map[tblContactColId] = id;
    }
    return map;
  }

  factory ContactModel.fromMap(Map<String, dynamic> map) => ContactModel(
        id: map[tblContactColId],
        name: map[tblContactColName],
        mobile: map[tblContactColMobile],
        email: map[tblContactColEmail],
        designation: map[tblContactColDesignation],
        company: map[tblContactColCompany],
        address: map[tblContactColAddress],
        website: map[tblContactColWeb],
        image: map[tblContactColImage] ?? '',
        favorite: map[tblContactColFavorite] == 1 ? true : false,
      );

  @override
  String toString() {
    return 'ContactModel(id: $id, name: $name, mobile: $mobile, email: $email, designation: $designation, company: $company, address: $address, website: $website, favorite: $favorite)';
  }
}
