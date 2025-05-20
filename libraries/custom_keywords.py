from robot.api.deco import keyword

@keyword
def get_doctype_url(url: str,doctype: str) -> str:
    url = get_base_url(url)+"/app/"
    doctype_name = doctype.lower().replace(' ','-')
    return url+doctype_name

@keyword
def get_base_url(url: str) -> str:
    url_parts = url.split('/')
    return url_parts[0]+"//"+url_parts[2]