FROM python:3.9

ADD requirements.txt /tmp
RUN pip install -r /tmp/requirements.txt

COPY . /docs
WORKDIR /docs
CMD [ "mkdocs", "serve", "-a", "0.0.0.0:8000" ]
EXPOSE 8000/tcp
