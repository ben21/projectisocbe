from django.urls import resolve
from django.test import TestCase
from django.views.generic.base import TemplateView

class HomePageTest(TestCase):

    def test_root_url_resolves_to_home_page_view(self):
        found = resolve('/')
        self.assertEquals(found.func.view_class, TemplateView)

    def test_a_propos(self):
        found = resolve('/pages/a-propos/')
        self.assertEquals(found.status, 200)

    def test_notre_misson(self):
        found = resolve('/pages/notre-mission/')
        self.assertEquals(found.status, 200)

    def test_isoc_dans_le_monde(self):
        found = resolve('/pages/isoc-dans-le-monde')
        self.assertEquals(found.status, 200)

