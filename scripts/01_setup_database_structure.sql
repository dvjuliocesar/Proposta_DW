-- =====================================================
-- SETUP DA ESTRUTURA DO DATA WAREHOUSE E-COMMERCE
-- =====================================================

-- Criar o database principal
CREATE DATABASE IF NOT EXISTS ECOMMERCE_DW;
USE DATABASE ECOMMERCE_DW;

-- =====================================================
-- CRIAÇÃO DOS SCHEMAS (CAMADAS)
-- =====================================================

-- Staging Area - Dados brutos da API Amazon
CREATE SCHEMA IF NOT EXISTS RAW_AMAZON_DATA;

-- Core Layer - Modelo dimensional (Star Schema)
CREATE SCHEMA IF NOT EXISTS CORE_DATA;

-- Analytics Layer - Views e tabelas agregadas
CREATE SCHEMA IF NOT EXISTS ANALYTICS;

-- Schema para utilitários e funções
CREATE SCHEMA IF NOT EXISTS UTILS;

-- =====================================================
-- CONFIGURAÇÕES DE WAREHOUSE
-- =====================================================

-- Criar warehouse para processamento
CREATE WAREHOUSE IF NOT EXISTS ECOMMERCE_WH
WITH 
    WAREHOUSE_SIZE = 'MEDIUM'
    AUTO_SUSPEND = 300
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE;

-- Definir warehouse padrão
USE WAREHOUSE ECOMMERCE_WH;

-- =====================================================
-- CONFIGURAÇÕES DE SEGURANÇA E ROLES
-- =====================================================

-- Criar roles específicos
CREATE ROLE IF NOT EXISTS DW_ADMIN;
CREATE ROLE IF NOT EXISTS DW_ANALYST;
CREATE ROLE IF NOT EXISTS DW_READER;

-- Conceder permissões
GRANT USAGE ON DATABASE ECOMMERCE_DW TO ROLE DW_ADMIN;
GRANT USAGE ON DATABASE ECOMMERCE_DW TO ROLE DW_ANALYST;
GRANT USAGE ON DATABASE ECOMMERCE_DW TO ROLE DW_READER;

GRANT ALL ON SCHEMA RAW_AMAZON_DATA TO ROLE DW_ADMIN;
GRANT ALL ON SCHEMA CORE_DATA TO ROLE DW_ADMIN;
GRANT ALL ON SCHEMA ANALYTICS TO ROLE DW_ADMIN;

GRANT USAGE ON SCHEMA CORE_DATA TO ROLE DW_ANALYST;
GRANT USAGE ON SCHEMA ANALYTICS TO ROLE DW_ANALYST;

GRANT USAGE ON SCHEMA ANALYTICS TO ROLE DW_READER;
