from django.conf.urls import *
from django.views.generic import TemplateView
from django.contrib import admin
from gui.views import (
    MedicinesView, PharmaciesView, MakersView, MakerMedicinesView,
	PharmacyMakerMedicinesView)


admin.autodiscover()

urlpatterns = patterns('',
    (r'^medicnes$', MedicinesView.as_view()),
    (r'^pharmacies$', PharmaciesView.as_view()),
    (r'^pharmacies/costs$', PharmacyMakerMedicinesView.as_view()),
    (r'^makers$', MakersView.as_view()),
    (r'^makers/(?P<maker_id>\d{1,5})/pharmacies$', MakerMedicinesView.as_view()),
    (r'^admin/', include(admin.site.urls)),    
)
