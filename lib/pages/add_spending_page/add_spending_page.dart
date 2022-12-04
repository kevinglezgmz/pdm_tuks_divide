import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuks_divide/blocs/me_bloc/bloc/me_bloc.dart';
import 'package:tuks_divide/blocs/spendings_bloc/bloc/spendings_bloc.dart';
import 'package:tuks_divide/blocs/upload_image_bloc/bloc/upload_image_bloc.dart';
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
  late final MeBloc meBloc;

  @override
  void initState() {
    spendingsBloc = BlocProvider.of<SpendingsBloc>(context);
    meBloc = BlocProvider.of<MeBloc>(context);
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

    spendingsBloc.add(
      SpendingUpdateEvent(
        newState: NullableSpendingsUseState(
          payer: meBloc.state.me,
        ),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Añadir gasto'),
          actions: [
            IconButton(
              onPressed: () async {
                await updateSpendingBloc();
                _saveSpending();
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
              _openSpendingDistributionPage();
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

  _openSpendingDistributionPage() async {
    spendingsBloc.add(
      SpendingUpdateEvent(
        newState: NullableSpendingsUseState(
          spendingDescription: descriptionController.text,
          spendingAmount: spendingAmountController.text,
        ),
      ),
    );
    EqualDivideSpendingTabController currEqualCtrl = equalTabController.clone();
    UnequalDivideSpendingTabController currUnequalCtrl =
        unequalTabController.clone();
    PercentageDivideSpendingTabController currPercentageCtrl =
        percentageTabController.clone();
    double totalAmount = double.tryParse(spendingAmountController.text) ?? 0;
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
            onTap: () {
              showSearch<UserModel?>(
                context: context,
                delegate: SelectPayerSearchDelegate(),
              ).then((selectedUser) {
                if (selectedUser == null) {
                  return;
                }
                spendingsBloc.add(
                  SpendingUpdateEvent(
                    newState: NullableSpendingsUseState(
                      payer: selectedUser,
                    ),
                  ),
                );
              });
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
                    UserModel? payer = state.payer ?? meBloc.state.me;
                    String payerName = payer == meBloc.state.me
                        ? 'tí'
                        : state.payer!.displayName ??
                            state.payer!.fullName ??
                            state.payer!.email;
                    return Text(
                      payerName.substring(
                          0, payerName.length > 16 ? 16 : payerName.length),
                      style: const TextStyle(fontSize: 16),
                    );
                  },
                ),
              ),
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
      children: const [
        SizedBox(height: 50),
        Text(
          'Nuevo gasto',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
            onTap: () {
              _showAlertDialog(context);
            },
            child: Ink(
              color: Colors.grey,
              child: BlocBuilder<UploadImageBloc, UploadImageState>(
                builder: (context, state) {
                  if (state is UploadingImageState) {
                    return const SizedBox(
                      height: 148,
                      width: 106,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (state is UploadingSuccessfulState) {
                    return SizedBox(
                      height: 148,
                      width: 106,
                      child: Image.network(
                        BlocProvider.of<UploadImageBloc>(context)
                            .uploadedImageUrl!,
                        fit: BoxFit.cover,
                      ),
                    );
                  }
                  return const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 54,
                      horizontal: 28,
                    ),
                    child: Icon(
                      Icons.add_a_photo_outlined,
                      size: 40,
                    ),
                  );
                },
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

  _saveSpending() {
    if (spendingsBloc.state.isSaving) {
      return;
    }
    final double? spendingAmount =
        double.tryParse(spendingsBloc.state.spendingAmount);
    if (spendingAmount == null) {
      _showDistributionErrorDialog(
        context,
        title: "Monto inválido",
        message: "Debes introducir un monto válido en el gasto.",
      );
      return;
    }
    final String description = spendingsBloc.state.spendingDescription;
    if (description == "") {
      _showDistributionErrorDialog(
        context,
        title: "Descripción faltante",
        message: "Debes ingresar una descripción del gasto realizado.",
      );
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

    if (spendingsBloc.state.spendingPictureUrl == "") {
      _showDistributionErrorDialog(
        context,
        title: "Añade una imagen del gasto",
        message: "Ayuda a tus amigos añadiendo una imagen del gasto.",
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

  Future<void> updateSpendingBloc() async {
    spendingsBloc.add(
      SpendingUpdateEvent(
        newState: NullableSpendingsUseState(
          spendingDescription: descriptionController.text,
          spendingAmount: spendingAmountController.text,
          spendingPictureUrl:
              BlocProvider.of<UploadImageBloc>(context).uploadedImageUrl,
        ),
      ),
    );
    await Future.delayed(const Duration(milliseconds: 1));
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cargar imagen"),
        content: const Text("¿Cómo te gustaría cargar la imagen?"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              BlocProvider.of<UploadImageBloc>(context)
                  .add(const UploadNewImageEvent("groupImg", "gallery"));
            },
            child: Container(
              color: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.all(14),
              alignment: Alignment.center,
              child: const Text(
                "Seleccionar de la galería",
                style: TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              BlocProvider.of<UploadImageBloc>(context)
                  .add(const UploadNewImageEvent("groupImg", "camera"));
            },
            child: Container(
              alignment: Alignment.center,
              color: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.all(14),
              child: const Text(
                "Usar cámara",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
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

class SelectPayerSearchDelegate extends SearchDelegate<UserModel?> {
  SelectPayerSearchDelegate() : super(searchFieldLabel: "Buscar por nombre");

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<UserModel> queryResult = getResults(context);
    return ListView.builder(
      itemCount: queryResult.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return const SizedBox(height: 16);
        }
        UserModel user = queryResult[index - 1];
        return getUserTile(context, user);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<UserModel> queryResult = getResults(context);
    queryResult = queryResult.sublist(
      0,
      queryResult.length > 10 ? 10 : queryResult.length,
    );
    return ListView.builder(
      itemCount: queryResult.length,
      itemBuilder: (BuildContext context, int index) {
        UserModel user = queryResult[index];
        return getUserTile(context, user);
      },
    );
  }

  List<UserModel> getResults(BuildContext context) {
    List<UserModel> membersInGroup =
        BlocProvider.of<SpendingsBloc>(context).state.membersInGroup;
    String queryLC = query.toLowerCase();
    return queryLC == ""
        ? membersInGroup
        : membersInGroup
            .where(
              (element) =>
                  ((element.displayName
                              ?.toLowerCase()
                              .indexOf(queryLC.toLowerCase()) ??
                          -1) >=
                      0) ||
                  ((element.firstName
                              ?.toLowerCase()
                              .indexOf(queryLC.toLowerCase()) ??
                          -1) >=
                      0) ||
                  ((element.lastName
                              ?.toLowerCase()
                              .indexOf(queryLC.toLowerCase()) ??
                          -1) >=
                      0),
            )
            .toList();
  }

  Widget getUserTile(BuildContext context, UserModel user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        child: InkWell(
          onTap: () {
            close(context, user);
          },
          child: ListTile(
            title: Text(user.displayName ?? user.fullName ?? '<Sin Nombre>'),
            leading: CircleAvatar(
              backgroundImage: user.pictureUrl == null || user.pictureUrl == ""
                  ? const NetworkImage(
                      "https://www.unfe.org/wp-content/uploads/2019/04/SM-placeholder.png",
                    )
                  : NetworkImage(user.pictureUrl!),
            ),
          ),
        ),
      ),
    );
  }
}
