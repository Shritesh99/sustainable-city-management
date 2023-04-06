# Define custom function directory
FROM python:3.9

WORKDIR /
COPY ml/air/ .

RUN pip install -r requirements.txt

CMD [ "/usr/local/bin/python", "air.py" ]