import 'package:flutter/material.dart';

class PersonalInformation extends StatefulWidget {
  PersonalInformation({
    Key? key,
  }) : super(key: key);

  static const routeName = '/PersonalInformation';

  @override
  State<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  var data;
  @override
  void didChangeDependencies() {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      data = ModalRoute.of(context)!.settings.arguments;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page'),
      ),
      body: Center(child: data != null ? Text(data) : const Text('Page')),
    );
  }
}
