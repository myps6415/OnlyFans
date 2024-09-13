FROM python:3.10-slim
RUN apt-get update && apt-get install -y \
  curl \
  libpq-dev \
  gcc \
  && rm -rf /var/lib/apt/lists/*
WORKDIR /usr/src/app
ENV POETRY_HOME=/usr/local/share/pypoetry
ENV POETRY_VIRTUALENVS_CREATE=false
RUN curl -sSL https://install.python-poetry.org | python3 -

# 複製項目文件
COPY . .

# 安裝項目
RUN /usr/local/share/pypoetry/bin/poetry install --only main

# 複製修改過的文件
COPY .venv/lib/python3.10/site-packages/ultima_scraper_api/apis/onlyfans/__init__.py /usr/src/app/.venv/lib/python3.10/site-packages/ultima_scraper_api/apis/onlyfans/__init__.py

CMD [ "/usr/local/share/pypoetry/bin/poetry", "run", "python", "./start_us.py" ]