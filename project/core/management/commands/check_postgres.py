from django.core.management.base import BaseCommand
from django.conf import settings

import psycopg2


class Command(BaseCommand):
    help = "Check if Postgres server is up and running."

    def handle(self, *args, **kwargs):

        postgres_dbname = settings.POSTGRES_DBNAME
        postgres_user = settings.POSTGRES_USER
        postgres_password = settings.POSTGRES_PASSWORD
        postgres_host = settings.POSTGRES_HOST
        postgres_port = settings.POSTGRES_PORT

        try:
            psycopg2.connect(
                dbname=postgres_dbname,
                user=postgres_user,
                password=postgres_password,
                host=postgres_host,
                port=postgres_port,
            )
            self.stdout.write(self.style.SUCCESS("Postgres server is up and running."))
        except psycopg2.OperationalError:
            self.stdout.write(self.style.ERROR("Failed to connect to Postgres server."))
