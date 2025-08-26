FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# установить системные зависимости (если нужны)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# копируем только файлы зависимостей, чтобы использовать кэш сборки
COPY requirements.txt requirements-dev.txt ./
RUN pip install --upgrade pip
RUN if [ -f requirements.txt ]; then pip install -r requirements.txt; fi
RUN pip install -r requirements-dev.txt

# копируем код
COPY . .

# точка входа по умолчанию (можно переопределять)
CMD ["python", "app/main.py"]
