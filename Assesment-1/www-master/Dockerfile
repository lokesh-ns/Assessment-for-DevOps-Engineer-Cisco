FROM python:3.11-slim

EXPOSE 80

COPY app.py .
COPY requirements.txt .
COPY images/* images/

RUN apt-get update && pip install -r requirements.txt

ENTRYPOINT ["python", "app.py"]
