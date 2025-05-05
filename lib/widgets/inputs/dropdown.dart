import 'package:customer_app/config/theme.dart';
import 'package:customer_app/widgets/buttons/submit_button.dart';
import 'package:customer_app/widgets/inputs/input_widgets.dart';
import 'package:flutter/material.dart';
import 'package:customer_app/config/text_styles.dart';
import 'package:customer_app/utils/size_config.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomDropdown extends StatefulWidget {
  final String? label;
  final List<String> items;
  final dynamic selectedItem;
  final ValueChanged<dynamic> onChanged;
  final bool isRequired;
  final double? width;
  final bool isMultiSelect;

  const CustomDropdown({
    super.key,
    this.label,
    required this.items,
    this.selectedItem,
    required this.onChanged,
    this.isRequired = false,
    this.width,
    this.isMultiSelect = false,
  });

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  List<String> _selectedItems = [];
  String? _selectedSingleItem;

  @override
  void initState() {
    super.initState();
    if (widget.isMultiSelect && widget.selectedItem is List<String>) {
      _selectedItems = List.from(widget.selectedItem);
    } else if (!widget.isMultiSelect && widget.selectedItem is String) {
      _selectedSingleItem = widget.selectedItem;
    }
  }

  void _showBottomSheet() async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return widget.isMultiSelect
            ? MultiSelectBottomSheet(
              items: widget.items,
              selectedItems: _selectedItems,
            )
            : SingleSelectBottomSheet(
              items: widget.items,
              selectedItem: _selectedSingleItem,
            );
      },
    );

    if (result != null) {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            if (widget.isMultiSelect) {
              _selectedItems = List.from(result);
              widget.onChanged(_selectedItems);
            } else {
              _selectedSingleItem = result;
              widget.onChanged(_selectedSingleItem);
            }
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Row(
            children: [
              Text(widget.label!, style: AppTextStyles.inputLabelStyle()),
              if (widget.isRequired)
                Text(
                  ' *',
                  style: AppTextStyles.inputLabelStyle().copyWith(
                    color: Colors.red,
                  ),
                ),
            ],
          ),
        if (widget.label != null) SizedBox(height: 10 * SizeConfig.heightScale),
        GestureDetector(
          onTap: _showBottomSheet,
          child: InputDecorator(
            decoration: AppTheme.inputDecoration.copyWith(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.isMultiSelect
                        ? (_selectedItems.isNotEmpty
                            ? _selectedItems.join(', ')
                            : 'Select options')
                        : (_selectedSingleItem ?? 'Select an option'),
                    style: AppTextStyles.inputHintStyle(),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SvgPicture.asset('assets/icons/dropdown-icon.svg'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class MultiSelectBottomSheet extends StatefulWidget {
  final List<String> items;
  final List<String> selectedItems;

  const MultiSelectBottomSheet({
    required this.items,
    required this.selectedItems,
    super.key,
  });

  @override
  _MultiSelectBottomSheetState createState() => _MultiSelectBottomSheetState();
}

class _MultiSelectBottomSheetState extends State<MultiSelectBottomSheet> {
  late List<String> _tempSelectedItems;
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _tempSelectedItems = List.from(widget.selectedItems);
    _filteredItems = List.from(widget.items);
  }

  void _filterItems(String query) {
    setState(() {
      _filteredItems =
          widget.items
              .where((item) => item.toLowerCase().contains(query.toLowerCase()))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          InputWidget(
            hint: 'Search',
            controller: _searchController,
            svgPath: 'assets/icons/search-icon.svg',
            onChanged: _filterItems,
          ),
          Expanded(
            child: ListView(
              children:
                  _filteredItems.map((item) {
                    final isSelected = _tempSelectedItems.contains(item);
                    return ListTile(
                      title: Text(item),
                      trailing:
                          isSelected
                              ? const Icon(
                                Icons.check,
                                color: AppTheme.primaryColor,
                              )
                              : null,
                      onTap: () {
                        setState(() {
                          isSelected
                              ? _tempSelectedItems.remove(item)
                              : _tempSelectedItems.add(item);
                        });
                      },
                    );
                  }).toList(),
            ),
          ),
          SubmitButton(
            text: 'Done',
            onPressed: () => Navigator.pop(context, _tempSelectedItems),
          ),
        ],
      ),
    );
  }
}

class SingleSelectBottomSheet extends StatefulWidget {
  final List<String> items;
  final String? selectedItem;

  const SingleSelectBottomSheet({
    required this.items,
    required this.selectedItem,
    super.key,
  });

  @override
  _SingleSelectBottomSheetState createState() =>
      _SingleSelectBottomSheetState();
}

class _SingleSelectBottomSheetState extends State<SingleSelectBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredItems = [];
  String selectedItem = "";

  @override
  void initState() {
    super.initState();
    _filteredItems = List.from(widget.items);
    selectedItem = widget.selectedItem ?? "";
  }

  void _filterItems(String query) {
    setState(() {
      _filteredItems =
          widget.items
              .where((item) => item.toLowerCase().contains(query.toLowerCase()))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          InputWidget(
            hint: 'Search',
            controller: _searchController,
            svgPath: 'assets/icons/search-icon.svg',
            onChanged: _filterItems,
          ),
          Expanded(
            child: ListView(
              children:
                  _filteredItems.map((item) {
                    return ListTile(
                      title: Text(item),
                      trailing:
                          item == widget.selectedItem
                              ? const Icon(
                                Icons.check,
                                color: AppTheme.primaryColor,
                              )
                              : null,
                      onTap: () {
                        setState(() {
                          selectedItem = item;
                        });
                        Navigator.pop(context, selectedItem);
                      },
                    );
                  }).toList(),
            ),
          ),
          SubmitButton(
            text: 'Done',
            onPressed: () {
              Navigator.pop(
                context,
                selectedItem.isNotEmpty ? selectedItem : widget.selectedItem,
              );
            },
          ),
        ],
      ),
    );
  }
}
