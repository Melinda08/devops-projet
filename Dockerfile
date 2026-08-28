FROM python:3.12
WORKDIR /app
COPY app/app.py .
EXPOSE 8080
CMD ["python", "app.py"]
