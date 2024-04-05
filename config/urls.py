from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.views import defaults as default_views
from django.views.generic import TemplateView
from django.views.generic.base import RedirectView
from drf_spectacular.views import (
    SpectacularAPIView,
    SpectacularRedocView,
    SpectacularSwaggerView,
)

# settings
DEBUG = settings.DEBUG
INSTALLED_APPS = settings.INSTALLED_APPS
ADMIN_URL = settings.ADMIN_URL

urlpatterns = [
    path(
        "",
        TemplateView.as_view(template_name="pages/home.html"),
        name="home",
    ),
    # Favicon
    path("favicon.ico", RedirectView.as_view(url="/static/images/icons/favicon.ico")),
    # Django Admin
    path(ADMIN_URL, admin.site.urls),
    # API URLS
    # REST framework's login and logout views
    path("api-auth/", include("rest_framework.urls")),
    # DRF Spectacular
    path("api/schema/", SpectacularAPIView.as_view(), name="schema"),
    path(
        "api/schema/swagger-ui/",
        SpectacularSwaggerView.as_view(url_name="schema"),
        name="swagger-ui",
    ),
    path(
        "api/schema/redoc/",
        SpectacularRedocView.as_view(url_name="schema"),
        name="redoc",
    ),
    # [API NAME]
    # Your [API NAME] URLS...
]

# for development environment only
if DEBUG:
    # Activate Django debug toolbar
    if "debug_toolbar" in INSTALLED_APPS:
        import debug_toolbar

        urlpatterns += [
            path("__debug__/", include(debug_toolbar.urls)),
        ]

    # This allows the error pages to be debugged during development, just visit
    # these url in browser to see how these error pages look like.
    urlpatterns += [
        path(
            "400/",
            default_views.bad_request,
            kwargs={"exception": Exception("Permission Denied")},
        ),
        path(
            "403/",
            default_views.permission_denied,
            kwargs={"exception": Exception("Permission Denied")},
        ),
        path(
            "404/",
            default_views.page_not_found,
            kwargs={"exception": Exception("Page not Found")},
        ),
        path(
            "500/",
            default_views.server_error,
        ),
    ]
