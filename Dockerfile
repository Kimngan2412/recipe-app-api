# Use the official Python Alpine image as the base image
FROM python:3.9-alpine3.13

# Set the maintainer label
LABEL maintainer="muoptrengian.com"

# Set an environment variable to prevent Python from buffering the output
ENV PYTHONUNBUFFERED 1

# Create a directory for your application code
RUN mkdir /app

# Copy the requirements files to the container
COPY ./requirements.txt /app/requirements.txt
COPY ./requirements.dev.txt /app/requirements.dev.txt

# Set the working directory to /app
WORKDIR /app

# Expose the port that your Django application will run on
EXPOSE 8000

# Add an argument to specify whether to install development requirements
ARG DEV=false

# Install required packages and create a virtual environment
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /app/requirements.txt && \
    if [ "$DEV" = "true" ]; then \
        /py/bin/pip install -r /app/requirements.dev.txt; \
    fi && \
    rm -rf /root/.cache && \
    adduser -D django-user

# Add the virtual environment's bin directory to the PATH
ENV PATH="/py/bin:$PATH"

# Switch to the non-root user
USER django-user

# Set the command to run your Django application
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
