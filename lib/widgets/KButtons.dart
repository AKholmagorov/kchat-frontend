import 'package:flutter/material.dart';

class KProcessBtn extends StatelessWidget {
  const KProcessBtn({
    super.key,
    required this.hasError,
    this.nextPage,
    required this.afterClick,
    this.title = 'Next'
  });

  final bool hasError;
  final Widget? nextPage;
  final Function afterClick;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 270,
        height: 45,
        child: ElevatedButton(
          onPressed: hasError
            ? null
            : () {
                if (nextPage != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => nextPage!));
                }
                afterClick();
              },
          style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Color(0xFF0C4AA6)),
          ),
          child: Text('$title'),
        ));
  }
}

class KBackBtn extends StatelessWidget {
  const KBackBtn({super.key, this.title = 'Back'});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 270,
        height: 45,
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Color(0xFF34354E)),
          ),
          child: Text('$title'),
        ));
  }
}
