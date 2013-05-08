from django.contrib import admin
from gui.models import Maker, Medicine, Pharmacy, MakerMedicine, PharmacyMakerMedicine

class MakerAdmin(admin.ModelAdmin):
    list_display = ('id', 'name', )

class MedicineAdmin(admin.ModelAdmin):
    list_display = ('id', 'name', )

class PharmacyAdmin(admin.ModelAdmin):
    list_display = ('id', 'name', )

def maker(obj):
    return obj.maker.name
maker.short_description = 'Maker'

def medicine(obj):
    return obj.medicine.name
medicine.short_description = 'Medicine'

def pharmacy(obj):
    return obj.pharmacy.name
pharmacy.short_description = 'Pharmacy'

class MakerMedicineAdmin(admin.ModelAdmin):
    list_display = ('id', maker, medicine)

class PharmacyMakerMedicineAdmin(admin.ModelAdmin):
    list_display = ('id', pharmacy, maker, medicine)

admin.site.register(Maker, MakerAdmin)
admin.site.register(Medicine, MedicineAdmin)
admin.site.register(Pharmacy, PharmacyAdmin)
admin.site.register(MakerMedicine, MakerMedicineAdmin)
admin.site.register(PharmacyMakerMedicine, PharmacyMakerMedicineAdmin)
