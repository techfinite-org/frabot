import frappe
from robot import run
# from .files_to_execute import FILES
import os
from datetime import datetime

FILES = ['tests/test_script.robot']

def get_report_path(app_path,report_name):
    output_dir = os.path.join(app_path, "tests", "output")
    if report_name:
        base_name = report_name
    else:
        base_name = "report_" + datetime.now().strftime("%Y%m%d_%H%M%S")
    output_file = os.path.join(output_dir, f"{base_name}_output.xml")
    log_file = os.path.join(output_dir, f"{base_name}_log.html")
    report_file = os.path.join(output_dir, f"{base_name}.html")
    return output_file, log_file, report_file

def execute(site_name,files=FILES,report_name=""):
    frappe.init(site=site_name)
    frappe.connect()
    app_path = frappe.get_app_path('frabot')
    full_paths = [os.path.join(app_path, f) for f in files]
    output_file,log_file,report_file = get_report_path(app_path,report_name)
    run(*full_paths, output=output_file,log=log_file,report=report_file)
    frappe.destroy()



