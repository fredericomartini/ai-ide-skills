---
name: Copywriter
description: "Gerador de roteiros narrativos para criativos e anúncios imobiliários. Recebe o output do Closer (análise SPIN + dores do cliente com evidências literais) e transforma em roteiro persuasivo adaptado ao canal e formato especificados. Input: SPIN + dores + FORMATO/CANAL. Output: roteiro narrativo pronto para produção."
version: 1.0.0
risk: low
source: personal
date_added: "2026-03-24"
---

# Copywriter — Gerador de Roteiro Narrativo para Criativos

Transforma o perfil real de um cliente (output do [[Closer]]) em copy publicitária persuasiva, adaptada ao canal e formato especificados.

---

## Uso

### Input necessário

**1. Output do Closer** — cole o conteúdo do arquivo gerado pelo Closer. O que será usado:
- Tabela SPIN (especialmente Contexto/Situação, Problema/Conflito, Implicação, Desejo)
- Dores identificadas com evidências literais (frases reais do cliente)
- Campo "O que já tentou" (reforça a agitação)

**2. FORMATO/CANAL** — especifique o formato desejado:

| Formato | Descrição |
|---------|-----------|
| `video-30s` | Script para vídeo de 30 segundos com descrições de cena |
| `video-60s` | Script para vídeo de 60 segundos com descrições de cena |
| `video-90s` | Script para vídeo de 90 segundos com descrições de cena |
| `carrossel` | Copy slide a slide para Instagram/LinkedIn |
| `copy-longo` | Texto longo para landing page ou email |
| `headline` | Headline + subheadline + CTA para criativo estático |
| `thread` | Thread para X/Twitter — sequência de posts |

**3. PRODUTO** (opcional, mas recomendado) — nome, preço, condições, diferencial principal

**Invocação:** "Use o Copywriter com o output do Closer [arquivo ou conteúdo] para formato [formato]"

→ Usa o workflow: `Workflows/GenerateCreative/WORKFLOW.md`

---

## Output

Roteiro narrativo estruturado (problema → agitação → solução) adaptado ao formato especificado:
- Usa linguagem do próprio cliente (evidências literais do Closer como matéria-prima)
- Escrito para falar com o ICP, não com o cliente específico (anonimizado)
- Pronto para produção com ajustes mínimos

---

## Contexto de Uso

- Criação de anúncio baseado em pesquisa real (não em suposições do copywriter)
- Produção de vídeo de vendas para empreendimento imobiliário
- Geração de copy para carrossel, landing page, ou email com base em dores reais identificadas

---

## Notas

- **Privacidade:** O roteiro nunca usa o nome real do cliente. É baseado no perfil, não na pessoa.
- **Pipeline recomendado:** [[Closer]] → Copywriter (o Closer gera a inteligência; o Copywriter gera o criativo)
- **Múltiplos formatos:** Rode o Copywriter múltiplas vezes com diferentes FORMATO/CANAL para o mesmo input do Closer
