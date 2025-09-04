import 'package:flutter/material.dart';

//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// WIDGET PRINCIPAL DO CALENDÁRIO MENSAL
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
///
/// Este é o widget principal e reutilizável do calendário.
/// Ele é projetado para ser "inteligente", calculando automaticamente
/// a estrutura do mês com base no ano e mês fornecidos.
///
class CalendarioMensal extends StatelessWidget {
  //--------------------------------------------------------------------------
  // PARÂMETROS DE ENTRADA (PROPRIEDADES)
  //--------------------------------------------------------------------------
  // Estes são os "contratos" do widget, as informações que ele precisa
  // receber de quem o está usando para poder funcionar.

  /// O ano que o calendário deve exibir (ex: 2025).
  final int ano;

  /// O mês que o calendário deve exibir (1 para Janeiro, 12 para Dezembro).
  final int mes;

  /// A largura total que o widget do calendário deve ocupar na tela.
  /// Todos os cálculos de tamanho das células são baseados neste valor.
  final double largura;

  /// (Opcional) Um mapa que associa uma data (`DateTime`) a um widget
  /// customizado. Permite "injetar" qualquer tipo de conteúdo (ícones, textos, etc.)
  /// em dias específicos. O widget filtrará automaticamente os eventos
  /// que pertencem ao mês e ano que está sendo exibido.
  final Map<DateTime, Widget>? conteudoDosDias;

  /// (Opcional) Um mapa que associa uma data (`DateTime`) a uma cor de fundo
  /// específica. Ideal para destacar feriados, fins de semana, etc.
  final Map<DateTime, Color>? coresDosDias;

  /// (Opcional) Uma função de "callback" que é executada quando o usuário
  /// clica em um dia. O widget retorna o `DateTime` completo do dia clicado,
  /// permitindo que a tela principal reaja a essa interação.
  final void Function(DateTime)? onDiaSelecionado;

  /// (Opcional) A data que está atualmente selecionada. Este parâmetro é usado
  /// para que o widget possa aplicar um destaque visual (como uma borda diferente)
  /// no dia correspondente, dando um feedback claro ao usuário.
  final DateTime? diaSelecionado;

  //--------------------------------------------------------------------------
  // CONSTRUTOR DO WIDGET
  //--------------------------------------------------------------------------
  const CalendarioMensal({
    super.key,
    required this.ano,
    required this.mes,
    required this.largura,
    this.conteudoDosDias,
    this.coresDosDias,
    this.onDiaSelecionado,
    this.diaSelecionado,
  }) : assert(mes >= 1 && mes <= 12, 'O mês deve ser entre 1 e 12.');

  //--------------------------------------------------------------------------
  // MÉTODO BUILD - O CORAÇÃO DO WIDGET
  //--------------------------------------------------------------------------
  /// O Flutter chama este método toda vez que precisa desenhar o widget na tela.
  /// É aqui que toda a lógica de construção da interface do calendário acontece.
  @override
  Widget build(BuildContext context) {
    // 1. CÁLCULOS DE DATA
    // Usamos a classe DateTime para descobrir tudo o que precisamos sobre o mês.
    // Para saber o último dia do mês N, pedimos o dia "0" do mês N+1.
    final int quantosDiasTemNoMes = DateTime(ano, mes + 1, 0).day;
    final primeiroDiaDoMes = DateTime(ano, mes, 1);
    // A propriedade `weekday` retorna 1 para segunda e 7 para domingo.
    // Ajustamos para o nosso padrão (1=Domingo, 7=Sábado).
    final int diaDaSemanaQueComeca = (primeiroDiaDoMes.weekday % 7) + 1;

    // 2. FILTRAGEM DE DADOS
    // Para manter o widget `_GridDoCalendario` simples, este widget principal
    // assume a responsabilidade de filtrar os eventos e cores, passando para
    // a grade apenas os dados relevantes para o mês e ano atuais.
    final Map<int, Widget> conteudoFiltrado = {};
    if (conteudoDosDias != null) {
      for (final evento in conteudoDosDias!.entries) {
        if (evento.key.year == ano && evento.key.month == mes) {
          conteudoFiltrado[evento.key.day] = evento.value;
        }
      }
    }

    final Map<int, Color> coresFiltradas = {};
    if (coresDosDias != null) {
      for (final cor in coresDosDias!.entries) {
        if (cor.key.year == ano && cor.key.month == mes) {
          coresFiltradas[cor.key.day] = cor.value;
        }
      }
    }

    // 3. PREPARAÇÃO DA LISTA DE DIAS PARA A GRADE
    // Gera a lista completa de itens que a grade vai exibir, incluindo
    // as células vazias (null) no início do mês.
    final List<int?> diasParaExibir = _gerarListaDeDias(
      diaDaSemanaQueComeca,
      quantosDiasTemNoMes,
    );
    final double tamanhoDaCelula = largura / 7;

    // 4. CONSTRUÇÃO DA INTERFACE
    // Monta a estrutura final do widget, combinando o cabeçalho e a grade.
    return SizedBox(
      width: largura,
      child: Column(
        children: [
          _CabecalhoDiasDaSemana(tamanhoDaCelula: tamanhoDaCelula),
          const SizedBox(height: 4),
          _GridDoCalendario(
            ano: ano,
            mes: mes,
            dias: diasParaExibir,
            tamanhoDaCelula: tamanhoDaCelula,
            conteudoDosDias: conteudoFiltrado,
            coresDosDias: coresFiltradas,
            onDiaSelecionado: onDiaSelecionado,
            diaSelecionado: diaSelecionado,
          ),
        ],
      ),
    );
  }

  /// Método auxiliar para criar a lista de dias a serem exibidos na grade.
  /// Inclui os espaços vazios (representados por `null`) antes do dia 1.
  List<int?> _gerarListaDeDias(
    int diaDaSemanaQueComeca,
    int quantosDiasTemNoMes,
  ) {
    final List<int?> dias = [];
    // O número de dias vazios é `diaDaSemanaQueComeca - 1`.
    // Ex: Se começa no Domingo (1), não há dias vazios. Se começa na Segunda (2), há 1 dia vazio.
    final int diasVaziosNoInicio = diaDaSemanaQueComeca - 1;
    for (int i = 0; i < diasVaziosNoInicio; i++) {
      dias.add(null);
    }
    // Adiciona os números de 1 até o último dia do mês.
    for (int i = 1; i <= quantosDiasTemNoMes; i++) {
      dias.add(i);
    }
    return dias;
  }
}

//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// WIDGET INTERNO: CABEÇALHO DOS DIAS DA SEMANA
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
class _CabecalhoDiasDaSemana extends StatelessWidget {
  final double tamanhoDaCelula;
  const _CabecalhoDiasDaSemana({required this.tamanhoDaCelula});

  @override
  Widget build(BuildContext context) {
    const dias = ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'];
    return Row(
      children: dias.map((dia) {
        return SizedBox(
          width: tamanhoDaCelula,
          child: Text(
            dia,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        );
      }).toList(),
    );
  }
}

//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// WIDGET INTERNO: A GRADE DO CALENDÁRIO
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
/// Este widget é responsável por desenhar a grade de dias.
/// Ele é "burro" de propósito: apenas desenha o que recebe, sem fazer cálculos de data.
class _GridDoCalendario extends StatelessWidget {
  final int ano;
  final int mes;
  final List<int?> dias;
  final double tamanhoDaCelula;
  final Map<int, Widget>? conteudoDosDias;
  final Map<int, Color>? coresDosDias;
  final void Function(DateTime)? onDiaSelecionado;
  final DateTime? diaSelecionado;

  const _GridDoCalendario({
    required this.ano,
    required this.mes,
    required this.dias,
    required this.tamanhoDaCelula,
    this.conteudoDosDias,
    this.coresDosDias,
    this.onDiaSelecionado,
    this.diaSelecionado,
  });

  @override
  Widget build(BuildContext context) {
    // Usamos `GridView.builder` por ser a forma mais eficiente de construir grades,
    // especialmente se a lista de itens for muito grande.
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7, // Sempre 7 dias por semana.
      ),
      itemCount: dias.length,
      itemBuilder: (context, index) {
        final dia = dias[index];

        // Se o dia for nulo, significa que é uma célula vazia no início do mês.
        // Retornamos um widget vazio para não ocupar espaço.
        if (dia == null) {
          return const SizedBox.shrink();
        }

        // Busca o conteúdo e a cor para o dia atual nos mapas filtrados.
        final Widget? conteudoDoDia =
            (conteudoDosDias != null && conteudoDosDias!.containsKey(dia))
            ? conteudoDosDias![dia]
            : null;
        final Color corDeFundo =
            (coresDosDias != null && coresDosDias!.containsKey(dia))
            ? coresDosDias![dia]!
            : Colors.grey[200]!;

        // Verifica se este é o dia selecionado para aplicar o destaque visual.
        final bool isSelecionado =
            diaSelecionado != null &&
            diaSelecionado!.year == ano &&
            diaSelecionado!.month == mes &&
            diaSelecionado!.day == dia;

        // Usamos `Material` + `InkWell` para ter o efeito de clique (ripple).
        // O `InkWell` é semanticamente melhor que o `GestureDetector` para botões.
        return Material(
          color: Colors
              .transparent, // Transparente para não cobrir a cor do `Container` abaixo.
          child: InkWell(
            borderRadius: BorderRadius.circular(
              4,
            ), // O ripple respeitará a borda arredondada.
            onTap: () {
              // Se a função de callback foi fornecida...
              if (onDiaSelecionado != null) {
                // ...recriamos o objeto `DateTime` completo...
                final dataClicada = DateTime(ano, mes, dia);
                // ...e chamamos o callback, "devolvendo" a data para a tela principal.
                onDiaSelecionado!(dataClicada);
              }
            },
            child: Container(
              height: tamanhoDaCelula,
              width: tamanhoDaCelula,
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: corDeFundo,
                borderRadius: BorderRadius.circular(4),
                // Lógica da borda: se for o dia selecionado, usa uma borda de destaque.
                border: isSelecionado
                    ? Border.all(color: Colors.blueGrey[700]!, width: 2.5)
                    : Border.all(color: Colors.black12, width: 1),
              ),
              // `Stack` é perfeito para sobrepor widgets.
              // Usamos para posicionar o número do dia no canto e o conteúdo no centro.
              child: Stack(
                children: [
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Text(
                      dia.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  // Se houver um widget de conteúdo para este dia, o exibe no centro.
                  if (conteudoDoDia != null) Center(child: conteudoDoDia),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
