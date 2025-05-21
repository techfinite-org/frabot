import frappe
from robot import run


def main():
    frappe.init(site='claimgenie.local')
    frappe.connect()
    file = frappe.get_app_path('agarwals', 'tests', 'rough_work', 'test_get_cost_center.robot')
    run(file)