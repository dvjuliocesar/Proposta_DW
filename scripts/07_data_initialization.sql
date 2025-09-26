-- =====================================================
-- INICIALIZAÇÃO DE DADOS PARA DEMONSTRAÇÃO
-- =====================================================

-- Popular dimensão tempo para os últimos 2 anos
CALL UTILS.POPULAR_DIM_TEMPO('2023-01-01', '2024-12-31');

-- Inserir algumas localizações de exemplo
INSERT INTO CORE_DATA.DIM_LOCALIZACAO (CODIGO_POSTAL, CIDADE, ESTADO, PAIS, REGIAO, TIPO_AREA, ZONA_ENTREGA, TEMPO_ENTREGA_PADRAO, CUSTO_ENTREGA_BASE)
VALUES 
    ('01000-000', 'São Paulo', 'SP', 'Brasil', 'Sudeste', 'Urbana', 'Zona 1', 2, 15.00),
    ('20000-000', 'Rio de Janeiro', 'RJ', 'Brasil', 'Sudeste', 'Urbana', 'Zona 1', 3, 18.00),
    ('30000-000', 'Belo Horizonte', 'MG', 'Brasil', 'Sudeste', 'Urbana', 'Zona 2', 4, 20.00),
    ('40000-000', 'Salvador', 'BA', 'Brasil', 'Nordeste', 'Urbana', 'Zona 3', 5, 25.00),
    ('50000-000', 'Recife', 'PE', 'Brasil', 'Nordeste', 'Urbana', 'Zona 3', 5, 25.00),
    ('60000-000', 'Fortaleza', 'CE', 'Brasil', 'Nordeste', 'Urbana', 'Zona 3', 6, 28.00),
    ('70000-000', 'Brasília', 'DF', 'Brasil', 'Centro-Oeste', 'Urbana', 'Zona 2', 4, 22.00),
    ('80000-000', 'Curitiba', 'PR', 'Brasil', 'Sul', 'Urbana', 'Zona 2', 3, 18.00),
    ('90000-000', 'Porto Alegre', 'RS', 'Brasil', 'Sul', 'Urbana', 'Zona 2', 4, 20.00),
    ('69000-000', 'Manaus', 'AM', 'Brasil', 'Norte', 'Urbana', 'Zona 4', 8, 35.00);

-- Inserir alguns clientes de exemplo
INSERT INTO CORE_DATA.DIM_CLIENTE (CLIENTE_ID, NOME_CLIENTE, EMAIL, GENERO, SEGMENTO_CLIENTE, DATA_PRIMEIRO_PEDIDO, STATUS_CLIENTE)
VALUES 
    ('CLI001', 'Maria Silva Santos', 'maria.silva@email.com', 'F', 'Ouro', '2023-03-15', 'ATIVO'),
    ('CLI002', 'João Pedro Oliveira', 'joao.pedro@email.com', 'M', 'Prata', '2023-05-20', 'ATIVO'),
    ('CLI003', 'Ana Carolina Costa', 'ana.costa@email.com', 'F', 'Bronze', '2023-07-10', 'ATIVO'),
    ('CLI004', 'Carlos Eduardo Lima', 'carlos.lima@email.com', 'M', 'Platinum', '2023-02-28', 'ATIVO'),
    ('CLI005', 'Fernanda Rodrigues', 'fernanda.r@email.com', 'F', 'Ouro', '2023-04-12', 'ATIVO'),
    ('CLI006', 'Ricardo Mendes', 'ricardo.mendes@email.com', 'M', 'Prata', '2023-06-05', 'ATIVO'),
    ('CLI007', 'Juliana Ferreira', 'juliana.f@email.com', 'F', 'Bronze', '2023-08-18', 'ATIVO'),
    ('CLI008', 'Paulo Roberto Silva', 'paulo.silva@email.com', 'M', 'Ouro', '2023-01-22', 'ATIVO'),
    ('CLI009', 'Camila Souza', 'camila.souza@email.com', 'F', 'Prata', '2023-09-03', 'ATIVO'),
    ('CLI010', 'André Luiz Santos', 'andre.santos@email.com', 'M', 'Bronze', '2023-10-15', 'ATIVO');

-- Inserir produtos de exemplo (simulando dados da API Amazon)
INSERT INTO CORE_DATA.DIM_PRODUTO (
    PRODUTO_ID, NOME_PRODUTO, DESCRICAO_PRODUTO, CATEGORIA_PRINCIPAL, SUBCATEGORIA, MARCA,
    URL_PRODUTO, RATING_MEDIO, NUMERO_AVALIACOES, PRECO_ORIGINAL, PRECO_ATUAL, FAIXA_PRECO, STATUS_PRODUTO
)
VALUES 
    ('ASIN001', 'Smartphone Samsung Galaxy S24', 'Smartphone premium com câmera de 108MP', 'Eletrônicos', 'Smartphones', 'Samsung', 'https://amazon.com/samsung-s24', 4.5, 1250, 1299.99, 1199.99, 'Premium', 'ATIVO'),
    ('ASIN002', 'iPhone 15 Pro Max', 'iPhone mais avançado da Apple', 'Eletrônicos', 'Smartphones', 'Apple', 'https://amazon.com/iphone-15-pro', 4.8, 2100, 1499.99, 1399.99, 'Premium', 'ATIVO'),
    ('ASIN003', 'Notebook Dell Inspiron 15', 'Notebook para uso profissional', 'Eletrônicos', 'Notebooks', 'Dell', 'https://amazon.com/dell-inspiron', 4.2, 850, 899.99, 799.99, 'Alto', 'ATIVO'),
    ('ASIN004', 'Tênis Nike Air Max', 'Tênis esportivo para corrida', 'Moda', 'Calçados', 'Nike', 'https://amazon.com/nike-airmax', 4.6, 1500, 199.99, 179.99, 'Médio', 'ATIVO'),
    ('ASIN005', 'Livro: Clean Code', 'Livro sobre programação limpa', 'Livros', 'Tecnologia', 'Pearson', 'https://amazon.com/clean-code', 4.9, 3200, 89.99, 69.99, 'Baixo', 'ATIVO'),
    ('ASIN006', 'Fone Bluetooth Sony WH-1000XM5', 'Fone com cancelamento de ruído', 'Eletrônicos', 'Áudio', 'Sony', 'https://amazon.com/sony-wh1000', 4.7, 980, 399.99, 349.99, 'Alto', 'ATIVO'),
    ('ASIN007', 'Camiseta Adidas Originals', 'Camiseta casual da Adidas', 'Moda', 'Roupas', 'Adidas', 'https://amazon.com/adidas-tshirt', 4.3, 650, 59.99, 49.99, 'Baixo', 'ATIVO'),
    ('ASIN008', 'Smart TV LG 55 OLED', 'TV OLED 4K com inteligência artificial', 'Eletrônicos', 'TVs', 'LG', 'https://amazon.com/lg-oled-55', 4.4, 1100, 1799.99, 1599.99, 'Premium', 'ATIVO'),
    ('ASIN009', 'Cafeteira Nespresso Vertuo', 'Cafeteira automática premium', 'Casa e Cozinha', 'Eletrodomésticos', 'Nespresso', 'https://amazon.com/nespresso-vertuo', 4.5, 750, 299.99, 249.99, 'Médio', 'ATIVO'),
    ('ASIN010', 'Mochila Jansport SuperBreak', 'Mochila escolar clássica', 'Moda', 'Acessórios', 'Jansport', 'https://amazon.com/jansport-mochila', 4.1, 2200, 49.99, 39.99, 'Baixo', 'ATIVO');

-- Gerar vendas simuladas para demonstração
CALL UTILS.GERAR_VENDAS_SIMULADAS('2023-01-01', '2024-12-31', 1000);

-- Atualizar estatísticas das tabelas para melhor performance
ALTER TABLE CORE_DATA.FATO_VENDAS COMPUTE STATISTICS;
ALTER TABLE CORE_DATA.DIM_PRODUTO COMPUTE STATISTICS;
ALTER TABLE CORE_DATA.DIM_CLIENTE COMPUTE STATISTICS;
ALTER TABLE CORE_DATA.DIM_TEMPO COMPUTE STATISTICS;
ALTER TABLE CORE_DATA.DIM_LOCALIZACAO COMPUTE STATISTICS;

-- Refresh das tabelas agregadas
DELETE FROM ANALYTICS.MART_VENDAS_DIARIAS;
INSERT INTO ANALYTICS.MART_VENDAS_DIARIAS 
SELECT * FROM (
    SELECT 
        dt.DATA_COMPLETA, dt.ANO, dt.MES, dt.DIA_SEMANA, dt.NOME_DIA_SEMANA, dt.E_FIM_SEMANA, dt.E_DIA_UTIL,
        COUNT(fv.VENDA_KEY) as TOTAL_VENDAS,
        COUNT(DISTINCT fv.CLIENTE_KEY) as CLIENTES_UNICOS,
        COUNT(DISTINCT fv.PRODUTO_KEY) as PRODUTOS_VENDIDOS,
        SUM(fv.QUANTIDADE_VENDIDA) as QUANTIDADE_TOTAL,
        SUM(fv.RECEITA_LIQUIDA) as RECEITA_DIA,
        AVG(fv.PRECO_FINAL) as TICKET_MEDIO_DIA,
        MAX(fv.PRECO_FINAL) as MAIOR_VENDA_DIA,
        MIN(fv.PRECO_FINAL) as MENOR_VENDA_DIA,
        STDDEV(fv.PRECO_FINAL) as DESVIO_PADRAO_VENDAS
    FROM CORE_DATA.DIM_TEMPO dt
    LEFT JOIN CORE_DATA.FATO_VENDAS fv ON dt.DATA_KEY = fv.DATA_KEY AND fv.STATUS_VENDA = 'CONFIRMADA'
    GROUP BY dt.DATA_COMPLETA, dt.ANO, dt.MES, dt.DIA_SEMANA, dt.NOME_DIA_SEMANA, dt.E_FIM_SEMANA, dt.E_DIA_UTIL
);

DELETE FROM ANALYTICS.MART_PERFORMANCE_CATEGORIA_MARCA;
INSERT INTO ANALYTICS.MART_PERFORMANCE_CATEGORIA_MARCA
SELECT * FROM (
    SELECT 
        dp.CATEGORIA_PRINCIPAL, dp.MARCA, dp.FAIXA_PRECO,
        COUNT(DISTINCT dp.PRODUTO_KEY) as TOTAL_PRODUTOS_CATALOGO,
        COUNT(DISTINCT CASE WHEN fv.VENDA_KEY IS NOT NULL THEN dp.PRODUTO_KEY END) as PRODUTOS_COM_VENDAS,
        COALESCE(COUNT(fv.VENDA_KEY), 0) as TOTAL_VENDAS,
        COALESCE(SUM(fv.QUANTIDADE_VENDIDA), 0) as QUANTIDADE_VENDIDA,
        COALESCE(SUM(fv.RECEITA_LIQUIDA), 0) as RECEITA_TOTAL,
        COALESCE(AVG(fv.PRECO_FINAL), 0) as TICKET_MEDIO,
        AVG(dp.RATING_MEDIO) as RATING_MEDIO_CATEGORIA,
        AVG(dp.NUMERO_AVALIACOES) as AVALIACOES_MEDIA,
        AVG(dp.PRECO_ATUAL) as PRECO_MEDIO_CATALOGO,
        ROUND(COALESCE(COUNT(DISTINCT CASE WHEN fv.VENDA_KEY IS NOT NULL THEN dp.PRODUTO_KEY END), 0) * 100.0 / NULLIF(COUNT(DISTINCT dp.PRODUTO_KEY), 0), 2) as PERCENTUAL_PRODUTOS_VENDIDOS
    FROM CORE_DATA.DIM_PRODUTO dp
    LEFT JOIN CORE_DATA.FATO_VENDAS fv ON dp.PRODUTO_KEY = fv.PRODUTO_KEY AND fv.STATUS_VENDA = 'CONFIRMADA'
    GROUP BY dp.CATEGORIA_PRINCIPAL, dp.MARCA, dp.FAIXA_PRECO
);
