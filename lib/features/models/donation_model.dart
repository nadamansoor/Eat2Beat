class DonationModel {
  String title;
  String desc;
  String aboutCharity;
  int noRunProject;
  int noProjectDonated;

  DonationModel({
    required this.title,
    required this.desc,
    required this.aboutCharity,
    required this.noRunProject,
    required this.noProjectDonated,
  });

  static final List<DonationModel> donationModel = [
    DonationModel(
      title: "Share Food, Share Love",
      desc:
      "Help families in need by donating surplus food.\n"
          "Your contribution supports daily meals for those\n"
          "facing food insecurity and brings hope to homes.",
      aboutCharity:
      "A community-driven charity focused on collecting\n"
          "and redistributing food to underprivileged families.",
      noRunProject: 6,
      noProjectDonated: 18,
    ),

    DonationModel(
      title: "Feed a Family Today",
      desc:
      "Your donation helps provide nutritious meals\n"
          "to families struggling to meet daily needs.\n"
          "Every meal makes a real difference.",
      aboutCharity:
      "This charity partners with local donors and\n"
          "volunteers to ensure food reaches those in need.",
      noRunProject: 4,
      noProjectDonated: 12,
    ),

    DonationModel(
      title: "One Meal, One Smile",
      desc:
      "A single meal can restore dignity and hope.\n"
          "Join us in delivering food to vulnerable\n"
          "individuals across the community.",
      aboutCharity:
      "Focused on fast and reliable food distribution\n"
          "to people facing urgent hunger situations.",
      noRunProject: 5,
      noProjectDonated: 20,
    ),

    DonationModel(
      title: "Nourish Lives with Care",
      desc:
      "Support programs that deliver healthy meals\n"
          "to children and elderly people in need.\n"
          "Your kindness fuels their future.",
      aboutCharity:
      "A nonprofit organization dedicated to\n"
          "long-term food sustainability programs.",
      noRunProject: 3,
      noProjectDonated: 15,
    ),

    DonationModel(
      title: "Food for Every Home",
      desc:
      "Help ensure that no home sleeps hungry.\n"
          "Your donation strengthens food access\n"
          "for low-income families.",
      aboutCharity:
      "Working closely with local communities\n"
          "to identify and support families in need.",
      noRunProject: 7,
      noProjectDonated: 22,
    ),

    DonationModel(
      title: "Together Against Hunger",
      desc:
      "Stand with us to fight hunger through\n"
          "organized food drives and meal programs.\n"
          "Together, we can make an impact.",
      aboutCharity:
      "An initiative that mobilizes volunteers\n"
          "and donors to fight hunger nationwide.",
      noRunProject: 8,
      noProjectDonated: 30,
    ),

    DonationModel(
      title: "Hope Starts with a Meal",
      desc:
      "Provide essential meals to individuals\n"
          "facing difficult circumstances.\n"
          "Your help brings comfort and stability.",
      aboutCharity:
      "Focused on emergency food relief and\n"
          "support for vulnerable individuals.",
      noRunProject: 4,
      noProjectDonated: 14,
    ),

    DonationModel(
      title: "Feed Hearts, Feed Souls",
      desc:
      "Support community kitchens serving\n"
          "fresh meals prepared with care.\n"
          "Every donation feeds a heart.",
      aboutCharity:
      "A volunteer-based charity running\n"
          "daily community kitchens.",
      noRunProject: 5,
      noProjectDonated: 19,
    ),

    DonationModel(
      title: "Give Food, Give Hope",
      desc:
      "Your food donation helps restore hope\n"
          "and dignity to families in need.\n"
          "Small actions create big change.",
      aboutCharity:
      "Dedicated to connecting donors with\n"
          "families facing food shortages.",
      noRunProject: 6,
      noProjectDonated: 25,
    ),

    DonationModel(
      title: "Care Through Sharing",
      desc:
      "Sharing food is a powerful act of care.\n"
          "Join us in supporting sustainable food\n"
          "distribution programs.",
      aboutCharity:
      "A charity promoting responsible food\n"
          "sharing and waste reduction.",
      noRunProject: 3,
      noProjectDonated: 11,
    ),

    DonationModel(
      title: "Food Brings Us Together",
      desc:
      "Help create stronger communities by\n"
          "supporting shared meal initiatives.\n"
          "Food connects hearts and homes.",
      aboutCharity:
      "A social organization that uses food\n"
          "as a tool for community building.",
      noRunProject: 5,
      noProjectDonated: 17,
    ),

    DonationModel(
      title: "A Meal Can Change a Life",
      desc:
      "Your donation provides more than food.\n"
          "It offers hope, care, and a better\n"
          "tomorrow for those in need.",
      aboutCharity:
      "Committed to long-term impact through\n"
          "consistent food support programs.",
      noRunProject: 9,
      noProjectDonated: 35,
    ),
  ];

}
