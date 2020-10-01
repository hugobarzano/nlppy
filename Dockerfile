# Dockerfile from https://github.com/hugobarzano/nlppy.git
FROM    python:3  
MAINTAINER    hugobarzano  
WORKDIR    /usr/src/app  
COPY    . /usr/src/app  
RUN    pip install -r requirements.txt  
EXPOSE    4321  
ENTRYPOINT    ["python", "server.py"]  
