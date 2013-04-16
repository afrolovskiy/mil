from django.conf.urls import patterns
from django.views.generic import TemplateView

from gui.views import MedicinesView, PharmaciesView, MakersView, MakerMedicinesView

urlpatterns = patterns('',
    (r'^medicnes$', MedicinesView.as_view()),
    (r'^pharmacies$', PharmaciesView.as_view()),
    (r'^makers$', MakersView.as_view()),
    (r'^makers/(?P<maker_id>\d{1,5})/pharmacies$', MakerMedicinesView.as_view()),
)
