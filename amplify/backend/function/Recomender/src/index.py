import awsgi
from flask_cors import CORS
from flask import Flask, jsonify, request
from .app import create_app
app = create_app()
CORS(app)
def handler(event, context):
    return awsgi.response(app, event, context)