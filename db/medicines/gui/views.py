from django.views.generic import TemplateView

from .models import Medicine, Pharmacy, Maker, MakerMedicine


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


class MakersView(TemplateView):
    template_name = "makers.html"

    def get_context_data(self, **kwargs):
        context = super(MakersView, self).get_context_data(**kwargs)
        context['makers'] = Maker.objects.all()
        return context


class MakerMedicinesView(TemplateView):
    template_name = "medicines.html"

    def get_context_data(self, **kwargs):
        context = super(MakerMedicinesView, self).get_context_data(**kwargs)
	maker_id = kwargs.get('maker_id')
	medicines = MakerMedicine.objects.filter(maker_id=maker_id).values_list('medicine_id')
        context['medicines'] = Medicine.objects.filter(id__in=medicines)
        return context
