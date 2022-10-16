import 'package:flutter/material.dart';

class GroupProfileActivityPage extends StatelessWidget {
  const GroupProfileActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actividad de Kevin'),
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const SizedBox(width: double.infinity, height: double.infinity),
          Container(
            height: 128,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [
                  0.1,
                  0.4,
                  0.70,
                  1,
                ],
                colors: [
                  Colors.yellow,
                  Colors.red,
                  Colors.indigo,
                  Colors.teal,
                ],
              ),
            ),
          ),
          const Positioned(
            top: 128 - 48,
            right: 0,
            left: 0,
            child: CircleAvatar(
              radius: 48,
              backgroundColor: Colors.indigo,
              child: Icon(
                Icons.person,
                size: 64,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: 128 + 48,
            right: 0,
            left: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                SizedBox(height: 16),
                Text(
                  'Kevin González',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Debe \$150.58',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Le deben \$25.58',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 284,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  _getActivityDateDivider(),
                  _getActivityTile('Paletas con forma de Mickey',
                      'Kevin realizó un pago de \$10.00'),
                  _getActivityTile(
                      'Compras de ropa', 'Kevin debe \$150.58 a Andrea'),
                  _getActivityTile(
                      'Churros con cajeta', 'Kevin realizó un pago de \$15.58'),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _getActivityDateDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Text(
        'Octubre del 2022',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _getActivityTile(String title, String subtitle) {
    return ListTile(
      leading: SizedBox(
        width: 28,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            Text(
              'oct.',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            Text(
              '13',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      minLeadingWidth: 28,
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Icon(Icons.attach_money),
    );
  }
}
