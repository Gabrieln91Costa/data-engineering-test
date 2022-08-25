# Teste de engenharia de dados - Raizen

Objetivo

Realizar o desenvolvimento do pipeline de ingestão para carga de dados referente aos relatórios.:
- Vendas de combustíveis derivados de petróleo por UF e produto
- Vendas de diesel por UF e tipo

<br>
<br>

Arquivo Origem
- vendas-combustiveis-m3.xls

<br>
<br>

Base de dados e Tabelas Destino
- db.stg_vendas_combustiveis
- db.tb_detalhes_de_vendas

<br>
<br>
<br>
<br>

<hr>

## Tecnologias Utilizadas

<br>

| Descrição           | Versão                 |
|---------------------|------------------------|
| Python              | 3.7                    |
| Apache Airflow      | 2.3.3                  |  
| Docker              | 4.11.1                 |
| PostgreSQL          | 13                     |
| MySQL               | 5.7                    |
| SQLite              | 3.15.0+                |

<br>
<br>
<br>
<br>


<hr>

## Libs

<br>

| Descrição           |
|---------------------|
|libreoffice          |
|pandas               |
|xlrd                 |
|PyMySQL              |
|MySQL-python         |
|mysqlclient          |
|Sqlalchemy           |


<br>
<br>
<br>
<br>



<hr>

# Setup


## Docker
    (Download e Instalação do Docker)
    - https://docs.docker.com/get-docker/
    

<br>
<br>
<br>



## Airflow
    (Dentro do path do projeto)
    - curl -LfO  "https://airflow.apache.org/docs/apache-airflow/2.3.3/docker-compose.yaml"
    - echo -e "AIRFLOW_UID=$(id -u) \nAIRFLOW_GID=0" > .env
    - docker-compose up airflow-init
    - docker-compose up

<br>
<br>
<br>

## Configuração de arquivos 
    (Dentro do path do projeto)
    - Criação do arquivo Dockerfile no path do projeto e inclusão das dependências e apontamento de arquivos que será ingerido
    - Atualização / Inclusão do arquivo - docker-compose.yaml -> Incluido Mysql 5.7
    - Criação dos subfolders (logs, dags, plugins)
    - Inclusão do arquivo (Excel) a ser ingerido pelo pipeline dentro do path de dags

<br>
<br>
<br>

## Desenvolvimento Pipeline 
    (Dentro do path do projeto)
    - Criação do arquivo python dentro do path(dags) (raizen_lab_01.py)
    - Criação das funções
    - Criação dos argumentos e recorrência(cron - linux)
    - Criação das Dags
    - Definição de ordem do fluxo do pipeline e dependencias para o fluxo de steps
    

<br>
<br>
<br>


## Atualizando imagem e inicialização do container
    (Dentro do path do projeto)
    - docker build . --tag pyrequire_airflow:2.3.3
    - docker-compose up airflow-init
    - docker-compose up

<br>
<br>
<br>

## Criação da base de dados e tabelas no container Mysql
    (Dentro do container - Mysql)
    - mysql -h localhost -P 3306 -u root -p
    - CREATE DATABASE db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
    - CREATE USER 'user' IDENTIFIED BY 'password'
    - GRANT ALL PRIVILEGES ON db.* TO 'user'
    - FLUSH PRIVILEGES;


    -  Tabela de staging (Tabela será criada pelo próprio código python na execução da dag com base na estrutura dos dados do arquivos carregados no dataframe)

    -  Tabela Analítica (Utilizado partições conforme período(ano) inclusos no arquivo de origem )

        CREATE TABLE db.TB_DETALHES_DE_VENDA ( year_and_month date not null, uf char(2),product varchar(256),unit varchar(256),volume DECIMAL(15,3),created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)  PARTITION BY RANGE( YEAR(year_and_month) ) (
        PARTITION p0 VALUES LESS THAN (2010),
        PARTITION p1 VALUES LESS THAN (2011),
        PARTITION p2 VALUES LESS THAN (2012),
        PARTITION p3 VALUES LESS THAN (2013),
        PARTITION p4 VALUES LESS THAN (2014),
        PARTITION p5 VALUES LESS THAN (2015),
        PARTITION p6 VALUES LESS THAN (2016),
        PARTITION p7 VALUES LESS THAN (2017),
        PARTITION p8 VALUES LESS THAN (2018),
        PARTITION p9 VALUES LESS THAN (2019),
        PARTITION p10 VALUES LESS THAN (2020),
        PARTITION p11 VALUES LESS THAN (2021),
        PARTITION p12 VALUES LESS THAN (2022),
        PARTITION p13 VALUES LESS THAN (2023),
        PARTITION p14 VALUES LESS THAN MAXVALUE
        );

<br>
<br>
<br>

## Inicialização do Airflow
    - Endereço .: http://localhost:8080/
    - Usuario.: Airflow
    - Senha.: Airflow
    - Pipeline.: Raizen

<br>
<br>
<br>


## Meta Dados Tabela Analítica

| Coluna              | Tipo                   |
|---------------------|------------------------|
| year_and_month      | date                   |
| uf                  | char(2)                |  
| product             | varchar(256)           |
| unit                | varchar(256)           |
| volume              | DECIMAL(15,3)          |
| created_at          | TIMESTAMP DEFAULT CURRENT_TIMESTAMP |

<br>
<br>
<br>



## Arquitetura
![alt text](imagens/arquitetura.png)



## Execução Modelo
![alt text](imagens/execucao_modelo.png)


<br><br>
## Fluxo de Execução
- Arquivo Excel é copiado para dentro do container >> Arquivo é lido
 no path(/opt/arquivo_entrada/vendas-combustiveis-m3.xls) e em seguida salvo no path(/opt/arquivo_saida/) utilizando lib (LibreOffice) com
 o objetivo de exibir planilhas subjacentes >> Arquivo e planilha especifica e carregada para
 dataframe >> Algumas alterações na nomenclatura das colunas são realizadas >> dados são carregados na tabela analítica (db.tb_detalhes_de_venda)


<hr>
