import os,json

CURRENT_DIR = os.path.dirname(__file__)
CONFIG_PATH = os.path.join(CURRENT_DIR, '..', 'config.json')
CONFIG_PATH = os.path.abspath(CONFIG_PATH)

def get_config():
    with open(CONFIG_PATH, 'r') as f:
        return json.load(f)


CONFIG = frappe.get_doc('')


