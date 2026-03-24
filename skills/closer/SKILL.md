---
name: Closer
description: "Assistente de fechamento de vendas. Processa transcrições de reuniões (Google Meet) e/ou input SPIN manual para gerar argumentos de fechamento personalizados, roteiro narrativo para anúncio/criativo, e scoring do lead. Suporta múltiplas reuniões do mesmo cliente como entrada consolidada."
version: 1.0.0
risk: low
source: personal
date_added: "2026-03-23"
---

# Closer — Assistente de Fechamento de Vendas

Ferramenta de suporte ao corretor no momento de fechamento. Extrai e consolida informações no framework SPIN Selling e gera argumentos persuasivos personalizados.

---

## Uso

### Modo A — Transcrições (Google Meet ou qualquer fonte de texto)

Forneça um ou mais arquivos de transcrição. Adicione VENDEDOR e PRODUTO antes das transcrições (opcional mas recomendado):

```
VENDEDOR: [nome do corretor/vendedor + o que está vendendo]
PRODUTO: [nome do produto, preço, condições de pagamento, diferenciais]

---

[REUNIÃO 1 — YYYY-MM-DD]
<conteúdo da transcrição>

---

[REUNIÃO 2 — YYYY-MM-DD]
<conteúdo da transcrição>
```

**Invocação:** "Use o Closer com as transcrições em [caminhos dos arquivos]"

→ Usa o workflow: `Workflows/AnalyzeClient/WORKFLOW.md`

---

### Modo B — Input SPIN Manual

Preencha o template abaixo (para WhatsApp, áudio, conversas sem transcrição):

```
VENDEDOR: [nome do corretor/vendedor + o que está vendendo]
PRODUTO: [nome do produto, preço, condições de pagamento, diferenciais]

NOME: [nome do cliente/comprador]
CONTEXTO/SITUAÇÃO: [como está a vida do cliente hoje]
PROBLEMA/CONFLITO: [o que está incomodando, o que não está funcionando]
IMPLICAÇÃO/FUNDO DO POÇO: [o que acontece se o problema continuar]
DESEJO/TOPO DA MONTANHA: [o que quer alcançar ou sentir]
JÁ TENTOU: [tentativas anteriores de resolver]
```

**Invocação:** "Use o Closer com os dados SPIN: [dados preenchidos]"

→ Usa o workflow: `Workflows/GenerateFromSPIN/WORKFLOW.md`

---

### Modo C — Híbrido

Combine transcrições + campos manuais. Campos manuais têm prioridade sobre os extraídos automaticamente.

---

## Outputs

1. **Tabela SPIN Consolidada** + dores identificadas + argumentos de fechamento personalizados
2. **Objeções Previstas** — 3-5 objeções com sinal observado + contra-argumento específico
3. **Roteiro Narrativo** para criativo/anúncio (problema → agitação → solução)
4. **Scoring do Lead** — prontidão para fechar, intensidade das dores, completude SPIN

---

## Contexto de Uso

- Corretor de imóveis preparando-se para reunião de fechamento
- Geração de copy para anúncio baseado no perfil real do comprador
- Priorização de leads por prontidão de fechamento
