import 'package:flutter/material.dart';
import 'package:weather/src/features/location/model/location.dart';

class AutocompleteOptions extends StatelessWidget {
  const AutocompleteOptions({
    required this.onSelected,
    required this.options,
    required this.enteredText,
    required this.maxOptionsHeight,
    required this.maxOptionsWidth,
    super.key,
  });

  final AutocompleteOnSelected<Location> onSelected;
  final Iterable<Location> options;
  final String enteredText;
  final double maxOptionsHeight;
  final double maxOptionsWidth;

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.topLeft,
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: maxOptionsHeight,
                maxWidth: maxOptionsWidth,
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: Colors.blue.withOpacity(0.7),
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                margin: EdgeInsets.zero,
                elevation: 0,
                child: _AutocompleteOptionsContent(
                  onSelected: onSelected,
                  options: options,
                  enteredText: enteredText,
                ),
              ),
            ),
          ),
        ),
      );
}

class _AutocompleteOptionsContent extends StatelessWidget {
  const _AutocompleteOptionsContent({
    required this.onSelected,
    required this.options,
    required this.enteredText,
    Key? key,
  }) : super(key: key);
  final AutocompleteOnSelected<Location> onSelected;
  final Iterable<Location> options;
  final String enteredText;

  @override
  Widget build(BuildContext context) => ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: options.length,
        itemBuilder: (context, index) {
          final option = options.elementAt(index);

          return GestureDetector(
            onTap: () {
              onSelected(option);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
              child: Text(option.fullName),
            ),
          );
        },
      );
}
