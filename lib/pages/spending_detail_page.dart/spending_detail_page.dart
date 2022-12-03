import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuks_divide/blocs/spending_detail_bloc/bloc/spending_detail_bloc.dart';
import 'package:tuks_divide/models/user_model.dart';
import 'package:tuks_divide/pages/spending_detail_page.dart/participants_list.dart';

class SpendingDetailPage extends StatelessWidget {
  const SpendingDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SpendingDetailBloc, SpendingDetailState>(
        builder: (context, state) {
          if (state is SpendingLoadedDetailState) {
            return Scaffold(
                appBar: AppBar(
                  title: const Text("Detalle de gasto"),
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                      child: Text(
                        state.spending.description,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 2, 0, 15),
                      child: Text(
                        "Total \$${state.spending.amount}",
                        style: const TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 2, 0, 20),
                      child: Column(
                        children: [
                          Text(
                            "Agregado por ${state.addedBy.displayName ?? state.addedBy.fullName ?? "<No Name>"}",
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "Pagado por ${_getPaidByName(state.spending.paidBy, state.participants)}",
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
                    ParticipantsList(participantsData: state.participants),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 2, 0, 5),
                      child: Text(
                        "Comprobante de gasto",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 30),
                        height: 325,
                        width: 400,
                        child: state.spending.spendingPic == null ||
                                state.spending.spendingPic == ""
                            ? Image.network(
                                "https://www.unfe.org/wp-content/uploads/2019/04/SM-placeholder.png",
                                fit: BoxFit.fill)
                            : Image.network(state.spending.spendingPic!,
                                fit: BoxFit.fill)),
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
