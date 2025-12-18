FROM python:3.11

# Install ffmpeg (Required for yt-dlp merging)
RUN apt-get update && apt-get install -y ffmpeg

WORKDIR /app
COPY . .

RUN pip install --no-cache-dir -r requirements.txt

# Run the server
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]