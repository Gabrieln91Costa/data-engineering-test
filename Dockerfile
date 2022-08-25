FROM apache/airflow:2.3.3

USER root

COPY ./dags/vendas-combustiveis-m3.xls /opt/arquivo_entrada/vendas-combustiveis-m3.xls
RUN apt-get update
RUN apt-get install libssl-dev openssl -y
RUN apt-get install pip -y
RUN apt-get install libreoffice-calc python3-uno -y
RUN apt-get install default-jre libreoffice-java-common -y
WORKDIR /opt/arquivo_entrada/
RUN libreoffice --headless --convert-to xls vendas-combustiveis-m3.xls --outdir  /opt/arquivo_saida/

user airflow

RUN pip3 install pandas
RUN pip install xlrd
RUN pip install PyMySQL
RUN pip install mysqlclient