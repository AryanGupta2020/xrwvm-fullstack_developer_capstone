FROM node:18-bookworm-slim AS frontend
WORKDIR /fe
COPY server/frontend/package.json server/frontend/package-lock.json ./
RUN npm ci --no-audit --no-fund
COPY server/frontend/ ./
RUN CI=false npm run build

FROM python:3.12-slim-bookworm
ENV PYTHONUNBUFFERED=1 PORT=8000
RUN apt-get update \
 && apt-get install -y --no-install-recommends nodejs npm curl ca-certificates \
 && rm -rf /var/lib/apt/lists/*
RUN curl -fsSL -o /usr/local/bin/ferretdb \
    https://github.com/FerretDB/FerretDB/releases/download/v1.24.0/ferretdb-linux-amd64 \
 && chmod +x /usr/local/bin/ferretdb
WORKDIR /app
COPY server/requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt flask nltk
COPY server/database/package.json server/database/package-lock.json /app/server/database/
RUN cd /app/server/database && npm install --omit=dev --no-audit --no-fund
COPY . /app
COPY --from=frontend /fe/build /app/server/frontend/build
RUN mkdir -p /usr/share/nltk_data/sentiment \
 && cp /app/server/djangoapp/microservices/sentiment/vader_lexicon.zip /usr/share/nltk_data/sentiment/
RUN chmod +x /app/start.sh
EXPOSE 8000
CMD ["/app/start.sh"]
