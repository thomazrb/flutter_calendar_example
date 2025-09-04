import 'package:flutter/material.dart';

//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// WIDGET PRINCIPAL DO CALENDÁRIO MENSAL
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
class CalendarioMensal extends StatelessWidget {
  //--------------------------------------------------------------------------
  // PARÂMETROS DE ENTRADA (PROPRIEDADES)
  //--------------------------------------------------------------------------

  final int ano;
  final int mes;
  final double largura;
  final Map<DateTime, Widget>? conteudoDosDias;
  final Map<DateTime, Color>? coresDosDias;

  /// [onDiaSelecionado] (NOVO) Uma função de callback que é chamada quando o
  /// usuário clica em um dia. Ela retorna o `DateTime` completo do dia clicado.
  final void Function(DateTime)? onDiaSelecionado;

  /// [diaSelecionado] (NOVO) A data atualmente selecionada. Usado para
  /// fornecer um feedback visual (destaque) no dia clicado.
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
  @override
  Widget build(BuildContext context) {
    final int quantosDiasTemNoMes = DateTime(ano, mes + 1, 0).day;
    final primeiroDiaDoMes = DateTime(ano, mes, 1);
    final int diaDaSemanaQueComeca = (primeiroDiaDoMes.weekday % 7) + 1;

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

    final List<int?> diasParaExibir = _gerarListaDeDias(
      diaDaSemanaQueComeca,
      quantosDiasTemNoMes,
    );
    final double tamanhoDaCelula = largura / 7;

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

  List<int?> _gerarListaDeDias(
    int diaDaSemanaQueComeca,
    int quantosDiasTemNoMes,
  ) {
    final List<int?> dias = [];
    final int diasVaziosNoInicio = diaDaSemanaQueComeca - 1;
    for (int i = 0; i < diasVaziosNoInicio; i++) {
      dias.add(null);
    }
    for (int i = 1; i <= quantosDiasTemNoMes; i++) {
      dias.add(i);
    }
    return dias;
  }
}

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

// A grade interna agora precisa saber o ano e mês para reconstruir a data no clique.
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
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
      ),
      itemCount: dias.length,
      itemBuilder: (context, index) {
        final dia = dias[index];
        if (dia == null) {
          return const SizedBox.shrink();
        }

        final Widget? conteudoDoDia =
            (conteudoDosDias != null && conteudoDosDias!.containsKey(dia))
            ? conteudoDosDias![dia]
            : null;
        final Color corDeFundo =
            (coresDosDias != null && coresDosDias!.containsKey(dia))
            ? coresDosDias![dia]!
            : Colors.grey[200]!;

        // Verifica se este é o dia selecionado para aplicar o destaque.
        final bool isSelecionado =
            diaSelecionado != null &&
            diaSelecionado!.year == ano &&
            diaSelecionado!.month == mes &&
            diaSelecionado!.day == dia;

        //-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
        // MUDANÇA: GestureDetector -> InkWell
        // Usamos Material + InkWell para ter o efeito visual de clique (ripple).
        //-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
        return Material(
          color: Colors
              .transparent, // O Material precisa ser transparente para não cobrir a cor do Container.
          child: InkWell(
            borderRadius: BorderRadius.circular(
              4,
            ), // Para o efeito ripple respeitar a borda.
            // A lógica do onTap é exatamente a mesma de antes.
            onTap: () {
              if (onDiaSelecionado != null) {
                final dataClicada = DateTime(ano, mes, dia);
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
                // Lógica para o destaque visual
                border: isSelecionado
                    ? Border.all(
                        color: Colors.blueGrey[700]!,
                        width: 2.5,
                      ) // Borda de destaque
                    : Border.all(
                        color: Colors.black12,
                        width: 1,
                      ), // Borda padrão
              ),
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
