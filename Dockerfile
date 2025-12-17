FROM python:3.9-slim

# Install ffmpeg (Required for yt-dlp merging)
RUN apt-get update && apt-get install -y ffmpeg

WORKDIR /app
COPY . .

RUN pip install --no-cache-dir -r requirements.txt

# Run the server
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]

### Next Steps
1.  Save the file.
2.  Commit and push the changes to GitHub:
    ```bash
    git add Dockerfile
    git commit -m "Fix Dockerfile syntax"
    git push origin main