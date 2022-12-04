import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuks_divide/blocs/groups_bloc/bloc/groups_bloc.dart';
import 'package:tuks_divide/blocs/payments_bloc/bloc/payments_repository.dart';
import 'package:tuks_divide/blocs/upload_image_bloc/bloc/upload_image_bloc.dart';
import 'package:tuks_divide/models/group_model.dart';
import 'package:tuks_divide/models/user_model.dart';
import 'package:tuks_divide/utils/text_input_utils.dart';

class PayDebtPage extends StatefulWidget {
  final UserModel sender;
  final UserModel receiver;
  final GroupModel group;
  const PayDebtPage({
    super.key,
    required this.sender,
    required this.receiver,
    required this.group,
  });

  @override
  State<PayDebtPage> createState() => _PayDebtPageState();
}

class _PayDebtPageState extends State<PayDebtPage> {
  final TextEditingController _moneyController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir pago'),
        actions: [
          IconButton(
            onPressed: () {
              double? amount = double.tryParse(_moneyController.text);
              if (amount == null || amount == 0) {
                _showDetailsErrorDialog(context,
                    title: "Monto no válido",
                    message: "Por favor introduce un monto de pago válido.");
                return;
              }
              if (_descriptionController.text == "") {
                _showDetailsErrorDialog(context,
                    title: "Concepto de pago faltante",
                    message: "Por favor introduce un concepto para el pago.");
                return;
              }
              String? picture =
                  BlocProvider.of<UploadImageBloc>(context).uploadedImageUrl;
              if (picture == null || picture == "") {
                _showDetailsErrorDialog(
                  context,
                  title: "Añade una imagen del pago",
                  message:
                      "Ayuda a ${widget.receiver.displayName ?? widget.receiver.fullName ?? '<Sin Nombre>'} añadiendo una imagen del pago que realizaste.",
                );
                return;
              }
              RepositoryProvider.of<PaymentsRepository>(context)
                  .addPaymentDetail(
                amount,
                _descriptionController.text,
                widget.sender,
                widget.receiver,
                picture,
                widget.group,
              )
                  .then((value) {
                if (value != null) {
                  Navigator.of(context).pop();
                }
              });
            },
            icon: const Icon(
              Icons.check,
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: widget.sender.pictureUrl == null ||
                        widget.sender.pictureUrl == ""
                    ? const NetworkImage(
                        "https://www.unfe.org/wp-content/uploads/2019/04/SM-placeholder.png")
                    : NetworkImage(widget.sender.pictureUrl!),
                radius: 48,
              ),
              const SizedBox(width: 16),
              const Icon(
                Icons.arrow_forward,
                size: 58,
              ),
              const SizedBox(width: 16),
              CircleAvatar(
                backgroundImage: widget.receiver.pictureUrl == null ||
                        widget.receiver.pictureUrl == ""
                    ? const NetworkImage(
                        "https://www.unfe.org/wp-content/uploads/2019/04/SM-placeholder.png")
                    : NetworkImage(widget.receiver.pictureUrl!),
                radius: 48,
              ),
            ],
          ),
          const SizedBox(height: 36),
          Text(
            'Registrando pago a ${widget.receiver.displayName ?? widget.receiver.fullName ?? '<Sin Nombre>'}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 24),
          Container(
            margin: const EdgeInsets.fromLTRB(64, 0, 64, 0),
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
                    controller: _descriptionController,
                    style: const TextStyle(fontSize: 16),
                    decoration: const InputDecoration(
                      hintText: 'Concepto del pago',
                      hintStyle: TextStyle(fontSize: 16),
                      contentPadding: EdgeInsets.only(top: 16),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.fromLTRB(64, 0, 64, 0),
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
                    controller: _moneyController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontSize: 20),
                    inputFormatters: [
                      DecimalTextInputFormatter(decimalRange: 2)
                    ],
                    decoration: const InputDecoration(
                      hintText: '0.00',
                      hintStyle: TextStyle(fontSize: 20),
                      contentPadding: EdgeInsets.only(top: 14),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 48),
          _getAddImageButton(),
          const SizedBox(height: 40),
        ],
      ),
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

  void _showDetailsErrorDialog(
    BuildContext context, {
    required String title,
    required String message,
  }) {
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
