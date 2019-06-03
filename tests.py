from django.urls import resolve
from django.test import TestCase
from django.views.generic.base import TemplateView

class HomePageTest(TestCase):

    def test_root_url_resolves_to_home_page_view(self):
        found = resolve('/')
        self.assertEquals(found.func.view_class, TemplateView)
