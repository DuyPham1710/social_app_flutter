import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class SearchBar extends StatefulWidget {
  final Function(String) onSearch;
  final Function(String)? onSearchSubmitted;
  final String? initialQuery;
  final String? hintText;

  const SearchBar({
    super.key,
    required this.onSearch,
    this.onSearchSubmitted,
    this.initialQuery,
    this.hintText,
  });

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSearch(String query) {
    // Gọi search ngay lập tức khi người dùng nhập từng ký tự (chỉ để hiển thị kết quả)
    widget.onSearch(query);
  }

  void _handleSearchSubmitted(String query) {
    // Gọi search khi người dùng nhấn Enter (để lưu vào lịch sử)
    if (widget.onSearchSubmitted != null) {
      widget.onSearchSubmitted!(query);
    } else {
      widget.onSearch(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.secondBackground,
        borderRadius: BorderRadius.circular(12.rsr(context)),
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        autofocus: false,
        cursorColor: AppColors.primary,
        decoration: InputDecoration(
          hintText: widget.hintText ?? context.l10n.searchUserHint,
          hintStyle: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14.rsp(context),
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    CupertinoIcons.clear_circled_solid,
                    color: AppColors.iconPrimary,
                    size: 20.rsr(context),
                  ),
                  onPressed: () {
                    _controller.clear();
                    widget.onSearch('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.rs(context),
            vertical: 12.rsh(context),
          ),
        ),
        style: TextStyle(
          fontSize: 14.rsp(context),
          color: AppColors.textPrimary,
        ),
        onChanged: (value) {
          setState(() {});
          _handleSearch(value);
        },
        onSubmitted: _handleSearchSubmitted,
      ),
    );
  }
}
