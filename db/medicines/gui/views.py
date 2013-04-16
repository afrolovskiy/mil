from django.views.generic import TemplateView

from .models import Medicine, Pharmacy


class MedicinesView(TemplateView):
    template_name = "medicines.html"

    def get_context_data(self, **kwargs):
        context = super(MedicinesView, self).get_context_data(**kwargs)
        context['medicines'] = Medicine.objects.all()
        return context


class PharmaciesView(TemplateView):
    template_name = "pharmacies.html"

    def get_context_data(self, **kwargs):
        context = super(PharmaciesView, self).get_context_data(**kwargs)
        context['pharmacies'] = Pharmacy.objects.all()
        return context
