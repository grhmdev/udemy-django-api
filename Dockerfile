FROM python:3.9-alpine3.13
LABEL maintainer="grhmdev"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
# Install psycopg2 dependencies
    apk add --upgrade --no-cache postgresql-client && \
    apk add --upgrade --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev && \
# Install python dependencies (dev dependencies optional)
    /py/bin/pip install -r /tmp/requirements.txt && \
        if [ "$DEV" = "true" ]; \
            then pip install -r /tmp/requirements.dev.txt ; \
        fi && \
# Add a non-root user
    adduser \
    --disabled-password \
    --no-create-home \
    django-user && \
# Cleanup
    apk del .tmp-build-deps && \
    rm -rf /tmp

ENV PATH="/py/bin:$PATH"

USER django-user
