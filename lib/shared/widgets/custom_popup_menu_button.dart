import 'package:flutter/material.dart';

class CustomPopupMenuButton<T> extends StatefulWidget {
  final List<PopupMenuEntry<T>> Function(BuildContext) itemBuilder;
  final void Function(T)? onSelected;
  final Widget icon;
  final Color? color;

  const CustomPopupMenuButton({
    super.key,
    required this.itemBuilder,
    this.onSelected,
    required this.icon,
    this.color,
  });

  @override
  State<CustomPopupMenuButton<T>> createState() => _CustomPopupMenuButtonState<T>();
}

class _CustomPopupMenuButtonState<T> extends State<CustomPopupMenuButton<T>> {
  void _showMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject()! as RenderBox;
    final RenderBox overlay = Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu<T>(
      context: context,
      position: position,
      items: widget.itemBuilder(context),
      color: widget.color,
      surfaceTintColor: Colors.transparent,
      useRootNavigator: true,
    ).then((T? newValue) {
      if (newValue == null) return;
      widget.onSelected?.call(newValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showMenu(context),
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: widget.icon,
      ),
    );
  }
}
