from bottle import route, run, template

# Handle http requests to the root address
@route('/')
def index():
 return 'Go away.'
 
run(host='0.0.0.0', port=80)
