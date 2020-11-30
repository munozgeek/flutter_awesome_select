import 'package:flutter/material.dart';
import 'package:smart_select/smart_select.dart';
import '../choices.dart' as choices;

class FeaturesModalSelector extends StatefulWidget {
  @override
  _FeaturesModalSelectorState createState() => _FeaturesModalSelectorState();
}

class _FeaturesModalSelectorState extends State<FeaturesModalSelector> {

  List<String> _fruit = ['mel'];
  List<String> _smartphone = [];
  List<String> _car = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 7),
        SmartSelect<String>.multiple(
          title: 'Fruit',
          value: _fruit,
          onChange: (state) => setState(() => _fruit = state.value),
          choiceItems: choices.fruits,
          modalType: S2ModalType.popupDialog,
          modalConfirm: true,
          modalValidation: (value) => value.length > 0 ? null : 'Select at least one',
          modalHeaderStyle: S2ModalHeaderStyle(
            backgroundColor: Theme.of(context).cardColor,
          ),
          tileBuilder: (context, state) {
            return S2Tile.fromState(
              state,
              isTwoLine: true,
              leading: Container(
                width: 40,
                alignment: Alignment.center,
                child: const Icon(Icons.shopping_cart),
              ),
            );
          },
          modalActionsBuilder: (context, state) {
            return <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 13),
                child: state.choiceSelectorAll,
              )
            ];
          },
          modalDividerBuilder: (context, state) {
            return const Divider(height: 1);
          },
          modalFooterBuilder: (context, state) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 7.0,
              ),
              child: Row(
                children: <Widget>[
                  const Spacer(),
                  FlatButton(
                    child: const Text('Cancel'),
                    onPressed: () => state.closeModal(confirmed: false),
                  ),
                  const SizedBox(width: 5),
                  FlatButton(
                    child: Text('OK (${state.changes.length})'),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: state.changes.valid
                      ? () => state.closeModal(confirmed: true)
                      : null,
                  ),
                ],
              ),
            );
          }
        ),
        const Divider(indent: 20),
        SmartSelect<String>.multiple(
          title: 'Phones',
          placeholder: 'Choose one',
          value: _smartphone,
          onChange: (state) => setState(() => _smartphone = state.value),
          choiceItems: S2Choice.listFrom<String, Map>(
            source: choices.smartphones,
            value: (index, item) => item['id'],
            title: (index, item) => item['name'],
            group: (index, item) => item['brand'],
            meta: (index, item) => item,
          ),
          choiceType: S2ChoiceType.chips,
          choiceActiveStyle: S2ChoiceStyle(
            color: Theme.of(context).primaryColor
          ),
          modalFilter: true,
          modalType: S2ModalType.fullPage,
          modalFooterBuilder: (context, state) {
            return Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ActionButton(
                    label: const Text('All/None'),
                    onTap: () {
                      state.changes.selectToggle();
                    },
                  ),
                  ActionButton(
                    label: const Text('Low End'),
                    onTap: () {
                      state.changes.value = state.widget.choiceItems
                        .where((item) => item.meta['category'] == 'Budget Phone')
                        .map((item) => item.value)
                        .toList();
                    },
                  ),
                  ActionButton(
                    label: const Text('Mid End'),
                    onTap: () {
                      state.changes.value = state.widget.choiceItems
                        .where((item) => item.meta['category'] == 'Mid End Phone')
                        .map((item) => item.value)
                        .toList();
                    },
                  ),
                  ActionButton(
                    label: const Text('High End'),
                    onTap: () {
                      state.changes.value = state.widget.choiceItems
                        .where((item) => item.meta['category'] == 'Flagship Phone')
                        .map((item) => item.value)
                        .toList();
                    },
                  ),
                ],
              ),
            );
          },
          tileBuilder: (context, state) {
            return S2Tile.fromState(
              state,
              hideValue: true,
              trailing: const Icon(Icons.add_circle_outline),
              leading: const CircleAvatar(
                backgroundImage: NetworkImage('https://source.unsplash.com/xsGxhtAsfSA/100x100'),
              ),
              body: S2TileChips(
                chipColor: Theme.of(context).primaryColor,
                chipLength: state.valueObject.length,
                chipLabelBuilder: (context, i) {
                  return Text(state.valueObject[i].title);
                },
                chipOnDelete: (i) {
                  setState(() => _smartphone.remove(state.valueObject[i].value));
                },
                // placeholder: Container(),
              ),
            );
          }
        ),
        const Divider(indent: 20),
        SmartSelect<String>.multiple(
          title: 'Car',
          value: _car,
          onChange: (state) => setState(() => _car = state.value),
          choiceItems: S2Choice.listFrom<String, Map>(
            source: choices.cars,
            value: (index, item) => item['value'],
            title: (index, item) => item['title'],
            group: (index, item) => item['brand'],
          ),
          groupConfig: S2GroupConfig(
            enabled: true,
            useSelector: true,
          ),
          modalConfig: S2ModalConfig(
            type: S2ModalType.bottomSheet,
            maxHeightFactor: .7,
          ),
          modalActionsBuilder: (context, state) {
            return [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: state.choiceSelectorAll,
              ),
            ];
          },
          tileBuilder: (context, state) {
            return S2Tile.fromState(
              state,
              isTwoLine: true,
              leading: const CircleAvatar(
                backgroundImage: NetworkImage('https://source.unsplash.com/yeVtxxPxzbw/100x100'),
              ),
            );
          },
          // groupHeaderBuilder: (context, state, group) {
          //   return S2GroupHeader(
          //     style: group.headerStyle.copyWith(
          //       padding: const EdgeInsets.fromLTRB(16, 0, 12, 0),
          //     ),
          //     title: S2Text(
          //       text: group.name,
          //       highlight: state.filter.query,
          //       style: group.headerStyle.textStyle,
          //       highlightColor: group.headerStyle.highlightColor ?? Color(0xFFFFF176),
          //     ),
          //     trailing: state.choiceSelector(group.values)
          //   );
          // },
        ),
        const SizedBox(height: 7),
      ],
    );
  }
}

class ActionButton extends StatelessWidget {

  final Widget label;
  final VoidCallback onTap;

  ActionButton({
    Key key,
    this.label,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: label,
      color: Theme.of(context).primaryColor,
      textColor: Colors.white,
      onPressed: onTap,
    );
  }
}