import os
from flask import Flask

def create_app(config=None):
    app = Flask(__name__)
    # # load default configuration
    # #app.config.from_object('.settings')
    # # load environment configuration
    if 'FLASK_CONF' in os.environ:
        app.config.from_envvar('FLASK_CONF')
    # # load app sepcified configuration
    if config is not None:
        if isinstance(config, dict):
            app.config.update(config)
        elif config.endswith('.py'):
            app.config.from_pyfile(config)
    # load layers
    from . import services, blueprints
    services.init_layer(app)
    blueprints.init_layer(app)
    
    # result
    return app