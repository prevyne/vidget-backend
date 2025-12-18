from flask import Flask, request, jsonify, send_file, after_this_request
from flask_cors import CORS
import yt_dlp
import os
import uuid

app = Flask(__name__)
CORS(app)  # Allow the Lovable app to talk to this server

# --- NEW: Home Route to fix "Not Found" error ---


@app.route('/', methods=['GET'])
def home():
    return "VidGet Cloud Backend is Online! 🚀 Use POST /download to fetch videos.", 200


@app.route('/download', methods=['POST'])
def download_video():
    data = request.json
    url = data.get('url')

    if not url:
        return jsonify({"error": "No URL provided"}), 400

    # Generate a unique filename for temp storage
    file_id = str(uuid.uuid4())
    temp_template = f"downloads/{file_id}/%(title)s.%(ext)s"

    ydl_opts = {
        'format': 'best',
        'outtmpl': temp_template,
        'quiet': True,
        # We limit quality to 720p for the Cloud MVP to save bandwidth/memory on free tier
        'format_sort': ['res:720', 'ext:mp4:m4a'],
    }

    try:
        with yt_dlp.YoutubeDL(ydl_opts) as ydl:
            info = ydl.extract_info(url, download=True)
            filename = ydl.prepare_filename(info)

        # Clean up file after sending
        @after_this_request
        def remove_file(response):
            try:
                os.remove(filename)
                os.rmdir(os.path.dirname(filename))
            except Exception as e:
                print(f"Error cleaning up: {e}")
            return response

        # Stream file to user
        return send_file(filename, as_attachment=True)

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "online", "version": "1.3-cloud"}), 200


if __name__ == '__main__':
    port = int(os.environ.get("PORT", 5000))
    app.run(host='0.0.0.0', port=port)
