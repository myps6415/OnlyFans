# 第一階段：建構階段
FROM python:3.11-slim as builder

RUN apt-get update && apt-get install -y \
  curl \
  libpq-dev \
  build-essential \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

ENV POETRY_HOME=/usr/local/share/pypoetry
ENV POETRY_VIRTUALENVS_CREATE=false

RUN ["/bin/bash", "-c", "set -o pipefail && curl -sSL https://install.python-poetry.org | python3 -"]

COPY . .
RUN /usr/local/share/pypoetry/bin/poetry install --no-dev

# 第二階段：執行階段
FROM python:3.11-slim as runner

COPY --from=builder /usr/src/app /usr/src/app
COPY --from=builder /usr/local/share/pypoetry /usr/local/share/pypoetry

WORKDIR /usr/src/app

CMD [ "/usr/local/share/pypoetry/bin/poetry", "run", "python", "./start_us.py" ]
