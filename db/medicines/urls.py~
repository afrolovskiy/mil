from django.conf.urls import patterns
from django.views.generic import TemplateView

from gui.views import MedicinesView, PharmaciesView

urlpatterns = patterns('',
    (r'^$', MedicinesView.as_view()),
    (r'^pharmacy$', PharmaciesView.as_view()),
)
