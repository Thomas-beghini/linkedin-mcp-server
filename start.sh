#!/bin/bash
set -e

# Lancer MCP en arrière-plan
uv run -m linkedin_mcp_server &

# Lancer un serveur HTTP minimal pour Cloud Run
PORT=${PORT:-8080}
python3 - <<EOF
from http.server import HTTPServer, BaseHTTPRequestHandler
import os

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        self.wfile.write(b"MCP server running")

httpd = HTTPServer(('0.0.0.0', int(os.environ.get('PORT', PORT))), Handler)
httpd.serve_forever()
EOF
