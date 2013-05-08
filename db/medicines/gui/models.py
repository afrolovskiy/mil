# -*- coding: utf-8 -*-
import json

from django.db import models


class Maker(models.Model):
    id = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=255)
    created_at = models.DateTimeField()
    country = models.CharField(max_length=255)

    class Meta:
        db_table = 'makers'


class Medicine(models.Model):
    id = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=255)
    is_recipe = models.BooleanField()
    route = models.TextField()

    class Meta:
        db_table = 'medicines'


class Pharmacy(models.Model):
    id = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=255)
    address = models.CharField(max_length=255)
    working_time = models.CharField(max_length=255)

    class Meta:
        db_table = 'pharmacies'

    def working_time_str(self):
        week_days = [u'пн',  u'вт', u'ср', u'чт', u'пт', u'сб', u'вс']
        days = zip(week_days, json.loads(self.working_time))
        result = u''
        for day in days:
            if day[1] is not None:
                result += u'%s %s-%s ' % (day[0], day[1][0], day[1][1])
            else:
                result += u'%s - вых ' % day[0]
        return result
    working_time_str.allow_tags = True



class MakerMedicine(models.Model):
    id = models.IntegerField(primary_key=True)
    medicine = models.ForeignKey(Medicine)
    maker = models.ForeignKey(Maker)

    class Meta:
        db_table = 'medicines_makers'


class PharmacyMakerMedicine(models.Model):
    id = models.IntegerField(primary_key=True)
    medicine = models.ForeignKey(Medicine)
    maker = models.ForeignKey(Maker)
    pharmacy = models.ForeignKey(Pharmacy)
    cost = models.IntegerField()

    class Meta:
        db_table = 'medicines_makers_pharmacies'
