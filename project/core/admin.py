from django.contrib import admin
from django.utils.translation import gettext_lazy

# overriding default AdminSite instance 'admin_site' properties

# Text to put at the end of each page's <title>.
admin.site.site_title = gettext_lazy("eCommerce API")

# Text to put in each page's <h1>.
admin.site.site_header = gettext_lazy("eCommerce API Administration")

# Text to put at the top of the admin index page.
admin.site.index_title = gettext_lazy("Administration")
