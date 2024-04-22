# pull official base image
FROM python:3.11.4-slim-buster

# set work directory
WORKDIR /usr/src/app

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# install system dependencies
RUN apt-get update \
    && apt-get install -y netcat \
    # cleaning up unused files
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && rm -rf /var/lib/apt/lists/*

# install dependencies
RUN pip install --upgrade pip
COPY ./requirements ./requirements
RUN pip install -r requirements/development.txt

# entrypoint shell script
COPY ./scripts/dev/app/entrypoint.sh /usr/src/app/scripts/dev/app/entrypoint.sh
RUN sed -i 's/\r$//g' /usr/src/app/scripts/dev/app/entrypoint.sh
RUN chmod +x /usr/src/app/scripts/dev/app/entrypoint.sh

# Django startup shell script
COPY ./scripts/dev/app/start.sh /usr/src/app/scripts/dev/app/start.sh
RUN sed -i 's/\r$//g' /usr/src/app/scripts/dev/app/start.sh
RUN chmod +x /usr/src/app/scripts/dev/app/start.sh

# Celery startup shell script
COPY ./scripts/dev/app/celery/worker/start.sh /usr/src/app/scripts/dev/app/celery/worker/start.sh
RUN sed -i 's/\r$//g' /usr/src/app/scripts/dev/app/celery/worker/start.sh
RUN chmod +x /usr/src/app/scripts/dev/app/celery/worker/start.sh

# Flower startup shell script
COPY ./scripts/dev/app/celery/flower/start.sh /usr/src/app/scripts/dev/app/celery/flower/start.sh
RUN sed -i 's/\r$//g' /usr/src/app/scripts/dev/app/celery/flower/start.sh
RUN chmod +x /usr/src/app/scripts/dev/app/celery/flower/start.sh

# copy project
COPY . .

# run entrypoint.sh
ENTRYPOINT ["/usr/src/app/scripts/dev/app/entrypoint.sh"]
