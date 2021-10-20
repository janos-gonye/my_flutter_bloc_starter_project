import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppSettingsForm extends StatelessWidget {
  const AppSettingsForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Protocol: '),
            _ProtocolInput(),
          ],
        ),
        const _HostnameInput(),
        const _PortInput(),
        const _SubmitButton(),
      ],
    );
  }
}

class _ProtocolInput extends StatelessWidget {
  const _ProtocolInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      onChanged: (protocol) {},
      value: 'http',
      items: <String>['http', 'https']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class _HostnameInput extends StatelessWidget {
  const _HostnameInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (username) {},
      decoration: const InputDecoration(
        labelText: 'hostname',
      ),
    );
  }
}

class _PortInput extends StatelessWidget {
  const _PortInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (username) {},
      decoration: const InputDecoration(
        labelText: 'port',
      ),
      keyboardType: TextInputType.number,
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: const Text('Save'),
    );
  }
}
