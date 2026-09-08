# 🏋️ IronLog — Treino & Progresso

App Flutter de **acompanhamento de treinos de academia**: monte seus treinos
A/B/C, registre séries e cargas, acompanhe a evolução do volume em gráfico e
veja um **teste A/B real** rodando dentro do app.

Projeto acadêmico que integra **Flutter**, **Teste A/B**, **TDD** e
**CI/CD** (Integração Contínua + Entrega/Implantação Contínua) com GitHub.


![CI](https://github.com/Gabriel-Ferrarez/IronLog/actions/workflows/ci.yml/badge.svg)
![CD](https://github.com/Gabriel-Ferrarez/IronLog/actions/workflows/cd.yml/badge.svg)

---

## 📌 Índice

- [Tema e viabilidade](#-tema-e-viabilidade)
- [Funcionalidades](#-funcionalidades)
- [Teste A/B](#-teste-ab)
- [TDD — Desenvolvimento orientado por testes](#-tdd--desenvolvimento-orientado-por-testes)
- [CI/CD](#-cicd)
- [Arquitetura](#-arquitetura)
- [Como rodar](#-como-rodar)
- [Estrutura de pastas](#-estrutura-de-pastas)
- [Divisão de tarefas (4 integrantes)](#-divisão-de-tarefas-4-integrantes)
- [Roteiro de apresentação](#-roteiro-de-apresentação)

---

## 🎯 Tema e viabilidade

Academias são um domínio **familiar e visual**: todo mundo entende "treino A,
treino B", "séries × repetições", "evolução de carga". Isso torna a demo fácil
de apresentar e o produto tangível.

O foco é **Treino & Progresso**: o usuário registra o que fez e o app mostra a
evolução — a mesma proposta de apps reais (Strong, Hevy, Gymrats), porém
enxuta e 100% offline (sem depender de servidor), o que garante uma
apresentação sem imprevistos de rede.

## ✨ Funcionalidades

- **Início (dashboard):** treino do dia, sequência de dias (streak), volume
  total e treinos na semana.
- **Meus treinos:** treinos A, B e C prontos, com exercícios e metas.
- **Catálogo de exercícios:** busca por nome e filtro por grupo muscular.
- **Registrar sessão:** adicione séries (repetições × carga), veja o volume
  somando em tempo real e conclua o treino.
- **Progresso:** gráfico de evolução do volume + histórico de sessões.
- **Experimento A/B:** painel com exposições, conversões e taxa de conversão
  de cada variante, atualizado ao vivo.
- **Persistência local:** tudo é salvo no dispositivo (SharedPreferences).

## 🧪 Teste A/B

O app roda um experimento **de verdade** — não é apenas uma tela decorativa.

**Hipótese:** _"Um resumo compacto com barra de incentivo (variante B) leva mais
usuários a iniciar o treino do que um card grande com botão (variante A)."_

- **Experimento:** `home_cta_layout` (definido em `lib/core/ab/experiments.dart`).
- **Variante A (controle):** card-herói com botão "Iniciar treino de hoje".
- **Variante B (tratamento):** resumo compacto + barra fixa "Mantenha a
  sequência! Comece agora."
- **Métrica de conversão:** o usuário tocar em "Iniciar treino".

### Como a variante é escolhida

A atribuição é **determinística** (não é sorteio): calculamos um hash estável
do `id do usuário + chave do experimento` e o convertemos em um número no
intervalo `[0, 1)`. Se cair abaixo do peso da variante B, o usuário recebe B;
senão, A.

```
bucket = hash("home_cta_layout:<userId>") / 2^32   // ∈ [0, 1)
variante = bucket < weightB ? B : A
```

Vantagens: o mesmo usuário **sempre** vê a mesma variante (experiência
consistente) e o comportamento é **100% testável** — sem aleatoriedade, os
testes verificam a divisão exata e os casos de borda (`weightB = 0` → sempre A,
`weightB = 1` → sempre B).

O código-fonte:
`lib/core/ab/` → `hashing.dart`, `ab_test_service.dart`, `ab_analytics.dart`.

> 💡 **Na apresentação:** abra a aba **A/B** e toque em **"Simular 100
> usuários"** para ver as métricas populando e a variante vencedora aparecendo.

## ✅ TDD — Desenvolvimento orientado por testes

O núcleo do app foi escrito guiado por testes: a lógica de negócio é **pura**
(sem Flutter, sem I/O), então cada regra tem um teste rápido e direto.

- **+50 testes** cobrindo A/B, modelos de domínio, estatísticas, repositórios,
  view models e telas.
- Injeção de dependência via a interface `KeyValueStore`, com uma implementação
  **em memória** para testes — repositórios são testados sem plugins.
- Testes de **widget** validam a interface (variante A/B renderizada, busca do
  catálogo, conversão ao tocar no botão).

```bash
# Rodar todos os testes
flutter test

# Com relatório de cobertura (gera coverage/lcov.info)
flutter test --coverage
```

Organização em `test/` espelha `lib/`:

| Camada        | Arquivos de teste                                          |
|---------------|------------------------------------------------------------|
| A/B           | `hashing_test`, `ab_test_service_test`, `ab_analytics_test`|
| Domínio       | `exercise_test`, `workout_test`, `session_test`, `stats_test` |
| Dados         | `key_value_store_test`, `workout_repository_test`, `session_repository_test` |
| View models   | `home_view_model_test`, `progress_view_model_test`, `session_view_model_test` |
| Widgets       | `home_screen_test`, `catalog_screen_test`                  |

## 🔄 CI/CD

Automação via **GitHub Actions** (`.github/workflows/`):

### `ci.yml` — Integração Contínua (a cada push e Pull Request)
1. Instala o Flutter.
2. `flutter pub get`
3. `dart format --set-exit-if-changed` (garante formatação padrão).
4. `flutter analyze` (análise estática / lint).
5. `flutter test --coverage` (roda todos os testes).
6. Publica o relatório de cobertura como artefato.

> Assim, **nenhum código quebrado entra na branch principal** — o PR só é
> mergeável se o CI passar.

### `cd.yml` — Entrega/Implantação Contínua (ao dar merge na `main`)
1. Roda os testes de novo (gate de qualidade).
2. **Build Web** e **deploy automático no GitHub Pages** → o app fica no ar.
3. **Build do APK Android** publicado como artefato para download.

Fluxo completo:

```
push/PR ──▶ CI (lint + testes) ──▶ merge na main ──▶ CD (deploy web + APK)
```

## 🏛️ Arquitetura

Camadas separadas por responsabilidade (facilita testes e divisão de tarefas):

```
UI (telas / widgets)         features/**  → Flutter
   │  usa
View Models (estado)         *_view_model.dart, app_state.dart → ChangeNotifier
   │  usa
Domínio (regras puras)       domain/**  → sem Flutter, 100% testável
   │  usa
Dados (persistência)         data/**    → KeyValueStore (SharedPreferences / memória)

Transversal:  core/ab/**  (framework de Teste A/B)   core/theme/**  (tema)
```

Gerência de estado com **Provider** (`ChangeNotifier`). Sem backend: os dados
são persistidos localmente via **SharedPreferences**.

## 🚀 Como rodar

Pré-requisito: [Flutter](https://docs.flutter.dev/get-started/install) instalado
(canal `stable`).

```bash
flutter pub get

# Web (Chrome) — recomendado para a demo
flutter run -d chrome

# Windows desktop
flutter run -d windows

# Android (emulador ou celular conectado)
flutter run
```

Gerar builds:

```bash
flutter build web       # site em build/web
flutter build apk       # APK em build/app/outputs/flutter-apk/
```

## 📁 Estrutura de pastas

```
lib/
├── main.dart                 # bootstrap: carrega dados, injeta providers
├── app.dart                  # MaterialApp + tema + Providers
├── core/
│   ├── ab/                   # 🧪 framework de Teste A/B
│   └── theme/                # tema visual (dark + verde-limão)
├── domain/
│   ├── models/               # Exercise, Workout, Session (regras puras)
│   └── stats.dart            # 1RM (Epley), volume
├── data/                     # KeyValueStore + repositórios
├── features/                 # telas + view models por funcionalidade
│   ├── home/                 # dashboard (superfície do A/B)
│   ├── workouts/  catalog/   session/  progress/  ab_dashboard/
│   └── shell/                # navegação inferior
└── widgets/                  # componentes reutilizáveis

test/                         # espelha lib/ (TDD)
.github/workflows/            # ci.yml + cd.yml
```

## 👥 Divisão de tarefas (4 integrantes)

Sugestão alinhada às camadas — cada pessoa tem uma frente clara e testável:

| # | Integrante | Frente | Entregáveis |
|---|------------|--------|-------------|
| 1 | **Domínio & Testes** | `domain/**`, `data/**` | Modelos, estatísticas, repositórios + seus testes (TDD) |
| 2 | **Teste A/B** | `core/ab/**`, `features/ab_dashboard/**` | Framework A/B, painel e testes do experimento |
| 3 | **Front-end / UX** | `features/**`, `core/theme/**`, `widgets/**` | Telas, tema, navegação, polimento visual |
| 4 | **CI/CD & Infra** | `.github/workflows/**`, GitHub, persistência | Workflows, GitHub Pages, releases, README |

> Todos participam da **apresentação**. Use **Issues** e **Pull Requests** no
> GitHub para dividir e revisar o trabalho — isso também evidencia o uso de CI
> (cada PR dispara os testes).

## 🎤 Roteiro de apresentação

1. **Tema (30s):** por que academia — domínio claro e visual.
2. **Demo do app (2min):** início → iniciar treino → registrar séries →
   ver progresso no gráfico.
3. **Teste A/B (2min):** explicar a hipótese, mostrar a variante atual no
   rodapé da tela inicial e abrir a aba A/B → "Simular 100 usuários" → mostrar
   a variante vencedora.
4. **TDD (1min):** rodar `flutter test` ao vivo (tudo verde) e mostrar um teste.
5. **CI/CD (1min):** abrir a aba **Actions** no GitHub — mostrar o CI verde no
   último PR e o CD que publicou o site no GitHub Pages.
6. **Fechamento (30s):** arquitetura em camadas e divisão do time.

## 🛠️ Tecnologias

Flutter · Dart · Provider · SharedPreferences · fl_chart · flutter_lints ·
GitHub Actions · GitHub Pages

---

Feito com 💚 para a disciplina — _IronLog: seu treino, sua evolução._
