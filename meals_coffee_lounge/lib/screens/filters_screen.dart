import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_coffee_lounge/providers/filters_provider.dart';
import 'package:meals_coffee_lounge/screens/tabs_screen.dart';
import 'package:meals_coffee_lounge/widgets/main_drawer.dart';
import 'package:meals_coffee_lounge/enums/filter.dart';

class FiltersScreen extends ConsumerStatefulWidget {
  const FiltersScreen({super.key});

  @override
  ConsumerState<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends ConsumerState<FiltersScreen> {
  bool _glutenFreeSet = false;
  bool _lactoseFreeSet = false;
  bool _vegetarianSet = false;
  bool _veganSet = false;

  void _setScreen(String identifier) {
    Navigator.of(context).pop();

    switch (identifier) {
      case 'filters':
        {
          // Navigator.of(context).pop();
        }
        break;
      case 'meals':
        {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (ctx) => const TabsScreen()));
        }
    }
  }

  @override
  void initState() {
    super.initState();
    final activeFilters = ref.read(filtersProvider);
    _glutenFreeSet = activeFilters[Filter.glutenFree]!;
    _lactoseFreeSet = activeFilters[Filter.lactoseFree]!;
    _vegetarianSet = activeFilters[Filter.vegetarianFree]!;
    _veganSet = activeFilters[Filter.vegan]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your filters'),
      ),
      drawer: MainDrawer(onSelectScreen: _setScreen),
      body: Column(
        children: [
          SwitchListTile(
            value: _lactoseFreeSet,
            onChanged: (val) {
              setState(() {
                _lactoseFreeSet = val;
              });

              // set the global lactose free filter
              ref
                  .read(filtersProvider.notifier)
                  .setFilter(Filter.lactoseFree, val);
            },
            title: Text('Lactose-free',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground)),
            subtitle: Text('Only include lactose-free meals.',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground)),
            activeColor: Theme.of(context).colorScheme.tertiary,
            contentPadding: const EdgeInsets.only(left: 34, right: 22),
          ),
          SwitchListTile(
            value: _glutenFreeSet,
            onChanged: (val) {
              setState(() {
                _glutenFreeSet = val;
              });

              // set the global gluten free filter
              ref
                  .read(filtersProvider.notifier)
                  .setFilter(Filter.glutenFree, val);
            },
            title: Text(
              'Gluten-free',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
            subtitle: Text('Only include gluten-free meals.',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground)),
            activeColor: Theme.of(context).colorScheme.tertiary,
            contentPadding: const EdgeInsets.only(left: 34, right: 22),
          ),
          SwitchListTile(
            value: _vegetarianSet,
            onChanged: (val) {
              setState(() {
                _vegetarianSet = val;
              });

              // set the global vegetarian filter
              ref
                  .read(filtersProvider.notifier)
                  .setFilter(Filter.vegetarianFree, val);
            },
            title: Text('Vegetarian',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground)),
            subtitle: Text('Only include vegetarian meals.',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground)),
            activeColor: Theme.of(context).colorScheme.tertiary,
            contentPadding: const EdgeInsets.only(left: 34, right: 22),
          ),
          SwitchListTile(
            value: _veganSet,
            onChanged: (val) {
              setState(() {
                _veganSet = val;
              });

              // set the global vegan filter
              ref.read(filtersProvider.notifier).setFilter(Filter.vegan, val);
            },
            title: Text('Vegan',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground)),
            subtitle: Text('Only include vegan meals.',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground)),
            activeColor: Theme.of(context).colorScheme.tertiary,
            contentPadding: const EdgeInsets.only(left: 34, right: 22),
          )
        ],
      ),
    );
  }
}
