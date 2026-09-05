# 📦 Guia de Entrega e Apresentação — IronLog

Passo a passo para publicar no GitHub, ligar o CI/CD e apresentar.

## 1. Criar o repositório no GitHub

1. Acesse <https://github.com/new>.
2. Nome sugerido: **`ironlog`** (ou o que preferirem).
3. Deixe **vazio** — sem README, sem .gitignore, sem licença (o projeto já tem).
4. Crie o repositório e copie a URL (ex.: `https://github.com/OWNER/REPO.git`).

## 2. Enviar o código (push)

No terminal, dentro da pasta do projeto (`C:\src\gym_tracker`):

```bash
git remote add origin https://github.com/OWNER/REPO.git
git push -u origin main
```

> Troque `OWNER/REPO` pelo caminho do seu repositório.

## 3. Ligar o GitHub Pages (para o deploy do CD)

1. No GitHub: **Settings → Pages**.
2. Em **Build and deployment → Source**, selecione **GitHub Actions**.
3. Pronto. No próximo push na `main`, o workflow **CD** publica o app.
   O link aparece em **Settings → Pages** e na aba **Actions** (job "Deploy").

## 4. Ver o CI/CD funcionando

- Aba **Actions** do repositório:
  - **CI** roda em todo push/PR (lint + testes).
  - **CD** roda ao dar push na `main` (testes → build web → deploy → APK).
- O **APK** fica em: Actions → execução do CD → seção **Artifacts** → `app-release-apk`.

## 5. Atualizar os badges do README

No `README.md`, troque `OWNER/REPO` nas duas linhas de badge pelo seu
repositório para os selos de CI/CD aparecerem verdes.

## 6. Rodar localmente (para a demo)

```bash
flutter pub get
flutter run -d chrome     # web (recomendado p/ demo)
flutter run -d windows    # desktop
flutter run               # Android (emulador/celular)
```

## 7. Colocar os nomes do grupo nos commits (opcional)

Os commits foram criados com um autor local. Para constar o grupo:

```bash
git config user.name "Nome do Integrante"
git config user.email "email@dominio.com"
```

E, se quiserem creditar os 4 em um commit, usem `Co-authored-by:` na mensagem.

---

## ✅ Checklist de apresentação (dividido)

| Item avaliado        | Quem mostra | O que mostrar |
|----------------------|-------------|---------------|
| **Tema / viabilidade** | Integrante 1 | App de academia: treino A/B/C, séries, evolução |
| **Front-end**        | Integrante 3 | Navegação, tema, telas de treino e progresso |
| **Teste A/B**        | Integrante 2 | Aba A/B → "Simular 100 usuários" → variante vencedora |
| **TDD**              | Integrante 1 | `flutter test` ao vivo (tudo verde) + um teste |
| **CI/CD**            | Integrante 4 | Aba Actions: CI no PR + CD publicando no Pages |

## 🎤 Roteiro (7 min)

1. Tema (30s) → 2. Demo do app (2min) → 3. Teste A/B (2min) →
4. TDD `flutter test` (1min) → 5. CI/CD na aba Actions (1min) → 6. Fecho (30s).
