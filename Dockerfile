# Gunakan image Python resmi
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Copy requirements dan install
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Copy seluruh app
COPY . .

# Expose port aplikasi
EXPOSE 5000

# Jalankan aplikasi
CMD ["python", "app.py"]
