# Build stage
FROM python:3.10-slim AS build

# Set work directory
WORKDIR /app

# Copy and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application files
COPY . .

# Run stage
FROM python:3.10-slim AS run

# Set environment variables
ENV PYTHONUNBUFFERED=1

# Set work directory
WORKDIR /app

# Copy installed dependencies from the build stage
COPY --from=build /usr/local/lib/python3.10/site-packages /usr/local/lib/python3.10/site-packages

# Copy application files
COPY . .

# Run database migrations
RUN python manage.py migrate

# Expose the port
EXPOSE 8080

# Start the Django app
CMD ["python", "manage.py", "runserver", "0.0.0.0:8080"]
