import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuks_divide/blocs/groups_bloc/bloc/groups_bloc.dart';
import 'package:tuks_divide/blocs/spendings_bloc/bloc/spendings_bloc.dart';
import 'package:tuks_divide/blocs/upload_image_bloc/bloc/upload_image_bloc.dart';
import 'package:tuks_divide/models/group_model.dart';
import 'package:tuks_divide/pages/group_expenses_page/group_expenses_page.dart';

class GroupItem extends StatelessWidget {
  final GroupModel groupData;

  const GroupItem({
    super.key,
    required this.groupData,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          BlocProvider.of<GroupsBloc>(context)
              .add(LoadGroupUsersEvent(group: groupData));
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (context) => GroupExpensesPage(
                    group: groupData,
                  ),
                ),
              )
              .then(
                (value) => BlocProvider.of<SpendingsBloc>(context).add(
                  SpendingsResetBlocEvent(),
                ),
              )
              .then((value) => BlocProvider.of<UploadImageBloc>(context)
                  .add(ResetUploadImageBloc()));
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          child: ListTile(
            title: Text(groupData.groupName),
            // TODO: realizar algún cálculo dependiendo de los datos disponibles
            subtitle: Text(
              "${groupData.description}\n",
              maxLines: 2,
            ),
            leading: CircleAvatar(
                backgroundImage: groupData.groupPicUrl == ""
                    ? const NetworkImage(
                        "https://www.unfe.org/wp-content/uploads/2019/04/SM-placeholder.png")
                    : NetworkImage(groupData.groupPicUrl)),
          ),
        ),
      ),
    );
  }
}
