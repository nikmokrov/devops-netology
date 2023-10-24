from http.server import BaseHTTPRequestHandler
from http.server import HTTPServer
from os import stat
from datetime import datetime
from prometheus_client import start_http_server

APP_VER = "0.0.1"

class HttpGetHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        img_file = "clock.jpg"
        if self.path == "/" + img_file:
            self.send_response(200)
            self.send_header("Content-type", "image/jpg")
            self.send_header("Content-length", stat(img_file).st_size)
            self.end_headers()
            with open(img_file, 'rb') as f:
                self.wfile.write(f.read())
        elif self.path == "/favicon.ico":
            self.send_response(404)
        else:
            self.send_response(200)
            self.send_header("Content-type", "text/html")
            self.end_headers()
            self.wfile.write('<html><head><meta charset="utf-8">'.encode())
            self.wfile.write('<title>DEVOPS-22 clock application demo</title></head>'.encode())
            self.wfile.write(f'<body><p>Демонстрационное приложение для курса DEVOPS-22</p>'.encode())
            self.wfile.write(f'<p>Автор: Николай Мокров</p>'.encode())
            self.wfile.write(f'<p>Version: {APP_VER}</p>'.encode())
            # static
            # self.wfile.write(f'<p>UTC: {datetime.utcnow().strftime("%Y.%m.%d %H:%M:%S")}</p>'.encode())
            # dynamic with js
            self.wfile.write('<script type="text/javascript" charset="utf-8">let time;setInterval(() => {time = new Date().toString();'.encode())
            self.wfile.write("document.getElementById('time').innerHTML = time;}, 1000);</script>".encode())
            self.wfile.write('<p>Time: <span id="time"></span></p>'.encode())
            self.wfile.write(f'<p><img src="{img_file}" /></p></body></html>'.encode())

def run(server_class=HTTPServer, handler_class=BaseHTTPRequestHandler):
  start_http_server(8080)
  server_address = ('', 8000)
  httpd = server_class(server_address, handler_class)
  try:
      httpd.serve_forever()
  except Exception:
      httpd.server_close()


run(handler_class=HttpGetHandler)
