-- =====================================================
-- CONSULTAS ANALÍTICAS DE EXEMPLO
-- Respondendo às perguntas de negócio estratégicas
-- =====================================================

USE SCHEMA ANALYTICS;

-- =====================================================
-- CONSULTA 1: Total de vendas por categoria no último trimestre
-- =====================================================

-- Identificar o último trimestre com dados
WITH ultimo_trimestre AS (
    SELECT 
        MAX(ANO) as ano_atual,
        MAX(CASE WHEN ANO = MAX(ANO) THEN TRIMESTRE END) as trimestre_atual
    FROM CORE_DATA.DIM_TEMPO dt
    JOIN CORE_DATA.FATO_VENDAS fv ON dt.DATA_KEY = fv.DATA_KEY
    WHERE fv.STATUS_VENDA = 'CONFIRMADA'
)

SELECT 
    'Vendas por Categoria - Último Trimestre' as RELATORIO,
    vcp.CATEGORIA_PRINCIPAL,
    vcp.TRIMESTRE,
    vcp.ANO,
    
    -- Métricas principais
    SUM(vcp.TOTAL_VENDAS) as TOTAL_VENDAS,
    SUM(vcp.QUANTIDADE_TOTAL) as QUANTIDADE_VENDIDA,
    SUM(vcp.RECEITA_LIQUIDA) as RECEITA_LIQUIDA,
    ROUND(AVG(vcp.TICKET_MEDIO), 2) as TICKET_MEDIO,
    
    -- Análise de participação
    ROUND(
        SUM(vcp.RECEITA_LIQUIDA) * 100.0 / 
        SUM(SUM(vcp.RECEITA_LIQUIDA)) OVER (), 2
    ) as PARTICIPACAO_RECEITA_PERCENT,
    
    -- Ranking
    RANK() OVER (ORDER BY SUM(vcp.RECEITA_LIQUIDA) DESC) as RANKING_RECEITA

FROM VW_VENDAS_CATEGORIA_PERIODO vcp
CROSS JOIN ultimo_trimestre ut
WHERE vcp.ANO = ut.ano_atual 
  AND vcp.TRIMESTRE = ut.trimestre_atual
GROUP BY vcp.CATEGORIA_PRINCIPAL, vcp.TRIMESTRE, vcp.ANO
ORDER BY SUM(vcp.RECEITA_LIQUIDA) DESC;

-- =====================================================
-- CONSULTA 2: Top 10 produtos mais vendidos
-- =====================================================

SELECT 
    'Top 10 Produtos Mais Vendidos' as RELATORIO,
    RANK_VOLUME_GERAL as POSICAO,
    PRODUTO_ID,
    NOME_PRODUTO,
    CATEGORIA_PRINCIPAL,
    MARCA,
    FAIXA_PRECO,
    
    -- Métricas de vendas
    TOTAL_VENDAS,
    QUANTIDADE_VENDIDA,
    RECEITA_TOTAL,
    ROUND(PRECO_MEDIO_VENDA, 2) as PRECO_MEDIO_VENDA,
    
    -- Métricas de qualidade
    ROUND(RATING_MEDIO, 1) as RATING_MEDIO,
    NUMERO_AVALIACOES,
    
    -- Performance temporal
    PRIMEIRA_VENDA,
    ULTIMA_VENDA,
    DIAS_EM_VENDA,
    ROUND(RECEITA_POR_DIA, 2) as RECEITA_POR_DIA,
    
    -- Posição na categoria
    RANK_RECEITA_CATEGORIA as POSICAO_NA_CATEGORIA

FROM VW_TOP_PRODUTOS_PERFORMANCE
WHERE RANK_VOLUME_GERAL <= 10
ORDER BY RANK_VOLUME_GERAL;

-- =====================================================
-- CONSULTA 3: Média de preço dos produtos por marca
-- =====================================================

WITH estatisticas_marca AS (
    SELECT 
        dp.MARCA,
        dp.CATEGORIA_PRINCIPAL,
        
        -- Estatísticas de preço do catálogo
        COUNT(dp.PRODUTO_KEY) as TOTAL_PRODUTOS_CATALOGO,
        ROUND(AVG(dp.PRECO_ATUAL), 2) as PRECO_MEDIO_CATALOGO,
        ROUND(MIN(dp.PRECO_ATUAL), 2) as PRECO_MINIMO,
        ROUND(MAX(dp.PRECO_ATUAL), 2) as PRECO_MAXIMO,
        ROUND(STDDEV(dp.PRECO_ATUAL), 2) as DESVIO_PADRAO_PRECO,
        
        -- Estatísticas de vendas
        COUNT(DISTINCT fv.VENDA_KEY) as TOTAL_VENDAS,
        ROUND(AVG(fv.PRECO_FINAL), 2) as PRECO_MEDIO_VENDAS,
        SUM(fv.RECEITA_LIQUIDA) as RECEITA_TOTAL,
        
        -- Análise de qualidade
        ROUND(AVG(dp.RATING_MEDIO), 1) as RATING_MEDIO_MARCA,
        ROUND(AVG(dp.NUMERO_AVALIACOES), 0) as AVALIACOES_MEDIA
        
    FROM CORE_DATA.DIM_PRODUTO dp
    LEFT JOIN CORE_DATA.FATO_VENDAS fv ON dp.PRODUTO_KEY = fv.PRODUTO_KEY 
        AND fv.STATUS_VENDA = 'CONFIRMADA'
    WHERE dp.MARCA IS NOT NULL 
      AND dp.PRECO_ATUAL > 0
    GROUP BY dp.MARCA, dp.CATEGORIA_PRINCIPAL
)

SELECT 
    'Análise de Preços por Marca' as RELATORIO,
    MARCA,
    CATEGORIA_PRINCIPAL,
    
    -- Métricas de catálogo
    TOTAL_PRODUTOS_CATALOGO,
    PRECO_MEDIO_CATALOGO,
    PRECO_MINIMO,
    PRECO_MAXIMO,
    DESVIO_PADRAO_PRECO,
    
    -- Métricas de vendas
    COALESCE(TOTAL_VENDAS, 0) as TOTAL_VENDAS,
    COALESCE(PRECO_MEDIO_VENDAS, 0) as PRECO_MEDIO_VENDAS,
    COALESCE(RECEITA_TOTAL, 0) as RECEITA_TOTAL,
    
    -- Análise de diferença entre catálogo e vendas
    CASE 
        WHEN PRECO_MEDIO_VENDAS > 0 THEN 
            ROUND(((PRECO_MEDIO_VENDAS - PRECO_MEDIO_CATALOGO) / PRECO_MEDIO_CATALOGO) * 100, 2)
        ELSE 0 
    END as DIFERENCA_PRECO_PERCENT,
    
    -- Classificação de faixa de preço
    CASE 
        WHEN PRECO_MEDIO_CATALOGO < 50 THEN 'Econômica'
        WHEN PRECO_MEDIO_CATALOGO < 200 THEN 'Intermediária'
        WHEN PRECO_MEDIO_CATALOGO < 500 THEN 'Premium'
        ELSE 'Luxo'
    END as CLASSIFICACAO_MARCA,
    
    -- Métricas de qualidade
    RATING_MEDIO_MARCA,
    AVALIACOES_MEDIA,
    
    -- Performance relativa
    RANK() OVER (PARTITION BY CATEGORIA_PRINCIPAL ORDER BY PRECO_MEDIO_CATALOGO DESC) as RANK_PRECO_CATEGORIA,
    RANK() OVER (PARTITION BY CATEGORIA_PRINCIPAL ORDER BY COALESCE(RECEITA_TOTAL, 0) DESC) as RANK_RECEITA_CATEGORIA

FROM estatisticas_marca
ORDER BY CATEGORIA_PRINCIPAL, PRECO_MEDIO_CATALOGO DESC;

-- =====================================================
-- CONSULTAS ADICIONAIS PARA ANÁLISE DE NEGÓCIO
-- =====================================================

-- Análise de sazonalidade por dia da semana
SELECT 
    'Análise de Sazonalidade - Dia da Semana' as RELATORIO,
    NOME_DIA_SEMANA,
    DIA_SEMANA,
    E_FIM_SEMANA,
    
    -- Métricas agregadas
    COUNT(*) as DIAS_ANALISADOS,
    ROUND(AVG(TOTAL_VENDAS), 0) as MEDIA_VENDAS_DIA,
    ROUND(AVG(RECEITA_DIA), 2) as MEDIA_RECEITA_DIA,
    ROUND(AVG(TICKET_MEDIO_DIA), 2) as TICKET_MEDIO,
    ROUND(AVG(CLIENTES_UNICOS), 0) as MEDIA_CLIENTES_UNICOS,
    
    -- Análise de variabilidade
    ROUND(STDDEV(TOTAL_VENDAS), 2) as DESVIO_VENDAS,
    ROUND(MIN(RECEITA_DIA), 2) as MENOR_RECEITA,
    ROUND(MAX(RECEITA_DIA), 2) as MAIOR_RECEITA

FROM MART_VENDAS_DIARIAS
WHERE TOTAL_VENDAS > 0
GROUP BY NOME_DIA_SEMANA, DIA_SEMANA, E_FIM_SEMANA
ORDER BY DIA_SEMANA;

-- Performance de categorias vs expectativa
SELECT 
    'Performance vs Potencial por Categoria' as RELATORIO,
    CATEGORIA_PRINCIPAL,
    
    -- Métricas de catálogo
    TOTAL_PRODUTOS_CATALOGO,
    PRODUTOS_COM_VENDAS,
    PERCENTUAL_PRODUTOS_VENDIDOS,
    
    -- Métricas financeiras
    RECEITA_TOTAL,
    TICKET_MEDIO,
    PRECO_MEDIO_CATALOGO,
    
    -- Análise de potencial
    CASE 
        WHEN PERCENTUAL_PRODUTOS_VENDIDOS > 80 THEN 'Alto Aproveitamento'
        WHEN PERCENTUAL_PRODUTOS_VENDIDOS > 50 THEN 'Médio Aproveitamento'
        WHEN PERCENTUAL_PRODUTOS_VENDIDOS > 20 THEN 'Baixo Aproveitamento'
        ELSE 'Muito Baixo Aproveitamento'
    END as CLASSIFICACAO_APROVEITAMENTO,
    
    -- Oportunidades
    (TOTAL_PRODUTOS_CATALOGO - PRODUTOS_COM_VENDAS) as PRODUTOS_SEM_VENDAS,
    ROUND(
        (TOTAL_PRODUTOS_CATALOGO - PRODUTOS_COM_VENDAS) * PRECO_MEDIO_CATALOGO, 2
    ) as POTENCIAL_RECEITA_PERDIDA

FROM MART_PERFORMANCE_CATEGORIA_MARCA
WHERE TOTAL_PRODUTOS_CATALOGO > 0
GROUP BY CATEGORIA_PRINCIPAL, TOTAL_PRODUTOS_CATALOGO, PRODUTOS_COM_VENDAS, 
         PERCENTUAL_PRODUTOS_VENDIDOS, RECEITA_TOTAL, TICKET_MEDIO, PRECO_MEDIO_CATALOGO
ORDER BY RECEITA_TOTAL DESC;
