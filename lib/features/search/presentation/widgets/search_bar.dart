import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchBar extends StatefulWidget {
  final Function(String) onSearch;
  final String? initialQuery;
  final String? hintText;

  const SearchBar({
    super.key,
    required this.onSearch,
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
    // Gọi search ngay lập tức khi người dùng nhập từng ký tự
    widget.onSearch(query);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        autofocus: false,
        decoration: InputDecoration(
          hintText: widget.hintText ?? 'Tìm kiếm người dùng...',
          hintStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: 14.sp,
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    CupertinoIcons.clear_circled_solid,
                    color: Colors.grey[600],
                    size: 20.r,
                  ),
                  onPressed: () {
                    _controller.clear();
                    widget.onSearch('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
        ),
        style: TextStyle(fontSize: 14.sp),
        onChanged: (value) {
          setState(() {});
          // Gọi search ngay lập tức khi người dùng nhập từng ký tự
          _handleSearch(value);
        },
        onSubmitted: _handleSearch,
      ),
    );
  }
}

