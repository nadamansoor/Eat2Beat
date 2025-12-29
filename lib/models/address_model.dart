class AddressModel {
  final String title;
  final String details;
  final bool isSelected;

  AddressModel({
    required this.title,
    required this.details,
    this.isSelected = false,
  });

  AddressModel copyWith({bool? isSelected}) {
    return AddressModel(
      title: title,
      details: details,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
