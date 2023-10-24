FROM python:3.10-alpine
EXPOSE 8000
EXPOSE 8080
USER 0
RUN mkdir /opt/clock-app
WORKDIR /opt/clock-app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY clock.jpg .
COPY clock-app.py .
USER 1000
CMD ["python", "./clock-app.py"]
