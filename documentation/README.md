# Data Warehouse E-commerce - Snowflake

## Visão Geral

Este projeto implementa uma solução completa de Data Warehouse para e-commerce utilizando Snowflake como plataforma principal. O sistema foi projetado para análise de vendas, desempenho de produtos e comportamento do consumidor, servindo como base para dashboards analíticos.

## Arquitetura

### Estrutura de Camadas

O Data Warehouse está organizado em três camadas principais:

#### 1. **RAW_AMAZON_DATA** (Staging Area)
- **Propósito**: Armazenar dados brutos extraídos da API Amazon Product Search
- **Formato**: JSON sem tratamento
- **Tabelas Principais**:
  - `RAW_PRODUCTS`: Dados brutos dos produtos
  - `EXTRACTION_LOG`: Log das extrações realizadas
  - `DATA_QUALITY_CHECKS`: Controle de qualidade dos dados

#### 2. **CORE_DATA** (Core Layer)
- **Propósito**: Modelo dimensional (Star Schema) para análises
- **Estrutura**: Tabela Fato + Dimensões
- **Tabelas**:
  - **Fato**: `FATO_VENDAS`
  - **Dimensões**: 
    - `DIM_TEMPO`
    - `DIM_PRODUTO` 
    - `DIM_CLIENTE`
    - `DIM_LOCALIZACAO`

#### 3. **ANALYTICS** (Analytics Layer)
- **Propósito**: Views e tabelas agregadas para consumo por ferramentas de BI
- **Componentes**:
  - Views analíticas otimizadas
  - Tabelas agregadas (marts)
  - Métricas pré-calculadas

## Modelo Dimensional (Star Schema)

### Tabela Fato: FATO_VENDAS
**Granularidade**: Por item de pedido

**Métricas Principais**:
- Quantidade Vendida
- Preço Unitário
- Preço Total
- Desconto Aplicado
- Receita Líquida
- Margem Bruta

### Dimensões

#### DIM_PRODUTO
- Detalhes completos do produto
- Informações de categoria, marca, modelo
- Ratings e avaliações
- Histórico de preços
- URLs de imagens

#### DIM_CLIENTE
- Informações demográficas
- Segmentação de clientes
- Histórico de compras
- Scores de comportamento

#### DIM_TEMPO
- Hierarquia temporal completa
- Atributos de negócio (dias úteis, feriados)
- Análise sazonal

#### DIM_LOCALIZACAO
- Informações geográficas
- Dados logísticos
- Classificações demográficas

## Pipeline ELT

### 1. **Extract** (Extração)
\`\`\`sql
-- Exemplo de extração via Amazon Product Search MCP
-- Buscar produtos de uma categoria específica
CALL EXTRACT_AMAZON_PRODUCTS('smartphones', 100);
\`\`\`

### 2. **Load** (Carregamento)
\`\`\`sql
-- Carregar dados JSON na staging area
COPY INTO RAW_AMAZON_DATA.RAW_PRODUCTS
FROM @my_stage/amazon_products.json
FILE_FORMAT = (TYPE = JSON);
\`\`\`

### 3. **Transform** (Transformação)
\`\`\`sql
-- Processar dados da staging para o modelo dimensional
CALL UTILS.PROCESSAR_PRODUTOS_STAGING();
\`\`\`

## Consultas Analíticas

### 1. Vendas por Categoria no Último Trimestre
\`\`\`sql
-- Análise de performance por categoria
SELECT 
    CATEGORIA_PRINCIPAL,
    SUM(RECEITA_LIQUIDA) as RECEITA_TOTAL,
    COUNT(TOTAL_VENDAS) as VENDAS_TOTAIS,
    AVG(TICKET_MEDIO) as TICKET_MEDIO
FROM ANALYTICS.VW_VENDAS_CATEGORIA_PERIODO
WHERE ANO = 2024 AND TRIMESTRE = 4
GROUP BY CATEGORIA_PRINCIPAL
ORDER BY RECEITA_TOTAL DESC;
\`\`\`

### 2. Top 10 Produtos Mais Vendidos
\`\`\`sql
-- Ranking de produtos por volume
SELECT *
FROM ANALYTICS.VW_TOP_PRODUTOS_PERFORMANCE
WHERE RANK_VOLUME_GERAL <= 10
ORDER BY TOTAL_VENDAS DESC;
\`\`\`

### 3. Média de Preços por Marca
\`\`\`sql
-- Análise de posicionamento de preços
SELECT 
    MARCA,
    CATEGORIA_PRINCIPAL,
    AVG(PRECO_MEDIO_CATALOGO) as PRECO_MEDIO,
    COUNT(TOTAL_PRODUTOS_CATALOGO) as PRODUTOS_CATALOGO
FROM ANALYTICS.MART_PERFORMANCE_CATEGORIA_MARCA
GROUP BY MARCA, CATEGORIA_PRINCIPAL
ORDER BY PRECO_MEDIO DESC;
\`\`\`

## KPIs e Métricas para Dashboard

### Indicadores Principais
1. **Receita Total**: Soma de todas as vendas confirmadas
2. **Ticket Médio**: Valor médio por transação
3. **Produtos Vendidos**: Quantidade total de itens
4. **Clientes Únicos**: Número de compradores distintos
5. **Taxa de Conversão**: % de produtos com vendas vs catálogo

### Gráficos Sugeridos

#### 1. **Gráfico de Barras - Vendas por Mês**
- Eixo X: Meses
- Eixo Y: Receita
- Segmentação: Por categoria

#### 2. **Mapa de Calor - Vendas por Região**
- Dimensões: Estado/Cidade
- Intensidade: Volume de vendas
- Filtros: Período, categoria

#### 3. **Gráfico de Pizza - Participação por Categoria**
- Fatias: Categorias de produtos
- Valores: % da receita total
- Drill-down: Subcategorias

#### 4. **Gráfico de Linha - Tendência Temporal**
- Eixo X: Tempo (diário/semanal/mensal)
- Eixo Y: Métricas (vendas, receita, clientes)
- Múltiplas linhas: Comparação de períodos

#### 5. **Tabela Ranking - Top Produtos/Marcas**
- Colunas: Nome, categoria, vendas, receita
- Ordenação: Por performance
- Filtros: Período, categoria, marca

#### 6. **Gauge/Velocímetro - Metas vs Realizado**
- Indicador: % de atingimento da meta
- Métricas: Receita, vendas, novos clientes
- Cores: Verde (meta atingida), amarelo (próximo), vermelho (abaixo)

## Instalação e Configuração

### Pré-requisitos
- Conta Snowflake ativa
- Warehouse configurado
- Permissões adequadas para criação de objetos

### Passos de Instalação

1. **Executar Scripts na Ordem**:
   \`\`\`bash
   01_setup_database_structure.sql
   02_staging_layer_tables.sql
   03_dimensional_model_core.sql
   04_elt_pipeline_procedures.sql
   05_analytics_layer.sql
   06_sample_queries.sql
   07_data_initialization.sql
   \`\`\`

2. **Configurar Integrações**:
   - Amazon Product Search MCP
   - Snowflake MCP
   - Ferramentas de BI (Tableau, Power BI, etc.)

3. **Agendar Processos**:
   - Extração diária de produtos
   - Processamento ELT
   - Refresh de tabelas agregadas

## Monitoramento e Manutenção

### Controle de Qualidade
- Verificações automáticas de integridade
- Alertas para falhas no pipeline
- Métricas de qualidade dos dados

### Performance
- Índices otimizados para consultas frequentes
- Particionamento por data
- Clustering keys para grandes tabelas

### Backup e Recuperação
- Time Travel do Snowflake (90 dias)
- Fail-safe adicional (7 dias)
- Documentação de procedimentos de recuperação

## Próximos Passos

1. **Implementar Machine Learning**:
   - Previsão de demanda
   - Segmentação avançada de clientes
   - Detecção de anomalias

2. **Expandir Fontes de Dados**:
   - Dados de marketing
   - Feedback de clientes
   - Dados de logística

3. **Automatização Avançada**:
   - Pipelines em tempo real
   - Alertas inteligentes
   - Auto-scaling de recursos

## Suporte

Para dúvidas ou suporte técnico, consulte:
- Documentação oficial do Snowflake
- Logs de execução no schema UTILS
- Métricas de qualidade em DATA_QUALITY_CHECKS
