from django.conf.urls import patterns, include, url
from django.contrib import admin
admin.autodiscover()

urlpatterns = patterns('',
    url(r'^testing/', include('testing.urls',namespace='testing')),
    url(r'^admin/',include(admin.site.urls)),                   
)
