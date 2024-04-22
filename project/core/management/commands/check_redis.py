from django.core.management.base import BaseCommand
from django.conf import settings

import redis


class Command(BaseCommand):
    help = "Check if Redis server is up and running and verifies key-value pairs"

    def handle(self, *args, **kwargs):
        redis_host = settings.REDIS_HOST
        redis_port = settings.REDIS_PORT

        try:
            # Connect to Redis server
            r = redis.StrictRedis(
                host=redis_host, port=redis_port, db=0, decode_responses=True
            )

            # Check if server is up and running
            if r.ping():
                self.stdout.write(self.style.SUCCESS("Redis server is up and running."))
            else:
                self.stdout.write(
                    self.style.ERROR("Failed to connect to Redis server.")
                )

            # Set a test key-value pair
            r.set("ping", "pong")

            # Retrieve the value of the test-key
            value = r.get("ping")
            if value is not None:
                self.stdout.write(
                    self.style.SUCCESS(
                        f"Key 'ping' is stored and accessible. It's value is: {value}."
                    )
                )
            else:
                self.stdout.write(
                    self.style.ERROR(f"failed to retrieve value for key 'ping'.")
                )

        except Exception as e:
            self.stdout.write(self.style.ERROR(f"Error: {e}"))
