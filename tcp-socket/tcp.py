import SocketServer

class TCPHandler(SocketServer.BaseRequestHandler): 

   def handle(self):
      self.msg = self.request.recv(1024).strip()
      if self.msg == "on<EOF>":
         print "Turning On..."
         #ECHO "SUCCESS<EOF>"        <----- I need the server to echo back "success"
      if self.msg == "off<EOF>":
         print "Turning Off..."
         #ECHO "SUCCESS<EOF>"        <----- I need the server to echo back "success"


      if __name__ == "__main__": 
         host, port = '192.168.1.100', 1100

  # Create server, bind to local host and port 
  server = SocketServer.TCPServer((host,port),TCPHandler)

  print "server is starting on ", host, port

  # start server
  server.serve_forever()