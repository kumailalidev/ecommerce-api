from django.core.management.base import BaseCommand
from django.conf import settings

import pika
import pika.credentials
import pika.exceptions


class Command(BaseCommand):
    help = "Check if RabbitMQ server is up and running"

    def handle(self, *args, **kwargs):
        try:
            rabbitmq_host = settings.RABBITMQ_HOST
            rabbitmq_port = settings.RABBITMQ_PORT
            rabbitmq_user = settings.RABBITMQ_USER
            rabbitmq_pass = settings.RABBITMQ_PASS
            rabbitmq_vhost = settings.RABBITMQ_VHOST

            # Connect to RabbitMQ server
            credentials = pika.PlainCredentials(
                username=rabbitmq_user, password=rabbitmq_pass
            )
            connection_params = pika.ConnectionParameters(
                host=rabbitmq_host,
                port=rabbitmq_port,
                virtual_host=rabbitmq_vhost,
                credentials=credentials,
            )
            connection = pika.BlockingConnection(connection_params)
            channel = connection.channel()

            # Declare a queue (if it doesn't exists)
            channel.queue_declare(queue="django_test_queue")

            self.stdout.write(self.style.SUCCESS("RabbitMQ server is up and running"))

            # Clean up: Close the connection
            connection.close()

        except pika.exceptions.AMQPError as e:
            self.stdout.write(
                self.style.ERROR(f"Error connecting to RabbitMQ server: {e}")
            )
        except Exception as e:
            self.stdout.write(self.style.ERROR(f"An unexpected error occurred: {e}"))
