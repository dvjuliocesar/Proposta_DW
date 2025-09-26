# Especificações do Dashboard Analítico

## Visão Geral
Este documento detalha as especificações para criação de dashboards analíticos baseados no Data Warehouse de e-commerce implementado no Snowflake.

## Estrutura do Dashboard

### 1. **Dashboard Executivo** (Visão Geral)

#### KPIs Principais (Cards no Topo)
\`\`\`sql
-- Receita Total (Mês Atual vs Anterior)
SELECT 
    SUM(CASE WHEN MONTH(DATA_COMPLETA) = MONTH(CURRENT_DATE()) THEN RECEITA_DIA ELSE 0 END) as RECEITA_MES_ATUAL,
    SUM(CASE WHEN MONTH(DATA_COMPLETA) = MONTH(CURRENT_DATE()) - 1 THEN RECEITA_DIA ELSE 0 END) as RECEITA_MES_ANTERIOR
FROM ANALYTICS.MART_VENDAS_DIARIAS;
\`\`\`

**Elementos Visuais**:
- **Card 1**: Receita Total (R$ 1.2M) ↑ 15.3%
- **Card 2**: Pedidos (8.5K) ↑ 8.7%
- **Card 3**: Ticket Médio (R$ 142) ↓ 2.1%
- **Card 4**: Clientes Únicos (3.2K) ↑ 12.4%

#### Gráfico Principal - Tendência de Vendas
\`\`\`sql
-- Dados para gráfico de linha temporal
SELECT 
    DATA_COMPLETA,
    RECEITA_DIA,
    TOTAL_VENDAS,
    CLIENTES_UNICOS
FROM ANALYTICS.MART_VENDAS_DIARIAS
WHERE DATA_COMPLETA >= DATEADD(month, -6, CURRENT_DATE())
ORDER BY DATA_COMPLETA;
\`\`\`

**Configuração**:
- Tipo: Gráfico de linha com múltiplas séries
- Eixo X: Data (últimos 6 meses)
- Eixo Y Primário: Receita (R$)
- Eixo Y Secundário: Número de pedidos
- Filtros: Período, categoria

### 2. **Dashboard de Produtos**

#### Top 10 Produtos (Tabela Interativa)
\`\`\`sql
-- Query para tabela de produtos
SELECT 
    NOME_PRODUTO,
    CATEGORIA_PRINCIPAL,
    MARCA,
    TOTAL_VENDAS,
    RECEITA_TOTAL,
    RATING_MEDIO,
    RANK_VOLUME_GERAL as POSICAO
FROM ANALYTICS.VW_TOP_PRODUTOS_PERFORMANCE
WHERE RANK_VOLUME_GERAL <= 10;
\`\`\`

#### Análise por Categoria (Gráfico de Barras)
\`\`\`sql
-- Receita por categoria
SELECT 
    CATEGORIA_PRINCIPAL,
    SUM(RECEITA_TOTAL) as RECEITA_CATEGORIA,
    COUNT(DISTINCT MARCA) as MARCAS_ATIVAS,
    AVG(RATING_MEDIO_CATEGORIA) as RATING_MEDIO
FROM ANALYTICS.MART_PERFORMANCE_CATEGORIA_MARCA
GROUP BY CATEGORIA_PRINCIPAL
ORDER BY RECEITA_CATEGORIA DESC;
\`\`\`

#### Mapa de Calor - Performance de Marcas
\`\`\`sql
-- Matriz marca vs categoria
SELECT 
    MARCA,
    CATEGORIA_PRINCIPAL,
    RECEITA_TOTAL,
    PERCENTUAL_PRODUTOS_VENDIDOS
FROM ANALYTICS.MART_PERFORMANCE_CATEGORIA_MARCA
WHERE RECEITA_TOTAL > 0;
\`\`\`

### 3. **Dashboard de Clientes**

#### Segmentação de Clientes (Gráfico de Pizza)
\`\`\`sql
-- Distribuição por segmento
SELECT 
    CLASSIFICACAO_VALOR,
    COUNT(*) as TOTAL_CLIENTES,
    SUM(VALOR_TOTAL_COMPRAS) as RECEITA_SEGMENTO,
    AVG(TICKET_MEDIO) as TICKET_MEDIO_SEGMENTO
FROM ANALYTICS.VW_ANALISE_CLIENTES
GROUP BY CLASSIFICACAO_VALOR;
\`\`\`

#### Análise Geográfica (Mapa)
\`\`\`sql
-- Vendas por estado
SELECT 
    ESTADO,
    REGIAO,
    COUNT(DISTINCT CLIENTE_ID) as CLIENTES,
    SUM(VALOR_TOTAL_COMPRAS) as RECEITA_ESTADO,
    AVG(TICKET_MEDIO) as TICKET_MEDIO_ESTADO
FROM ANALYTICS.VW_ANALISE_CLIENTES
GROUP BY ESTADO, REGIAO;
\`\`\`

#### Cohort de Clientes (Gráfico de Linha)
\`\`\`sql
-- Análise de retenção por mês de primeira compra
WITH cohort_data AS (
    SELECT 
        DATE_TRUNC('month', PRIMEIRA_COMPRA) as COHORT_MES,
        CLIENTE_ID,
        DATEDIFF(month, PRIMEIRA_COMPRA, ULTIMA_COMPRA) as PERIODO_ATIVO
    FROM ANALYTICS.VW_ANALISE_CLIENTES
)
SELECT 
    COHORT_MES,
    PERIODO_ATIVO,
    COUNT(DISTINCT CLIENTE_ID) as CLIENTES_ATIVOS
FROM cohort_data
GROUP BY COHORT_MES, PERIODO_ATIVO
ORDER BY COHORT_MES, PERIODO_ATIVO;
\`\`\`

### 4. **Dashboard Operacional**

#### Sazonalidade (Gráfico de Barras Agrupadas)
\`\`\`sql
-- Performance por dia da semana
SELECT 
    NOME_DIA_SEMANA,
    E_FIM_SEMANA,
    MEDIA_VENDAS_DIA,
    MEDIA_RECEITA_DIA,
    TICKET_MEDIO
FROM (
    SELECT 
        NOME_DIA_SEMANA,
        E_FIM_SEMANA,
        DIA_SEMANA,
        AVG(TOTAL_VENDAS) as MEDIA_VENDAS_DIA,
        AVG(RECEITA_DIA) as MEDIA_RECEITA_DIA,
        AVG(TICKET_MEDIO_DIA) as TICKET_MEDIO
    FROM ANALYTICS.MART_VENDAS_DIARIAS
    WHERE TOTAL_VENDAS > 0
    GROUP BY NOME_DIA_SEMANA, E_FIM_SEMANA, DIA_SEMANA
)
ORDER BY DIA_SEMANA;
\`\`\`

#### Funil de Conversão
\`\`\`sql
-- Taxa de conversão de produtos
SELECT 
    'Produtos no Catálogo' as ETAPA,
    SUM(TOTAL_PRODUTOS_CATALOGO) as QUANTIDADE,
    100.0 as TAXA_CONVERSAO
FROM ANALYTICS.MART_PERFORMANCE_CATEGORIA_MARCA

UNION ALL

SELECT 
    'Produtos com Vendas' as ETAPA,
    SUM(PRODUTOS_COM_VENDAS) as QUANTIDADE,
    ROUND(SUM(PRODUTOS_COM_VENDAS) * 100.0 / SUM(TOTAL_PRODUTOS_CATALOGO), 2) as TAXA_CONVERSAO
FROM ANALYTICS.MART_PERFORMANCE_CATEGORIA_MARCA;
\`\`\`

## Filtros Globais

### Filtros Obrigatórios
1. **Período**: 
   - Últimos 7 dias
   - Últimos 30 dias
   - Último trimestre
   - Personalizado

2. **Categoria**: 
   - Todas
   - Eletrônicos
   - Moda
   - Livros
   - Casa e Cozinha

3. **Região**:
   - Todas
   - Norte
   - Nordeste
   - Centro-Oeste
   - Sudeste
   - Sul

### Filtros Opcionais
- Marca
- Faixa de preço
- Segmento de cliente
- Canal de venda

## Alertas e Notificações

### Alertas Críticos
\`\`\`sql
-- Queda significativa nas vendas (>20% vs dia anterior)
WITH vendas_diarias AS (
    SELECT 
        DATA_COMPLETA,
        RECEITA_DIA,
        LAG(RECEITA_DIA) OVER (ORDER BY DATA_COMPLETA) as RECEITA_DIA_ANTERIOR
    FROM ANALYTICS.MART_VENDAS_DIARIAS
    WHERE DATA_COMPLETA >= DATEADD(day, -7, CURRENT_DATE())
)
SELECT 
    DATA_COMPLETA,
    RECEITA_DIA,
    RECEITA_DIA_ANTERIOR,
    ROUND(((RECEITA_DIA - RECEITA_DIA_ANTERIOR) / RECEITA_DIA_ANTERIOR) * 100, 2) as VARIACAO_PERCENT
FROM vendas_diarias
WHERE RECEITA_DIA_ANTERIOR > 0
  AND ((RECEITA_DIA - RECEITA_DIA_ANTERIOR) / RECEITA_DIA_ANTERIOR) < -0.20;
\`\`\`

### Alertas de Oportunidade
\`\`\`sql
-- Produtos com alta demanda mas baixo estoque
SELECT 
    dp.NOME_PRODUTO,
    dp.CATEGORIA_PRINCIPAL,
    dp.ESTOQUE_DISPONIVEL,
    COUNT(fv.VENDA_KEY) as VENDAS_ULTIMOS_7_DIAS
FROM CORE_DATA.DIM_PRODUTO dp
JOIN CORE_DATA.FATO_VENDAS fv ON dp.PRODUTO_KEY = fv.PRODUTO_KEY
JOIN CORE_DATA.DIM_TEMPO dt ON fv.DATA_KEY = dt.DATA_KEY
WHERE dt.DATA_COMPLETA >= DATEADD(day, -7, CURRENT_DATE())
  AND dp.ESTOQUE_DISPONIVEL < 10
  AND fv.STATUS_VENDA = 'CONFIRMADA'
GROUP BY dp.NOME_PRODUTO, dp.CATEGORIA_PRINCIPAL, dp.ESTOQUE_DISPONIVEL
HAVING COUNT(fv.VENDA_KEY) > 5
ORDER BY VENDAS_ULTIMOS_7_DIAS DESC;
\`\`\`

## Configurações de Performance

### Refresh de Dados
- **Tempo Real**: KPIs principais (a cada 15 minutos)
- **Diário**: Tabelas agregadas (03:00 AM)
- **Semanal**: Análises históricas (Domingo, 02:00 AM)

### Otimizações
\`\`\`sql
-- Índices recomendados para performance do dashboard
CREATE INDEX IF NOT EXISTS IDX_MART_VENDAS_DATA ON ANALYTICS.MART_VENDAS_DIARIAS(DATA_COMPLETA);
CREATE INDEX IF NOT EXISTS IDX_MART_CATEGORIA ON ANALYTICS.MART_PERFORMANCE_CATEGORIA_MARCA(CATEGORIA_PRINCIPAL);
\`\`\`

### Cache de Consultas
- Consultas de KPIs: Cache de 15 minutos
- Gráficos principais: Cache de 1 hora
- Análises detalhadas: Cache de 4 horas

## Responsividade e UX

### Layout Mobile
- KPIs em cards empilhados
- Gráficos adaptados para tela pequena
- Filtros em menu colapsável
- Navegação por abas

### Interatividade
- Drill-down em gráficos
- Tooltips informativos
- Exportação para Excel/PDF
- Compartilhamento de views

### Cores e Temas
- **Primária**: #1f77b4 (Azul)
- **Secundária**: #ff7f0e (Laranja)
- **Sucesso**: #2ca02c (Verde)
- **Alerta**: #d62728 (Vermelho)
- **Neutro**: #7f7f7f (Cinza)

## Métricas de Uso do Dashboard

\`\`\`sql
-- Tracking de uso (implementar em ferramenta de BI)
CREATE TABLE IF NOT EXISTS DASHBOARD_USAGE_LOG (
    LOG_ID STRING DEFAULT UUID_STRING(),
    USER_ID STRING,
    DASHBOARD_NAME STRING,
    PAGE_VIEW STRING,
    FILTER_APPLIED STRING,
    SESSION_DURATION_MINUTES NUMBER,
    ACCESS_TIMESTAMP TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);
\`\`\`

Esta especificação fornece uma base sólida para implementação de dashboards analíticos eficazes, garantindo que os usuários tenham acesso às informações mais relevantes de forma intuitiva e performática.
