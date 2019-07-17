



#----------------------------------------------------
FROM python:3.6 as build
RUN pip install pipenv
WORKDIR /build
COPY Pipfile Pipfile.lock /build/

# PIP_ONLY_BINARY=:all: 
RUN PIPENV_VENV_IN_PROJECT=1 pipenv sync

FROM python:3.6-slim as application
RUN apt update
RUN apt install -y libxml2
WORKDIR /app
COPY --from=build /build/.venv /app/.venv

COPY ./cats /app/cats
COPY ./assets /app/assets
COPY ./docs /app/docs


EXPOSE 80

CMD .venv/bin/uwsgi --http :80 --master --processes 4  --module cats.raven.wsgihandler --virtualenv .venv

