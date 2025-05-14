from robot.api.deco import keyword

@keyword
def get_doctype_url(url,doctype):
    url = get_base_url(url)+"/app/"
    doctype_name = doctype.lower().replace(' ','-')
    return url+doctype_name

@keyword
def get_base_url(url):
    url_parts = url.split('/')
    return url_parts[0]+"//"+url_parts[2]