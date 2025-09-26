-- =====================================================
-- PIPELINE ELT - PROCEDURES E FUNÇÕES
-- =====================================================

USE SCHEMA UTILS;

-- =====================================================
-- FUNÇÃO PARA POPULAR DIMENSÃO TEMPO
-- =====================================================

CREATE OR REPLACE PROCEDURE POPULAR_DIM_TEMPO(
    DATA_INICIO DATE,
    DATA_FIM DATE
)
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    contador NUMBER DEFAULT 0;
    data_atual DATE;
BEGIN
    -- Limpar dados existentes no período
    DELETE FROM CORE_DATA.DIM_TEMPO 
    WHERE DATA_COMPLETA BETWEEN DATA_INICIO AND DATA_FIM;
    
    -- Loop para inserir cada data
    data_atual := DATA_INICIO;
    WHILE (data_atual <= DATA_FIM) DO
        INSERT INTO CORE_DATA.DIM_TEMPO (
            DATA_COMPLETA,
            ANO,
            MES,
            DIA,
            TRIMESTRE,
            SEMESTRE,
            DIA_SEMANA,
            NOME_DIA_SEMANA,
            DIA_ANO,
            SEMANA_ANO,
            MES_NOME,
            MES_NOME_ABREV,
            TRIMESTRE_NOME,
            E_FIM_SEMANA,
            E_DIA_UTIL,
            PERIODO_DIA,
            ESTACAO_ANO
        )
        VALUES (
            data_atual,
            YEAR(data_atual),
            MONTH(data_atual),
            DAY(data_atual),
            QUARTER(data_atual),
            CASE WHEN MONTH(data_atual) <= 6 THEN 1 ELSE 2 END,
            DAYOFWEEK(data_atual),
            DAYNAME(data_atual),
            DAYOFYEAR(data_atual),
            WEEKOFYEAR(data_atual),
            MONTHNAME(data_atual),
            LEFT(MONTHNAME(data_atual), 3),
            'Q' || QUARTER(data_atual),
            CASE WHEN DAYOFWEEK(data_atual) IN (1, 7) THEN TRUE ELSE FALSE END,
            CASE WHEN DAYOFWEEK(data_atual) BETWEEN 2 AND 6 THEN TRUE ELSE FALSE END,
            'Dia',
            CASE 
                WHEN MONTH(data_atual) IN (12, 1, 2) THEN 'Verão'
                WHEN MONTH(data_atual) IN (3, 4, 5) THEN 'Outono'
                WHEN MONTH(data_atual) IN (6, 7, 8) THEN 'Inverno'
                ELSE 'Primavera'
            END
        );
        
        contador := contador + 1;
        data_atual := DATEADD(day, 1, data_atual);
    END WHILE;
    
    RETURN 'Dimensão Tempo populada com ' || contador || ' registros.';
END;
$$;

-- =====================================================
-- PROCEDURE PARA PROCESSAR PRODUTOS DA STAGING
-- =====================================================

CREATE OR REPLACE PROCEDURE PROCESSAR_PRODUTOS_STAGING()
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    registros_processados NUMBER DEFAULT 0;
    registros_erro NUMBER DEFAULT 0;
BEGIN
    -- Inserir novos produtos na dimensão
    INSERT INTO CORE_DATA.DIM_PRODUTO (
        PRODUTO_ID,
        NOME_PRODUTO,
        DESCRICAO_PRODUTO,
        CATEGORIA_PRINCIPAL,
        SUBCATEGORIA,
        MARCA,
        URL_PRODUTO,
        URL_IMAGEM_PRINCIPAL,
        RATING_MEDIO,
        NUMERO_AVALIACOES,
        PRECO_ORIGINAL,
        PRECO_ATUAL,
        PERCENTUAL_DESCONTO,
        FAIXA_PRECO,
        DATA_ULTIMA_ATUALIZACAO
    )
    SELECT DISTINCT
        PRODUCT_JSON:asin::STRING as PRODUTO_ID,
        PRODUCT_JSON:title::STRING as NOME_PRODUTO,
        PRODUCT_JSON:description::STRING as DESCRICAO_PRODUTO,
        SEARCH_CATEGORY as CATEGORIA_PRINCIPAL,
        PRODUCT_JSON:category::STRING as SUBCATEGORIA,
        PRODUCT_JSON:brand::STRING as MARCA,
        PRODUCT_JSON:url::STRING as URL_PRODUTO,
        PRODUCT_JSON:image::STRING as URL_IMAGEM_PRINCIPAL,
        PRODUCT_JSON:rating::FLOAT as RATING_MEDIO,
        PRODUCT_JSON:ratingCount::NUMBER as NUMERO_AVALIACOES,
        PRODUCT_JSON:originalPrice::FLOAT as PRECO_ORIGINAL,
        PRODUCT_JSON:price::FLOAT as PRECO_ATUAL,
        CASE 
            WHEN PRODUCT_JSON:originalPrice::FLOAT > 0 
            THEN ((PRODUCT_JSON:originalPrice::FLOAT - PRODUCT_JSON:price::FLOAT) / PRODUCT_JSON:originalPrice::FLOAT) * 100
            ELSE 0 
        END as PERCENTUAL_DESCONTO,
        CASE 
            WHEN PRODUCT_JSON:price::FLOAT < 50 THEN 'Baixo'
            WHEN PRODUCT_JSON:price::FLOAT < 200 THEN 'Médio'
            WHEN PRODUCT_JSON:price::FLOAT < 500 THEN 'Alto'
            ELSE 'Premium'
        END as FAIXA_PRECO,
        CURRENT_TIMESTAMP()
    FROM RAW_AMAZON_DATA.VW_VALID_RAW_PRODUCTS
    WHERE PRODUCT_JSON:asin::STRING IS NOT NULL
    AND NOT EXISTS (
        SELECT 1 FROM CORE_DATA.DIM_PRODUTO 
        WHERE PRODUTO_ID = PRODUCT_JSON:asin::STRING
    );
    
    registros_processados := SQLROWCOUNT;
    
    RETURN 'Processamento concluído. ' || registros_processados || ' produtos inseridos.';
    
EXCEPTION
    WHEN OTHER THEN
        RETURN 'Erro no processamento: ' || SQLERRM;
END;
$$;

-- =====================================================
-- PROCEDURE PARA GERAR DADOS DE VENDAS SIMULADOS
-- =====================================================

CREATE OR REPLACE PROCEDURE GERAR_VENDAS_SIMULADAS(
    DATA_INICIO DATE,
    DATA_FIM DATE,
    NUMERO_VENDAS NUMBER
)
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    contador NUMBER DEFAULT 0;
    data_venda DATE;
    produto_key NUMBER;
    cliente_key NUMBER;
    localizacao_key NUMBER;
    quantidade NUMBER;
    preco FLOAT;
BEGIN
    WHILE (contador < NUMERO_VENDAS) DO
        -- Selecionar data aleatória no período
        data_venda := DATEADD(day, 
            UNIFORM(0, DATEDIFF(day, DATA_INICIO, DATA_FIM), RANDOM()), 
            DATA_INICIO);
        
        -- Selecionar produto aleatório
        SELECT PRODUTO_KEY INTO produto_key 
        FROM CORE_DATA.DIM_PRODUTO 
        ORDER BY RANDOM() 
        LIMIT 1;
        
        -- Selecionar cliente aleatório (criar se não existir)
        SELECT CLIENTE_KEY INTO cliente_key 
        FROM CORE_DATA.DIM_CLIENTE 
        ORDER BY RANDOM() 
        LIMIT 1;
        
        -- Se não há clientes, criar um
        IF (cliente_key IS NULL) THEN
            INSERT INTO CORE_DATA.DIM_CLIENTE (CLIENTE_ID, NOME_CLIENTE, SEGMENTO_CLIENTE)
            VALUES ('CLIENTE_' || contador, 'Cliente Simulado ' || contador, 'Bronze');
            cliente_key := LAST_INSERT_ID();
        END IF;
        
        -- Selecionar localização aleatória (criar se não existir)
        SELECT LOCALIZACAO_KEY INTO localizacao_key 
        FROM CORE_DATA.DIM_LOCALIZACAO 
        ORDER BY RANDOM() 
        LIMIT 1;
        
        -- Se não há localizações, criar uma
        IF (localizacao_key IS NULL) THEN
            INSERT INTO CORE_DATA.DIM_LOCALIZACAO (CODIGO_POSTAL, CIDADE, ESTADO, PAIS)
            VALUES ('00000-000', 'São Paulo', 'SP', 'Brasil');
            localizacao_key := LAST_INSERT_ID();
        END IF;
        
        -- Gerar quantidade e preço aleatórios
        quantidade := UNIFORM(1, 5, RANDOM());
        
        -- Buscar preço do produto
        SELECT PRECO_ATUAL INTO preco 
        FROM CORE_DATA.DIM_PRODUTO 
        WHERE PRODUTO_KEY = produto_key;
        
        -- Inserir venda
        INSERT INTO CORE_DATA.FATO_VENDAS (
            DATA_KEY,
            PRODUTO_KEY,
            CLIENTE_KEY,
            LOCALIZACAO_KEY,
            PEDIDO_ID,
            ITEM_PEDIDO_ID,
            QUANTIDADE_VENDIDA,
            PRECO_UNITARIO,
            PRECO_TOTAL,
            PRECO_FINAL,
            DATA_PEDIDO
        )
        VALUES (
            (SELECT DATA_KEY FROM CORE_DATA.DIM_TEMPO WHERE DATA_COMPLETA = data_venda),
            produto_key,
            cliente_key,
            localizacao_key,
            'PED_' || contador,
            'ITEM_' || contador,
            quantidade,
            preco,
            preco * quantidade,
            preco * quantidade,
            data_venda
        );
        
        contador := contador + 1;
    END WHILE;
    
    RETURN 'Geradas ' || contador || ' vendas simuladas.';
END;
$$;
