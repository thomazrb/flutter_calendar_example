# Flutter - Widget de Calendário Mensal Customizado

Um projeto de exemplo que demonstra a criação de um widget de calendário mensal, flexível e reutilizável em Flutter. O objetivo deste repositório é servir como um tutorial passo a passo, resultando em um componente de calendário robusto e fácil de integrar em outros projetos.

## ✨ Funcionalidades

O widget `CalendarioMensal` foi construído com as seguintes funcionalidades em mente:

* **Geração Automática:** Gera o layout do calendário para qualquer mês e ano, calculando automaticamente o dia de início da semana e o número de dias.
* **Conteúdo Customizável:** Permite injetar qualquer widget (Ícones, Textos, etc.) em dias específicos através de um `Map<DateTime, Widget>`.
* **Cores de Fundo Dinâmicas:** Permite colorir o fundo de dias específicos para destacar eventos, feriados ou datas importantes usando um `Map<DateTime, Color>`.
* **Interatividade:** Fornece uma função de *callback* (`onDiaSelecionado`) que retorna a data completa (`DateTime`) quando um dia é clicado.
* **Feedback Visual:** Destaca visualmente o dia que foi selecionado pelo usuário.
* **Design Responsivo:** O layout do calendário se ajusta à largura especificada, tornando-o adaptável a diferentes tamanhos de tela.

## 🚀 Como Usar

Integrar este widget em seu projeto é muito simples.

1. **Copie o Widget:** Copie o arquivo `lib/widgets/calendario_mensal.dart` para a estrutura de pastas do seu projeto Flutter.

2. **Implemente no seu Código:** Importe o widget e utilize-o em sua tela, fornecendo os parâmetros necessários. Abaixo está um exemplo completo de uso em um `StatefulWidget`.

```dart
import 'package:flutter/material.dart';
import 'package:seu_projeto/widgets/calendario_mensal.dart'; // <-- Importe o widget

class MinhaTelaDeCalendario extends StatefulWidget {
  const MinhaTelaDeCalendario({super.key});

  @override
  State<MinhaTelaDeCalendario> createState() => _MinhaTelaDeCalendarioState();
}

class _MinhaTelaDeCalendarioState extends State<MinhaTelaDeCalendario> {
  // Variável para guardar o estado do dia selecionado
  DateTime? _dataSelecionada;

  @override
  Widget build(BuildContext context) {
    final hoje = DateTime.now();

    // Exemplo de mapa de eventos
    final Map<DateTime, Widget> eventos = {
      DateTime(hoje.year, hoje.month, 10): Icon(Icons.star, color: Colors.amber),
      DateTime(hoje.year, hoje.month, 25): Text("Fim!"),
    };

    // Exemplo de mapa de cores
    final Map<DateTime, Color> cores = {
      DateTime(hoje.year, hoje.month, 24): Colors.green[100]!,
      DateTime(hoje.year, hoje.month, 25): Colors.green[100]!,
    };

    return Scaffold(
      appBar: AppBar(title: Text("Exemplo")),
      body: Center(
        child: CalendarioMensal(
          ano: hoje.year,
          mes: hoje.month,
          largura: MediaQuery.of(context).size.width * 0.9, // 90% da largura da tela
          conteudoDosDias: eventos,
          coresDosDias: cores,
          diaSelecionado: _dataSelecionada,
          onDiaSelecionado: (data) {
            setState(() {
              _dataSelecionada = data;
            });
            print('Dia selecionado: $data');
          },
        ),
      ),
    );
  }
}
```
## 🛠️ API do Widget (Parâmetros)

| Parâmetro | Tipo | Obrigatório | Descrição | 
 | ----- | ----- | ----- | ----- | 
| `ano` | `int` | Sim | O ano a ser exibido (ex: `2025`). | 
| `mes` | `int` | Sim | O mês a ser exibido (1 para Janeiro, 12 para Dezembro). | 
| `largura` | `double` | Sim | A largura total que o calendário ocupará na tela. | 
| `conteudoDosDias` | `Map<DateTime, Widget>?` | Não | Um mapa associando datas a widgets para exibir conteúdo customizado nos dias. | 
| `coresDosDias` | `Map<DateTime, Color>?` | Não | Um mapa associando datas a cores para customizar o fundo das células dos dias. | 
| `onDiaSelecionado` | `void Function(DateTime)?` | Não | Função de callback que é chamada com a data (`DateTime`) do dia que foi clicado. | 
| `diaSelecionado` | `DateTime?` | Não | A data atualmente selecionada, usada para aplicar um destaque visual (borda). | 

## 🤝 Contribuições

Este é um projeto de aprendizado e tutorial. Sinta-se à vontade para abrir uma *issue* para relatar bugs ou sugerir melhorias. *Pull requests* também são bem-vindos!

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.