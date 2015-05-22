#!/usr/bin/env python
import pika
import sys
import os
from record_play import RecordAndPlay


def action(body):
    words=body.split(',')
    print words[0]
    os.system('aplay ./data/drmapan.wav')
    pass


def connect(ip, exchange_name, binding_keys):
    connection = pika.BlockingConnection(pika.ConnectionParameters(
        host=ip))
    channel = connection.channel()

    channel.exchange_declare(exchange=exchange_name,
                             type='topic')

    result = channel.queue_declare(exclusive=True)
    queue_name = result.method.queue

    for binding_key in binding_keys:
        channel.queue_bind(exchange=exchange_name,
                           queue=queue_name,
                           routing_key=binding_key)

    print ' [*] Waiting for message. To exit press CTRL+C'

    def callback(ch, method, properties, body):
        action(body)
        print " [x] %r:%s" % (method.routing_key, body.decode('utf8'),)

    channel.basic_consume(callback,
                          queue=queue_name,
                          no_ack=True)

    channel.start_consuming()


def main():
    keys = sys.argv[1:]
    if not keys:
        print >> sys.stderr, "Usage: %s [binding_key]..." % (sys.argv[0],)
        sys.exit(1)
    connect(ip='192.168.2.102',exchange_name='raspberry',binding_keys=keys)

if __name__ == '__main__':
    main()