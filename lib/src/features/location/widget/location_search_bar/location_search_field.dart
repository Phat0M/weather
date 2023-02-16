import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:weather/src/features/location/bloc/location_search_bloc.dart';
import 'package:weather/src/features/location/model/location.dart';
import 'package:weather/src/features/location/widget/location_search_bar/autocomplete_options.dart';

class LocationSearchField extends StatelessWidget {
  const LocationSearchField({
    required this.onSelected,
    required this.onSubmitted,
    super.key,
  });

  final ValueChanged<Location> onSelected;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) =>
            BlocBuilder<LocationSearchBloc, LocationSearchState>(
                builder: (context, state) {
          return Autocomplete<Location>(
            displayStringForOption: (option) => option.fullName,
            optionsBuilder: (textEditingValue) async {
              final bloc =
                  Provider.of<LocationSearchBloc>(context, listen: false);

              bloc.add(LocationSearchEvent.updateQuery(textEditingValue.text));

              final completeState = await bloc.stream.firstWhere((state) =>
                  state is SuccessLocationSearchState ||
                  state is ErrorLocationSearchState);
              return completeState.suggestions;
            },
            onSelected: onSelected,
            fieldViewBuilder: (
              innerContext,
              controller,
              node,
              onSuccess,
            ) =>
                Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: controller,
                focusNode: node,
                onSubmitted: onSubmitted,
                decoration: InputDecoration(
                    hintText: 'Введите локацию',
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue.withOpacity(0.7),
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    suffix: state is LoadingLocationSearchState
                        ? const SizedBox.square(
                            dimension: 15,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : null),
              ),
            ),
            optionsViewBuilder: (innerContext, onSelected, options) {
              final mediaQuery = MediaQuery.of(innerContext);
              final enteredText = state.query.text;

              return AutocompleteOptions(
                onSelected: (value) {
                  FocusScope.of(context).unfocus();
                  onSelected(value);
                },
                maxOptionsHeight:
                    (mediaQuery.size.height - mediaQuery.viewInsets.vertical) *
                        0.3,
                maxOptionsWidth: constraints.maxWidth,
                options: options,
                enteredText: enteredText,
              );
            },
          );
        }),
      );
}
