import 'package:flutter/material.dart';
import 'package:flutter_calendar_example/widgets/calendario_mensal.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exemplo de Calendário',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

// Convertemos para StatefulWidget para poder guardar o estado do dia selecionado.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Variável de estado para guardar a data que o usuário clicou.
  DateTime? _dataSelecionada;

  @override
  Widget build(BuildContext context) {
    final hoje = DateTime.now();
    final anoAtual = hoje.year;
    final mesAtual = hoje.month;

    const nomesDosMeses = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro',
    ];

    final Map<DateTime, Widget> eventosDoMes = {
      DateTime(anoAtual, mesAtual, 5): const Icon(
        Icons.star,
        color: Colors.amber,
        size: 24,
      ),
      DateTime(anoAtual, mesAtual, 13): const Text(
        "TXT",
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
      DateTime(anoAtual, mesAtual, 20): Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text("L1", style: TextStyle(fontSize: 9)),
          Text("L2", style: TextStyle(fontSize: 9)),
        ],
      ),
      DateTime(anoAtual, mesAtual, 22): const Icon(
        Icons.favorite,
        color: Colors.pink,
        size: 24,
      ),
    };

    final Map<DateTime, Color> coresDoMes = {
      DateTime(anoAtual, mesAtual, 1): Colors.blue[100]!,
      DateTime(anoAtual, mesAtual, 7): Colors.red[100]!,
      DateTime(anoAtual, mesAtual, 13): Colors.orange[100]!,
      DateTime(anoAtual, mesAtual, 14): Colors.red[100]!,
      DateTime(anoAtual, mesAtual, 21): Colors.red[100]!,
      DateTime(anoAtual, mesAtual, 22): Colors.green[100]!,
      DateTime(anoAtual, mesAtual, 28): Colors.red[200]!,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Calendário Interativo'),
        backgroundColor: Colors.blueGrey[800],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              '${nomesDosMeses[mesAtual - 1]} de $anoAtual',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Center(
              child: CalendarioMensal(
                ano: anoAtual,
                mes: mesAtual,
                largura: MediaQuery.of(context).size.width / 2,
                conteudoDosDias: eventosDoMes,
                coresDosDias: coresDoMes,
                // Passamos a data selecionada para o widget poder se destacar.
                diaSelecionado: _dataSelecionada,
                // Aqui está a mágica: passamos uma função para o callback.
                onDiaSelecionado: (data) {
                  // Quando um dia é clicado, atualizamos o estado.
                  setState(() {
                    _dataSelecionada = data;
                  });

                  // Opcional: mostrar um feedback rápido.
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Data selecionada: ${data.day}/${data.month}/${data.year}',
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Exibimos a data selecionada na tela.
            Text(
              _dataSelecionada == null
                  ? 'Nenhum dia selecionado'
                  : 'Dia selecionado: ${_dataSelecionada!.day}/${_dataSelecionada!.month}/${_dataSelecionada!.year}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
