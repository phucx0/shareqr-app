import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class QRSearchBar extends StatefulWidget {
  final Function(String) onSubmit; 

  const QRSearchBar({
    Key? key,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<QRSearchBar> createState() => _QRSearchBarState();
}

class _QRSearchBarState extends State<QRSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: false,
      onSubmitted: widget.onSubmit,
      controller: _controller,
      maxLines: 1,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        hintText: 'Tìm QR',
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: const Color(0xFF283447),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: BorderSide.none,
        ),

        // ICON BÊN PHẢI
        suffixIcon: SizedBox(
          width: 32,
          height: 32,
          child: Padding(
            padding: const EdgeInsets.all(14), // giảm padding để icon lớn hơn
            child: SvgPicture.asset(
              'assets/svg/search.svg',
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
      onChanged: (_) => setState(() {}),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}