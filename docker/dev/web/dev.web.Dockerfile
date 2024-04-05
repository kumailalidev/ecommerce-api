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
    && apt-get clean

# install dependencies
RUN pip install --upgrade pip
COPY ./requirements ./requirements
RUN pip install -r requirements/development.txt

# copy entrypoint.sh
COPY ./entrypoint.sh .
RUN sed -i 's/\r$//g' /usr/src/app/entrypoint.sh
RUN chmod +x /usr/src/app/entrypoint.sh

# copy scripts/dev/dev.web.sh
COPY ./scripts/dev/dev.web.sh /usr/src/app/scripts/dev/
RUN sed -i 's/\r$//g' /usr/src/app/scripts/dev/dev.web.sh
RUN chmod +x /usr/src/app/scripts/dev/dev.web.sh

# copy project
COPY . .

# run entrypoint.sh
ENTRYPOINT [ "sh", "/usr/src/app/entrypoint.sh" ]
