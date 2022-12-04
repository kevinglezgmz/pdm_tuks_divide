import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuks_divide/blocs/spending_detail_bloc/bloc/spending_detail_bloc.dart';
import 'package:tuks_divide/components/image_viewer.dart';
import 'package:tuks_divide/models/spending_model.dart';
import 'package:tuks_divide/models/user_model.dart';
import 'package:tuks_divide/pages/spending_detail_page/participants_list.dart';
import 'package:intl/intl.dart';

class SpendingDetailPage extends StatelessWidget {
  final dateFormat = DateFormat.MMMM('es');
  SpendingDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SpendingDetailBloc, SpendingDetailState>(
        builder: (context, state) {
          if (state is SpendingLoadedDetailState) {
            final date = state.spending.createdAt.toDate();
            return Scaffold(
                appBar: AppBar(
                  title: const Text("Detalle de gasto"),
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                      child: Text(
                        "Total: \$${state.spending.amount}",
                        style: const TextStyle(
                            fontSize: 36, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                      child: Text(
                        "Concepto: ${state.spending.description}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 2, 0, 15),
                      child: Text(
                        " - Distribuido en ${SpendingModel.distributionTypeText(state.spending.distributionType)} - ",
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 2, 0, 20),
                      child: Column(
                        children: [
                          Text(
                            "Agregado por ${state.addedBy.displayName ?? state.addedBy.fullName ?? "<No Name>"}",
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Pagado por ${_getPaidByName(state.spending.paidBy, state.participants)}",
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Fecha: ${date.day} de ${dateFormat.format(date)} del ${date.year}",
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 2, 0, 5),
                      child: Text(
                        "Participantes",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ParticipantsList(
                            participantsData: state.participants),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 2, 0, 5),
                      child: Text(
                        "Comprobante del gasto:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Material(
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(145, 10, 145, 10),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ImageViewerPage(
                                      imageUrl: state.spending.spendingPic ==
                                                  null ||
                                              state.spending.spendingPic == ""
                                          ? "https://www.unfe.org/wp-content/uploads/2019/04/SM-placeholder.png"
                                          : state.spending.spendingPic!),
                                ),
                              );
                            },
                            child: state.spending.spendingPic == null ||
                                    state.spending.spendingPic == ""
                                ? Ink.image(
                                    height: double.infinity,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    image: const NetworkImage(
                                      "https://www.unfe.org/wp-content/uploads/2019/04/SM-placeholder.png",
                                    ))
                                : Ink.image(
                                    height: double.infinity,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        state.spending.spendingPic!),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                ));
          }
          if (state is SpendingLoadingDetailState) {
            return Scaffold(
                appBar: AppBar(
                  title: const Text("Detalle de gasto"),
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Center(
                      child: CircularProgressIndicator(),
                    )
                  ],
                ));
          }
          return Scaffold(
              appBar: AppBar(
                title: const Text("Detalle de gasto"),
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Center(
                    child: Text("Ups! No encontramos el gasto"),
                  )
                ],
              ));
        },
        listener: (context, state) {});
  }

  String _getPaidByName(DocumentReference<Map<String, dynamic>> paidBy,
      List<UserModel> participants) {
    final userWhoPaid = participants
        .where((participant) => participant.uid == paidBy.id)
        .toList();
    final userName = userWhoPaid[0].displayName ??
        (userWhoPaid[0].firstName != null && userWhoPaid[0].lastName != null
            ? "${userWhoPaid[0].firstName} ${userWhoPaid[0].lastName}"
            : "<No Name>");
    return userName;
  }
}
