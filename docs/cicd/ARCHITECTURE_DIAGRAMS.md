# Architecture & pipeline diagrams

## 1. Repository architecture (runtime + delivery)

```mermaid
flowchart TB
  subgraph Devs["Humans + AI agents"]
    A1[Agent A]
    A2[Agent B]
    H[Human]
  end

  subgraph Git["GitHub repository"]
    F[feature/*]
    D[develop]
    R[release/*]
    M[main]
    HF[hotfix/*]
  end

  subgraph CI["GitHub Actions"]
    CIw[CI workflow]
    PRw[PR Preview]
    DPw[Deploy Preview]
    DProdw[Deploy Production]
  end

  subgraph Pages["GitHub Pages site"]
    Prod["/  production"]
    Prev["/preview/ integration"]
  end

  A1 --> F
  A2 --> F
  H --> F
  F -->|PR| CIw
  F -->|PR| PRw
  F -->|squash merge| D
  D --> DPw
  DPw --> Prev
  D --> R
  R -->|PR| M
  M --> DProdw
  DProdw --> Prod
  HF --> M
  M --> D
```

## 2. Branch strategy diagram

```text
feature/* ──────────────┐
                        │ PR + CI + PR Preview
                        ▼
                   ┌─────────┐
                   │ develop │──── Deploy Preview ──► /preview/
                   └────┬────┘
                        │ release/*
                        ▼
                   ┌─────────┐
                   │  main   │──── Deploy Production ► /
                   └────┬────┘
                        │
                   hotfix/* (cut from main, merge back to develop)
```

See also: [`GIT_FLOW.md`](GIT_FLOW.md)

## 3. CI/CD pipeline diagram

```mermaid
flowchart LR
  subgraph PR["Pull Request"]
    P1[flutter pub get]
    P2[flutter analyze]
    P3[flutter test]
    P4[flutter build web]
    P5[Upload artifact]
    P6[PR comment]
    P1 --> P2 --> P3 --> P4 --> P5 --> P6
  end

  subgraph Develop["Push develop"]
    V1[Quality gate]
    V2[Build --base-href /MOMO/preview/]
    V3[Cache preview fragment]
    V4[Restore production fragment]
    V5[Assemble staging]
    V6[deploy-pages]
    V1 --> V2 --> V3 --> V4 --> V5 --> V6
  end

  subgraph Main["Push main"]
    M1[Quality gate]
    M2[Build --base-href /MOMO/]
    M3[Cache production fragment]
    M4[Restore preview fragment]
    M5[Assemble staging]
    M6[deploy-pages]
    M1 --> M2 --> M3 --> M4 --> M5 --> M6
  end
```

## 4. Quality checks on every workflow

```text
┌──────────────┐   ┌──────────────┐   ┌──────────────┐   ┌──────────────┐
│ Flutter cache│ → │  pub get     │ → │ analyze+test │ → │ build web    │
└──────────────┘   └──────────────┘   └──────────────┘   └──────┬───────┘
                                                                │
                     ┌────────────────┬─────────────────────────┘
                     ▼                ▼
              Upload artifact   Failure notify
              (CI / PR / deploy)  (summary + PR comment / ::error)
```
