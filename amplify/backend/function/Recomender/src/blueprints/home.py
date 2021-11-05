from flask import  Blueprint, jsonify
from ..services import home as home_logic
home_bp = Blueprint('home', __name__, url_prefix='/home')

@home_bp.route('/recomend')
def home():
    return jsonify(home_logic.home())