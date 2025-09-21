import 'package:flutter/material.dart';

class AppLoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;

  const AppLoadingIndicator({Key? key, this.size = 30, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          // ✅ تم التحديث هنا لاستخدام colorScheme
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? Theme.of(context).colorScheme.primary,
          ),
          strokeWidth: 3,
        ),
      ),
    );
  }
}
