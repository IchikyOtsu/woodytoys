import uuid
import json
from datetime import datetime
from flask import Flask, request
from flask_cors import CORS
import redis
import woody
import os
app = Flask('my_api')
cors = CORS(app)

# Connexion à Redis
redis_client = redis.Redis(host='redis', port=6379, db=0)

# Connexion à RabbitMQ
rabbitmq_host = os.environ.get('RABBITMQ_HOST', 'rabbitmq')
connection = pika.BlockingConnection(pika.ConnectionParameters(host=rabbitmq_host))
channel = connection.channel()
# Déclarer la file d'attente
channel.queue_declare(queue='orders')


def process_order(order_id, order):
    status = woody.make_heavy_validation(order)
    woody.save_order(order_id, status, order)
    
    # Envoyer un message à RabbitMQ
    channel.basic_publish(exchange='', routing_key='orders', body=json.dumps({'order_id': order_id, 'status': status}))
@app.get('/api/ping')
def ping():
    return 'ping'

# ### 1. Misc service ###
@app.route('/api/misc/time', methods=['GET'])
def get_time():
    return f'misc: {datetime.now()}'

@app.route('/api/misc/heavy', methods=['GET'])
def get_heavy():
    # TODO TP9: cache ?
    name = request.args.get('name')
    r = woody.make_some_heavy_computation(name)
    return f'{datetime.now()}: {r}'

# ### 2. Product Service ###
@app.route('/api/products', methods=['GET'])
def add_product():
    product = request.args.get('product')
    woody.add_product(str(product))
    return str(product) or "none"

@app.route('/api/products/<int:product_id>', methods=['GET'])
def get_product(product_id):
    return "not yet implemented"

@app.route('/api/products/last', methods=['GET'])
def get_last_product():
    # Essayer de récupérer les données depuis le cache
    cached_data = redis_client.get('last_product_cache')
    if cached_data:
        return cached_data

    # Si pas en cache, récupérer depuis la DB
    last_product = woody.get_last_product()  # note: it's a very slow db query

    # Mettre en cache les données pour 60 secondes
    redis_client.setex('last_product_cache', 60, json.dumps(f'db: {datetime.now()} - {last_product}'))

    return f'db: {datetime.now()} - {last_product}'

# ### 3. Order Service
@app.route('/api/orders/do', methods=['GET'])
def create_order():
    product = request.args.get('product')
    order_id = str(uuid.uuid4())
    process_order(order_id, product)
    return f"Your process {order_id} has been created"

@app.route('/api/orders/', methods=['GET'])
def get_order():
    order_id = request.args.get('order_id')
    status = woody.get_order(order_id)
    return f'order "{order_id}": {status}'

# #### 4. internal Services
def process_order(order_id, order):
    status = woody.make_heavy_validation(order)
    woody.save_order(order_id, status, order)

if __name__ == "__main__":
    woody.launch_server(app, host='0.0.0.0', port=5000)
