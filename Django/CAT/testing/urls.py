from django.conf.urls import patterns, url
from testing import views
from django.contrib import admin
from django.conf import settings


urlpatterns = patterns('',
    url(r'^$', views.index, name = 'index'),
    url(r'^items/$', views.items, name = 'items'),
    url(r'^(?P<item_id>\d+)/$', views.detail, name = 'detail'),
    url(r'^(?P<item_id>\d+)/results/$', views.results, name = 'results'),
    url(r'^(?P<item_id>\d+)/votes/$', views.votes, name = 'votes'),
    url(r'^score/$', views.score, name = 'score')
)

