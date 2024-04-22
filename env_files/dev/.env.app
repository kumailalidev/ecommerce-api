# Service:      web
# Container:    django (Named)
# ------------------------------------------------------------------------------

# GENERAL
# ------------------------------------------------------------------------------
DJANGO_SETTINGS_MODULE=config.settings.development
DJANGO_DEBUG=True
DJANGO_SECRET_KEY='1!42-6x(!4nc4#1sn@s7lr#yfp=u!qg&9$ipg^z4st0e*hu+d7'

# DATABASE
# ------------------------------------------------------------------------------
DATABASE_NAME=${DB_NAME}
DATABASE_USER=${DB_USER}
DATABASE_PASSWORD=${DB_PASSWORD}
DATABASE_HOST=${DB_HOST}
DATABASE_PORT=${DB_PORT}
DATABASE_URL=${DB_URL}

# SECURITY
# ------------------------------------------------------------------------------
# NGINX reverse proxy server
DJANGO_CSRF_TRUSTED_ORIGINS=http://localhost:${WEB_PORT_MAP}

# EMAIL (mailhog)
# ------------------------------------------------------------------------------
DJANGO_EMAIL_BACKEND=django.core.mail.backends.smtp.EmailBackend
DJANGO_EMAIL_HOST=${SMTP_HOST}
DJANGO_EMAIL_PORT=${SMTP_PORT}

# REDIS
# ------------------------------------------------------------------------------
REDIS_SERVER_HOST=${REDIS_STACK_SERVER_HOST}
REDIS_SERVER_PORT=${REDIS_STACK_SERVER_PORT}

# RABBITMQ
# ------------------------------------------------------------------------------
BROKER=${BROKER_NAME}
BROKER_HOST=${BROKER_HOST}
BROKER_PORT=${BROKER_PORT}
BROKER_USER=${BROKER_USER}
BROKER_PASSWORD=${BROKER_PASSWORD}
BROKER_VHOST=${BROKER_VHOST}
BROKER_URL=${BROKER_URL}
