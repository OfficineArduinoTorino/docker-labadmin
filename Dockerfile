FROM python:3
ENV PYTHONUNBUFFERED 1
RUN apt-get update
RUN apt-get install jq -y
RUN mkdir /www
WORKDIR /www
COPY requirements.txt /www/
RUN pip install -r requirements.txt
COPY . /www/

RUN chmod a+x /www/run.sh
CMD [ "/www/run.sh" ]