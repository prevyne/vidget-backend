FROM python:3.9-slim

# Install ffmpeg (Required for yt-dlp merging)
RUN apt-get update && apt-get install -y ffmpeg

WORKDIR /app
COPY . .

RUN pip install --no-cache-dir -r requirements.txt

# Run the server
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
```

### Part 2: Quick Deployment (Do this once)

1.  Push the `vidget-backend` folder to a new **GitHub Repository**.
2.  Sign up for **Render.com** (it's free).
3.  Click **New +** -> **Web Service**.
4.  Connect your GitHub repo.
5.  Select "Docker" as the Runtime.
6.  Click **Create Web Service**.
7.  **Copy the URL** Render gives you (e.g., `https://vidget-backend.onrender.com`).

---

### Part 3: The Lovable AI Prompt (The "Frontend")

Now, use this prompt in Lovable. Replace `[YOUR_RENDER_URL]` with the URL you got from step 2 (e.g., `https://vidget-backend.onrender.com`).

```text
Build a fully functional React application called "VidGet Cloud".

**Core Logic:**
This is a web frontend for a video downloader API.
- **Backend URL:** [YOUR_RENDER_URL]
- **Architecture:** When the user clicks download, the app must send a POST request to `${Backend_URL}/download` with the body `{ "url": "user_input" }`.
- **Response Handling:** The server returns a file stream (BLOB). The frontend must convert this blob into a downloadable file link automatically so the browser saves the video.

**UI Design (Cyberpunk/Dark Mode):**
- **Theme:** Dark Slate (#2b2b2b) background, Green (#28a745) accents.
- **Header:** Logo "VidGet Cloud" with a live status indicator dot.
    - On load, fetch `${Backend_URL}/health`. If 200 OK, dot turns Green. If fails, dot turns Red with tooltip "Server Offline".
- **Main Card:**
    - Input field: "Paste video link here..."
    - Button: "DOWNLOAD MP4" (Large, Green).
    - Status Area: A terminal-style box that shows logs ("Connecting to Cloud Engine...", "Processing...", "Starting Download...").

**Tech Stack:** React, Tailwind CSS, Axios (for requests).

**Critical Behavior:**
- While waiting for the API response (which might take 10-30 seconds for the server to process the video), show a spinner and a text saying "Cloud Engine is processing your video... please wait."
- Do NOT mock the download. It must actually fetch the blob from the provided URL.