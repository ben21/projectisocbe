from django.db import models
from django.urls import reverse

class Member(models.Model):
    prefix = models.CharField(max_length=255)
    first_name = models.CharField(max_length=255)
    last_name = models.CharField(max_length=255)
    email_address = models.CharField(max_length=255)
    country = models.CharField(max_length=255)
    street_address = models.CharField(max_length=255)
    locality = models.CharField(max_length=255)
    post_address = models.CharField(max_length=255)
    professional_phone = models.CharField(max_length=255)
    private_phone = models.CharField(max_length=255)
    fax_number = models.CharField(max_length=255)
    title = models.CharField(max_length=255)
    organization = models.CharField(max_length=255)

    def __str__(self):
        return self.last_name

    def get_absolute_url(self):
        return reverse('success')
