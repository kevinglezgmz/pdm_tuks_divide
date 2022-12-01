import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuks_divide/blocs/spendings_bloc/bloc/spendings_bloc.dart';
import 'package:tuks_divide/models/spending_model.dart';
import 'package:tuks_divide/models/user_model.dart';
import 'package:tuks_divide/pages/divide_spending_page/divide_spending_page.dart';
import 'package:tuks_divide/utils/text_input_utils.dart';

class AddSpendingPage extends StatefulWidget {
  const AddSpendingPage({
    super.key,
  });

  @override
  State<AddSpendingPage> createState() => _AddSpendingPageState();
}

class _AddSpendingPageState extends State<AddSpendingPage> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController spendingAmountController =
      TextEditingController();

  late EqualDivideSpendingTabController equalTabController;
  late UnequalDivideSpendingTabController unequalTabController;
  late PercentageDivideSpendingTabController percentageTabController;
  late final SpendingsBloc spendingsBloc;

  @override
  void initState() {
    spendingsBloc = BlocProvider.of<SpendingsBloc>(context);
    equalTabController = EqualDivideSpendingTabController(
      controllers: Map.fromEntries(
        spendingsBloc.state.userToEqualDistributionAmount.entries,
      ),
    );
    unequalTabController = UnequalDivideSpendingTabController(
      controllers: spendingsBloc.emptyUserToTextEditingControllerMap,
    );
    percentageTabController = PercentageDivideSpendingTabController(
      controllers: spendingsBloc.emptyUserToTextEditingControllerMap,
    );
    descriptionController.addListener(
      () {
        spendingsBloc.add(
          SpendingUpdateEvent(
            newState: NullableSpendingsUseState(
              spendingDescription: descriptionController.text,
            ),
          ),
        );
      },
    );
    spendingAmountController.addListener(
      () {
        spendingsBloc.add(
          SpendingUpdateEvent(
            newState: NullableSpendingsUseState(
              spendingAmount: spendingAmountController.text,
            ),
          ),
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir gasto'),
        actions: [
          IconButton(
            onPressed: () {
              _saveSpending(context);
            },
            icon: const Icon(
              Icons.check,
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<SpendingsBloc, SpendingsUseState>(
          listener: (context, state) {
            if (state.saved) {
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            if (state.isSaving) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                _getParticipantsHeader(),
                _getInputsSection(),
                const SizedBox(height: 16),
                _getPaidBySection(),
                const SizedBox(height: 16),
                _getDistributionSection(context),
                const SizedBox(
                  height: 64,
                ),
                _getAddImageButton(),
              ],
            );
          },
        ),
      ),
    );
  }

  Center _getDistributionSection(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'dividido en: ',
            style: TextStyle(fontSize: 16),
          ),
          InkWell(
            onTap: () {
              _openSpendingDistributionPage(context);
            },
            child: Ink(
              color: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 6,
                ),
                child: BlocBuilder<SpendingsBloc, SpendingsUseState>(
                  builder: (context, state) {
                    return Text(
                      SpendingModel.distributionTypeText(
                          state.spendingDistributionType),
                      style: const TextStyle(fontSize: 16),
                    );
                  },
                ),
              ),
            ),
          ),
          const Text(
            ' .',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  void _openSpendingDistributionPage(BuildContext context) {
    EqualDivideSpendingTabController currEqualCtrl = equalTabController.clone();
    UnequalDivideSpendingTabController currUnequalCtrl =
        unequalTabController.clone();
    PercentageDivideSpendingTabController currPercentageCtrl =
        percentageTabController.clone();
    double totalAmount =
        double.tryParse(spendingsBloc.state.spendingAmount) ?? 0;
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => DivideSpendingPage(
          initialDistributionType: spendingsBloc.state.spendingDistributionType,
          totalAmount: totalAmount,
          equalTabController: equalTabController,
          percentageTabController: percentageTabController,
          unequalTabController: unequalTabController,
        ),
      ),
    )
        .then((value) {
      if (value is! DistributionType) {
        setState(() {
          equalTabController = currEqualCtrl;
          unequalTabController = currUnequalCtrl;
          percentageTabController = currPercentageCtrl;
        });
        return;
      }
      _updateSpendingsBlocState(
        currEqualCtrl,
        currUnequalCtrl,
        totalAmount,
        currPercentageCtrl,
        value,
      );
    });
  }

  void _updateSpendingsBlocState(
    EqualDivideSpendingTabController currEqualCtrl,
    UnequalDivideSpendingTabController currUnequalCtrl,
    double totalAmount,
    PercentageDivideSpendingTabController currPercentageCtrl,
    DistributionType value,
  ) {
    spendingsBloc.add(
      SpendingUpdateEvent(
        newState: NullableSpendingsUseState(
          userToEqualDistributionAmount:
              equalTabController.isValidDistribution()
                  ? equalTabController.controllers
                  : currEqualCtrl.controllers,
          userToUnEqualDistributionAmount:
              unequalTabController.isValidDistribution(totalAmount)
                  ? unequalTabController.currentDistribution()
                  : currUnequalCtrl.currentDistribution(),
          userToPercentDistributionAmount:
              percentageTabController.isValidDistribution()
                  ? percentageTabController.currentDistribution(
                      totalAmount > 0 ? totalAmount : -1,
                    )
                  : currPercentageCtrl.currentDistribution(
                      totalAmount > 0 ? totalAmount : -1,
                    ),
          spendingDistributionType: value,
        ),
      ),
    );
  }

  Center _getPaidBySection() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Gasto pagado por: ',
            style: TextStyle(fontSize: 16),
          ),
          InkWell(
            onTap: () {},
            child: Ink(
              color: Colors.grey,
              child: const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 6,
                  ),
                  child: Text(
                    'tí',
                    style: TextStyle(fontSize: 16),
                  )),
            ),
          )
        ],
      ),
    );
  }

  Column _getInputsSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(40, 32, 40, 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(
                Icons.receipt_long_outlined,
                size: 36,
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: TextFormField(
                  controller: descriptionController,
                  style: const TextStyle(fontSize: 16),
                  decoration: const InputDecoration(
                    hintText: 'Introduce una descripción',
                    hintStyle: TextStyle(fontSize: 16),
                    contentPadding: EdgeInsets.only(top: 16),
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(40, 0, 40, 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(
                Icons.attach_money,
                size: 36,
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: TextFormField(
                  controller: spendingAmountController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 20),
                  inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
                  decoration: const InputDecoration(
                    hintText: '0.00',
                    hintStyle: TextStyle(fontSize: 20),
                    contentPadding: EdgeInsets.only(top: 14),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _getParticipantsHeader() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: const [
            Text(
              'Gasto hecho por tí y: ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              'Selecciona más integrantes',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
        const Text(
          'que participaron en el gasto',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ],
    );
  }

  Center _getAddImageButton() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {},
            child: Ink(
              color: Colors.grey,
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 28,
                  horizontal: 28,
                ),
                child: Icon(
                  Icons.add_a_photo_outlined,
                  size: 40,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Añadir imagen del gasto',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  _saveSpending(BuildContext context) {
    if (spendingsBloc.state.isSaving) {
      return;
    }
    final double? spendingAmount =
        double.tryParse(spendingsBloc.state.spendingAmount);
    if (spendingAmount == null) {
      return;
    }
    DistributionType distributionType =
        spendingsBloc.state.spendingDistributionType;
    if (distributionType == DistributionType.equal &&
        !equalTabController.isValidDistribution()) {
      _showDistributionErrorDialog(
        context,
        title: "Error en la distribución",
        message:
            "Debes seleccionar al menos una persona para distribuir el gasto.",
      );
      return;
    }
    if (distributionType == DistributionType.unequal &&
        !unequalTabController.isValidDistribution(spendingAmount)) {
      _showDistributionErrorDialog(
        context,
        title: "Error en la distribución",
        message: "Los montos introducidos no coinciden con el total del gasto.",
      );
      return;
    }
    if (distributionType == DistributionType.percentage &&
        !percentageTabController.isValidDistribution()) {
      _showDistributionErrorDialog(
        context,
        title: "Error en la distribución",
        message:
            "La distribución de los porcentajes no suma el cien por ciento.",
      );
      return;
    }
    spendingsBloc.add(const SaveSpendingEvent());
  }

  void _showDistributionErrorDialog(BuildContext context,
      {required String title, required String message}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Aceptar"),
          )
        ],
      ),
    );
  }
}

class UnequalDivideSpendingTabController {
  Map<UserModel, TextEditingController> controllers;
  UnequalDivideSpendingTabController({
    required this.controllers,
  });

  Map<UserModel, double?> currentDistribution() => Map.fromEntries(
        controllers.entries.map(
          (userControllerEntry) => MapEntry(
            userControllerEntry.key,
            double.tryParse(userControllerEntry.value.text),
          ),
        ),
      );

  UnequalDivideSpendingTabController clone() =>
      UnequalDivideSpendingTabController(
        controllers: Map.fromEntries(
          controllers.entries.map((entry) => MapEntry(
              entry.key, TextEditingController(text: entry.value.text))),
        ),
      );

  bool isValidDistribution(double totalAmount) =>
      totalAmount ==
      controllers.values
          .map((controller) => double.tryParse(controller.text) ?? 0)
          .reduce((value, element) => value + element);

  double totalValueOfDistribution() => controllers.values
      .map((controller) => double.tryParse(controller.text) ?? 0)
      .reduce((value, element) => value + element);
}

class PercentageDivideSpendingTabController {
  Map<UserModel, TextEditingController> controllers;
  PercentageDivideSpendingTabController({
    required this.controllers,
  });

  Map<UserModel, double?> currentDistribution(double totalAmount) =>
      Map.fromEntries(
        controllers.entries.map(
          (userControllerEntry) => MapEntry(
            userControllerEntry.key,
            double.tryParse(
              userControllerEntry.value.text,
            ),
          ),
        ),
      );

  PercentageDivideSpendingTabController clone() =>
      PercentageDivideSpendingTabController(
        controllers: Map.fromEntries(
          controllers.entries.map((entry) => MapEntry(
              entry.key, TextEditingController(text: entry.value.text))),
        ),
      );

  bool isValidDistribution() =>
      100 ==
      controllers.values
          .map((controller) => double.tryParse(controller.text) ?? 0)
          .reduce((value, element) => value + element);

  double accumulatedPercent() => controllers.values
      .map((controller) => double.tryParse(controller.text) ?? 0)
      .reduce((value, element) => value + element);
}

class EqualDivideSpendingTabController {
  Map<UserModel, bool> controllers;
  EqualDivideSpendingTabController({
    required this.controllers,
  });

  EqualDivideSpendingTabController clone() => EqualDivideSpendingTabController(
        controllers: Map.fromEntries(
          controllers.entries.map((entry) => MapEntry(entry.key, entry.value)),
        ),
      );

  bool isValidDistribution() =>
      controllers.values.reduce((value, element) => value || element);

  int numberOfParticipants() =>
      controllers.values.where((value) => value == true).length;

  bool allParticipantsSelected() =>
      controllers.values.reduce((value, element) => value && element);
}
