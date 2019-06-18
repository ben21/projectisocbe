from django.db import models
from django.urls import reverse

class Member(models.Model):
    prefix = models.CharField(max_length=11)
    first_name = models.CharField(max_length=25)
    last_name = models.CharField(max_length=30)
    email_address = models.EmailField(max_length=255)
    country = models.CharField(max_length=255)
    street_address = models.CharField(max_length=255)
    locality = models.CharField(max_length=255)
    post_address = models.CharField(max_length=255)
    professional_phone = models.CharField(max_length=20)
    private_phone = models.CharField(max_length=25)
    fax_number = models.CharField(max_length=25)
    title = models.CharField(max_length=25)
    organization = models.CharField(max_length=40)

    def __str__(self):
        return self.last_name

    def get_absolute_url(self):
        return reverse('success')
