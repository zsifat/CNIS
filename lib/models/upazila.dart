enum Upazila {
  all,
  sadar,
  shibganj,
  nachol,
  gomostapur,
  bholahat,
}

extension UpazilaExtension on Upazila {
  // Convert the enum to a string for display purposes
  String get name {
    switch (this) {
      case Upazila.all:
        return 'সকল';
      case Upazila.sadar:
        return 'সদর';
      case Upazila.shibganj:
        return 'শিবগঞ্জ';
      case Upazila.nachol:
        return 'নাচোল';
      case Upazila.gomostapur:
        return 'গোমস্তাপুর';
      case Upazila.bholahat:
        return 'ভোলাহাট';
    }
  }

  // Convert a string to the corresponding enum value
  static Upazila fromString(String name) {
    switch (name) {
      case '':
        return Upazila.all;
      case 'সদর':
        return Upazila.sadar;
      case 'শিবগঞ্জ':
        return Upazila.shibganj;
      case 'নাচোল':
        return Upazila.nachol;
      case 'গোমস্তাপুর':
        return Upazila.gomostapur;
      case 'ভোলাহাট':
        return Upazila.bholahat;
      default:
        throw ArgumentError('Unknown upazila: $name');
    }
  }
}
