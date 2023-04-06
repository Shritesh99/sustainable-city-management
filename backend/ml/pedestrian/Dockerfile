# Define custom function directory
FROM python:3.9

WORKDIR /
COPY ml/pedestrian/ .

RUN pip install -r requirements.txt

CMD [ "/usr/local/bin/python", "ase_ml.py" ]