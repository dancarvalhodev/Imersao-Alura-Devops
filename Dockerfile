# 1. Use uma imagem base oficial e leve do Python com Alpine
FROM python:3.13.5-alpine

# 2. Defina o diretório de trabalho no contêiner
WORKDIR /app

# 3. Copie o arquivo de dependências primeiro para aproveitar o cache do Docker
COPY requirements.txt .

# 4. Instale as dependências de forma otimizada para Alpine
# Instala as dependências de build, instala os pacotes Python e remove as dependências de build em uma única camada
RUN apk add --no-cache --virtual .build-deps build-base \
    && pip install --no-cache-dir -r requirements.txt \
    && apk del .build-deps

# 5. Copie o restante do código da aplicação (o .dockerignore vai pular arquivos desnecessários)
COPY . .

# 6. Exponha a porta em que a aplicação será executada
EXPOSE 8000

# 7. Defina o comando para iniciar a aplicação
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]