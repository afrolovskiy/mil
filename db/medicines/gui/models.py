# -*- coding: utf-8 -*-
import json

from django.db import models


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

    @property
    def working_time_str(self):
        week_days = [u'пн',  u'вт', u'ср', u'чт', u'пт', u'сб', u'вс']
        working_time = json.loads(self.working_time)
        days = zip(week_days, working_time)
        result = u''
        for idx in range(0, 7):
            day = days[idx]
            print day
            if day[1] is not None:
                result += u'%s %s-%s ' % (day[0], day[1][0], day[1][1])
            else:
                result += u'%s - вых ' % day[0]
        print result
        return result