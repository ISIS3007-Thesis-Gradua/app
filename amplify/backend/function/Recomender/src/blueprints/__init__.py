from .home import home_bp
def init_layer(app):
    app.register_blueprint(home_bp)