FROM python:3.9-alpine3.13
LABEL maintainer="grhmdev"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

# 1. Install python dependencies (dev dependencies optional)
# 2. Add a non-root user
ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; \
        then pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    adduser \
    --disabled-password \
    --no-create-home \
    django-user && \
    rm -rf /tmp

ENV PATH="/py/bin:$PATH"

USER django-user
