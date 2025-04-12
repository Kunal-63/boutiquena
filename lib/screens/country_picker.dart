import 'package:customer_app/config/text_styles.dart';
import 'package:customer_app/config/theme.dart';
import 'package:customer_app/utils/size_config.dart';
import 'package:customer_app/widgets/headers/common_appbar.dart';
import 'package:customer_app/widgets/inputs/input_widgets.dart';
import 'package:customer_app/widgets/popup_menu_item.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CountryPickerScreen extends StatefulWidget {
  final CountryCode lastSelectedCountry;

  const CountryPickerScreen({super.key, required this.lastSelectedCountry});

  @override
  _CountryPickerScreenState createState() => _CountryPickerScreenState();
}

class _CountryPickerScreenState extends State<CountryPickerScreen> {
  List<CountryCode> _countries = [];
  List<CountryCode> _filteredCountries = [];
  late CountryCode _lastSelectedCountry;
  final TextEditingController _searchController = TextEditingController();
  List<String> _availableLetters = [];
  late String _selectedLetter;

  @override
  void initState() {
    super.initState();
    _lastSelectedCountry = widget.lastSelectedCountry;
    _initializeCountries();
    if (_availableLetters.isNotEmpty) {
      _selectedLetter =
          _availableLetters.first; // Initialize with the first available letter
    } else {
      _selectedLetter =
          ''; // Provide an empty string if no letters are available
    }
  }

  void _initializeCountries() {
    _countries = [
      CountryCode(
        code: "AF",
        name: "Afghanistan",
        dialCode: "+93",
        flagUri: "flags/af.png",
      ),
      CountryCode(
        code: "AL",
        name: "Albania",
        dialCode: "+355",
        flagUri: "flags/al.png",
      ),
      CountryCode(
        code: "DZ",
        name: "Algeria",
        dialCode: "+213",
        flagUri: "flags/dz.png",
      ),
      CountryCode(
        code: "AD",
        name: "Andorra",
        dialCode: "+376",
        flagUri: "flags/ad.png",
      ),
      CountryCode(
        code: "AO",
        name: "Angola",
        dialCode: "+244",
        flagUri: "flags/ao.png",
      ),
      CountryCode(
        code: "AR",
        name: "Argentina",
        dialCode: "+54",
        flagUri: "flags/ar.png",
      ),
      CountryCode(
        code: "AM",
        name: "Armenia",
        dialCode: "+374",
        flagUri: "flags/am.png",
      ),
      CountryCode(
        code: "AU",
        name: "Australia",
        dialCode: "+61",
        flagUri: "flags/au.png",
      ),
      CountryCode(
        code: "AT",
        name: "Austria",
        dialCode: "+43",
        flagUri: "flags/at.png",
      ),
      CountryCode(
        code: "AZ",
        name: "Azerbaijan",
        dialCode: "+994",
        flagUri: "flags/az.png",
      ),
      CountryCode(
        code: "BH",
        name: "Bahrain",
        dialCode: "+973",
        flagUri: "flags/bh.png",
      ),
      CountryCode(
        code: "BD",
        name: "Bangladesh",
        dialCode: "+880",
        flagUri: "flags/bd.png",
      ),
      CountryCode(
        code: "BY",
        name: "Belarus",
        dialCode: "+375",
        flagUri: "flags/by.png",
      ),
      CountryCode(
        code: "BE",
        name: "Belgium",
        dialCode: "+32",
        flagUri: "flags/be.png",
      ),
      CountryCode(
        code: "BZ",
        name: "Belize",
        dialCode: "+501",
        flagUri: "flags/bz.png",
      ),
      CountryCode(
        code: "BJ",
        name: "Benin",
        dialCode: "+229",
        flagUri: "flags/bj.png",
      ),
      CountryCode(
        code: "BT",
        name: "Bhutan",
        dialCode: "+975",
        flagUri: "flags/bt.png",
      ),
      CountryCode(
        code: "BO",
        name: "Bolivia",
        dialCode: "+591",
        flagUri: "flags/bo.png",
      ),
      CountryCode(
        code: "BR",
        name: "Brazil",
        dialCode: "+55",
        flagUri: "flags/br.png",
      ),
      CountryCode(
        code: "BG",
        name: "Bulgaria",
        dialCode: "+359",
        flagUri: "flags/bg.png",
      ),
      CountryCode(
        code: "CA",
        name: "Canada",
        dialCode: "+1",
        flagUri: "flags/ca.png",
      ),
      CountryCode(
        code: "CL",
        name: "Chile",
        dialCode: "+56",
        flagUri: "flags/cl.png",
      ),
      CountryCode(
        code: "CN",
        name: "China",
        dialCode: "+86",
        flagUri: "flags/cn.png",
      ),
      CountryCode(
        code: "CO",
        name: "Colombia",
        dialCode: "+57",
        flagUri: "flags/co.png",
      ),
      CountryCode(
        code: "HR",
        name: "Croatia",
        dialCode: "+385",
        flagUri: "flags/hr.png",
      ),
      CountryCode(
        code: "CU",
        name: "Cuba",
        dialCode: "+53",
        flagUri: "flags/cu.png",
      ),
      CountryCode(
        code: "CY",
        name: "Cyprus",
        dialCode: "+357",
        flagUri: "flags/cy.png",
      ),
      CountryCode(
        code: "CZ",
        name: "Czech Republic",
        dialCode: "+420",
        flagUri: "flags/cz.png",
      ),
      CountryCode(
        code: "DK",
        name: "Denmark",
        dialCode: "+45",
        flagUri: "flags/dk.png",
      ),
      CountryCode(
        code: "EG",
        name: "Egypt",
        dialCode: "+20",
        flagUri: "flags/eg.png",
      ),
      CountryCode(
        code: "FI",
        name: "Finland",
        dialCode: "+358",
        flagUri: "flags/fi.png",
      ),
      CountryCode(
        code: "FR",
        name: "France",
        dialCode: "+33",
        flagUri: "flags/fr.png",
      ),
      CountryCode(
        code: "DE",
        name: "Germany",
        dialCode: "+49",
        flagUri: "flags/de.png",
      ),
      CountryCode(
        code: "GR",
        name: "Greece",
        dialCode: "+30",
        flagUri: "flags/gr.png",
      ),
      CountryCode(
        code: "IN",
        name: "India",
        dialCode: "+91",
        flagUri: "flags/in.png",
      ),
      CountryCode(
        code: "ID",
        name: "Indonesia",
        dialCode: "+62",
        flagUri: "flags/id.png",
      ),
      CountryCode(
        code: "IL",
        name: "Israel",
        dialCode: "+972",
        flagUri: "flags/il.png",
      ),
      CountryCode(
        code: "IR",
        name: "Iran",
        dialCode: "+98",
        flagUri: "flags/ir.png",
      ),
      CountryCode(
        code: "IQ",
        name: "Iraq",
        dialCode: "+964",
        flagUri: "flags/iq.png",
      ),
      CountryCode(
        code: "IE",
        name: "Ireland",
        dialCode: "+353",
        flagUri: "flags/ie.png",
      ),
      CountryCode(
        code: "IT",
        name: "Italy",
        dialCode: "+39",
        flagUri: "flags/it.png",
      ),
      CountryCode(
        code: "JP",
        name: "Japan",
        dialCode: "+81",
        flagUri: "flags/jp.png",
      ),
      CountryCode(
        code: "KE",
        name: "Kenya",
        dialCode: "+254",
        flagUri: "flags/ke.png",
      ),
      CountryCode(
        code: "KW",
        name: "Kuwait",
        dialCode: "+965",
        flagUri: "flags/kw.png",
      ),
      CountryCode(
        code: "MY",
        name: "Malaysia",
        dialCode: "+60",
        flagUri: "flags/my.png",
      ),
      CountryCode(
        code: "MX",
        name: "Mexico",
        dialCode: "+52",
        flagUri: "flags/mx.png",
      ),
      CountryCode(
        code: "MA",
        name: "Morocco",
        dialCode: "+212",
        flagUri: "flags/ma.png",
      ),
      CountryCode(
        code: "NL",
        name: "Netherlands",
        dialCode: "+31",
        flagUri: "flags/nl.png",
      ),
      CountryCode(
        code: "NZ",
        name: "New Zealand",
        dialCode: "+64",
        flagUri: "flags/nz.png",
      ),
      CountryCode(
        code: "NG",
        name: "Nigeria",
        dialCode: "+234",
        flagUri: "flags/ng.png",
      ),
      CountryCode(
        code: "NO",
        name: "Norway",
        dialCode: "+47",
        flagUri: "flags/no.png",
      ),
      CountryCode(
        code: "PK",
        name: "Pakistan",
        dialCode: "+92",
        flagUri: "flags/pk.png",
      ),
      CountryCode(
        code: "PH",
        name: "Philippines",
        dialCode: "+63",
        flagUri: "flags/ph.png",
      ),
      CountryCode(
        code: "PL",
        name: "Poland",
        dialCode: "+48",
        flagUri: "flags/pl.png",
      ),
      CountryCode(
        code: "PT",
        name: "Portugal",
        dialCode: "+351",
        flagUri: "flags/pt.png",
      ),
      CountryCode(
        code: "RU",
        name: "Russia",
        dialCode: "+7",
        flagUri: "flags/ru.png",
      ),
      CountryCode(
        code: "SA",
        name: "Saudi Arabia",
        dialCode: "+966",
        flagUri: "flags/sa.png",
      ),
      CountryCode(
        code: "ZA",
        name: "South Africa",
        dialCode: "+27",
        flagUri: "flags/za.png",
      ),
      CountryCode(
        code: "ES",
        name: "Spain",
        dialCode: "+34",
        flagUri: "flags/es.png",
      ),
      CountryCode(
        code: "LK",
        name: "Sri Lanka",
        dialCode: "+94",
        flagUri: "flags/lk.png",
      ),
      CountryCode(
        code: "SE",
        name: "Sweden",
        dialCode: "+46",
        flagUri: "flags/se.png",
      ),
      CountryCode(
        code: "CH",
        name: "Switzerland",
        dialCode: "+41",
        flagUri: "flags/ch.png",
      ),
      CountryCode(
        code: "TH",
        name: "Thailand",
        dialCode: "+66",
        flagUri: "flags/th.png",
      ),
      CountryCode(
        code: "TR",
        name: "Turkey",
        dialCode: "+90",
        flagUri: "flags/tr.png",
      ),
      CountryCode(
        code: "AE",
        name: "United Arab Emirates",
        dialCode: "+971",
        flagUri: "flags/ae.png",
      ),
      CountryCode(
        code: "GB",
        name: "United Kingdom",
        dialCode: "+44",
        flagUri: "flags/gb.png",
      ),
      CountryCode(
        code: "US",
        name: "United States",
        dialCode: "+1",
        flagUri: "flags/us.png",
      ),
      CountryCode(
        code: "VN",
        name: "Vietnam",
        dialCode: "+84",
        flagUri: "flags/vn.png",
      ),
    ];

    _filteredCountries = List.from(_countries);
    _updateAvailableLetters();
  }

  void _filterCountries(String query) {
    setState(() {
      _filteredCountries = _countries
          .where(
            (country) => (country.name ?? '').toLowerCase().contains(
                  query.toLowerCase(),
                ),
          )
          .toList();
      _updateAvailableLetters();
    });
  }

  void _updateAvailableLetters() {
    _availableLetters = _countries.map((c) => c.name![0]).toSet().toList()
      ..sort();
  }

  void _filterByLetter(String letter) {
    setState(() {
      _selectedLetter = letter;
      _filteredCountries = _countries
          .where((country) => country.name!.startsWith(letter))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: CommonAppBar(
          title: "Profile",
          menuPressed: () {},
          menuItems: [
            PopupMenuHelper.buildPopupMenuItem(
              0,
              'assets/icons/edit-popup-icon.svg',
              'Edit',
            ),
          ],
        ),
      ),
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                  child: InputWidget(
                    hint: 'Search...',
                    controller: _searchController,
                    onChanged: _filterCountries,
                    svgPath: 'assets/icons/search-icon.svg',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Last Pick",
                        style: AppTextStyles.blackSubHeadingStyle().copyWith(
                          fontSize: 14 * SizeConfig.widthScale,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 5),
                      ListTile(
                        dense: true, // Reduces ListTile height
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 0,
                        ), // Less padding
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.asset(
                            _lastSelectedCountry.flagUri ?? '',
                            package: 'country_list_pick',
                            width: 34,
                            height: 24,
                            fit: BoxFit.cover,
                          ),
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.primaryColor,
                          ),
                          child: SvgPicture.asset(
                            'assets/icons/tick-icon.svg',
                            color: Colors.white,
                            height: 7,
                            width: 7,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: Color.fromRGBO(217, 217, 217, 1),
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(5.66),
                        ),
                        title: Text(
                          _lastSelectedCountry.name ?? '',
                          style: AppTextStyles.blackSubHeadingStyle().copyWith(
                            fontSize: 14 * SizeConfig.widthScale,
                            fontWeight: FontWeight.w400,
                          ),
                          overflow:
                              TextOverflow.ellipsis, // Prevents text overflow
                          maxLines: 1,
                        ),
                        onTap: () {
                          setState(() {
                            _lastSelectedCountry = _lastSelectedCountry;
                          });
                          Navigator.pop(context, _lastSelectedCountry);
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: _filteredCountries.length,
                          itemBuilder: (context, index) {
                            CountryCode country = _filteredCountries[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 0,
                              ),
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image.asset(
                                    country.flagUri ?? '',
                                    package: 'country_list_pick',
                                    width: 34,
                                    height: 24,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(
                                  country.name ?? '',
                                  style: AppTextStyles.blackSubHeadingStyle()
                                      .copyWith(
                                    fontSize: 14 * SizeConfig.widthScale,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    _lastSelectedCountry = country;
                                  });
                                  Navigator.pop(context, country);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: _availableLetters
                              .map(
                                (letter) => GestureDetector(
                                  onTap: () => _filterByLetter(letter),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _selectedLetter == letter
                                          ? AppTheme.primaryColor
                                          : Colors.transparent,
                                    ),
                                    child: Text(
                                      letter,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold,
                                        color: _selectedLetter == letter
                                            ? Colors.white
                                            : AppTheme.primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
