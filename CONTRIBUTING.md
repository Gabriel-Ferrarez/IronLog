# 🤝 Guia dos Integrantes — IronLog

Passo a passo para os **3 integrantes** clonarem, contribuírem e terem seus
próprios commits no repositório, **sem dar conflito**.

> Repositório: <https://github.com/Gabriel-Ferrarez/IronLog>

---

## Passo 0 — (Gabriel faz UMA vez) liberar acesso

No GitHub: **Settings → Collaborators → Add people** e adicione os **usuários
do GitHub** dos 3 integrantes. Sem isso, eles não conseguem dar `push`.
(Cada um recebe um convite por e-mail e precisa aceitar.)

---

## Passo 1 — Instalar o necessário (uma vez, por pessoa)

- **Git**: <https://git-scm.com/downloads>
- **Flutter** (para rodar o app e os testes): <https://docs.flutter.dev/get-started/install>
  - Confira com: `flutter doctor`
- Editor sugerido: **VS Code** + extensão *Flutter*.

## Passo 2 — Clonar o projeto

```bash
git clone https://github.com/Gabriel-Ferrarez/IronLog.git
cd IronLog
```

## Passo 3 — Configurar SUA identidade (MUITO IMPORTANTE)

Isso faz os commits contarem no **seu** perfil. Cada um roda com **seus** dados
(o mesmo e-mail da sua conta do GitHub):

```bash
git config user.name "Seu Nome"
git config user.email "seu-email-do-github@exemplo.com"
```

## Passo 4 — Instalar dependências e conferir que roda

```bash
flutter pub get
flutter test
```

Para abrir o app: `flutter run -d chrome` (ou `-d windows`).

---

## 🔒 Regras de ouro contra conflito

1. **Cada um mexe só na SUA pasta** (tabela abaixo). Se dois editarem o mesmo
   arquivo ao mesmo tempo, dá conflito — evitem isso.
2. **Puxe antes de começar e antes de subir:** `git pull --rebase`
3. **Commits pequenos e frequentes**, com mensagem clara.

## Fluxo de trabalho (recomendado: uma branch por pessoa)

```bash
git pull --rebase                    # pega o que há de novo
git checkout -b minha-parte          # cria sua branch
# ... edita arquivos da sua área ...
git add .
git commit -m "feat: descricao do que fiz"
git push -u origin minha-parte       # sobe sua branch
```

Depois, abra um **Pull Request** no GitHub (botão *Compare & pull request*) e
faça o *merge* na `main`. Assim o CI roda e valida antes de juntar.

> Alternativa mais simples (todos na `main`): troque os passos acima por
> `git pull --rebase` → editar → `git add .` → `git commit` → `git push`.
> Funciona, desde que cada um fique na sua pasta.

---

## 🧩 Divisão por frente (quem mexe onde)

| Integrante | Frente | Pasta (sua área) |
|---|---|---|
| Gabriel | Setup + Domínio/Testes | `lib/domain/`, `test/` |
| Integrante 2 | Teste A/B | `lib/core/ab/`, `lib/features/ab_dashboard/` |
| Integrante 3 | Front-end / UX | `lib/features/` (telas), `lib/core/theme/` |
| Integrante 4 | CI/CD + Docs | `.github/workflows/`, `docs/`, `README.md` |

### Ideias de tarefas reais (geram commits sem pisar no do outro)

**Integrante 2 — Teste A/B**
- Adicionar um teste novo em `test/core/ab/` (ex.: caso de peso 0.25 em B).
- Botão "Zerar métricas" no painel A/B (`ab_dashboard_screen.dart`).
- Ajustar textos/descrição do experimento.

**Integrante 3 — Front-end / UX**
- Criar uma tela de **detalhe do exercício** (abre ao tocar no catálogo).
- Ajustar espaçamentos/cores no tema (`app_theme.dart`).
- Adicionar ícone do app / tela de splash.

**Integrante 4 — CI/CD + Docs**
- Melhorar o `README.md` (prints do app, instruções).
- Adicionar etapa de **cobertura de testes** no `ci.yml`.
- Escrever `docs/` (arquitetura, decisões de design).

> Combinem no grupo quem é o 2, 3 e 4 e troquem esta tabela pelos nomes reais.

---

## ✅ Antes de entregar (dia 08)

- [ ] Os 4 têm commits no histórico (confira em **Insights → Contributors**).
- [ ] Aba **Actions** com CI e CD verdes.
- [ ] App publicado no **GitHub Pages** (link em Settings → Pages).
- [ ] `flutter test` passando (69 testes).
