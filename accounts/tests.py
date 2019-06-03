from django.http import HttpRequest
from django.test import SimpleTestCase
from django.urls import reverse

from . import views

class Sign_up_test(SimpleTestCase):

    def test_sign_up_page_status_code(self):
        response = self.client.get('/accounts/signup/')
        self.assertEquals(response.status_code, 200)

    def test_signup_by_name(self):
        response = self.client.get(reverse('signup'))
        self.assertEquals(response.status_code, 200)

    def test_view_uses_correct_template(self):
        response = self.client.get(reverse('signup'))
        self.assertEquals(response.status_code, 200)
        self.assertTemplateUsed(response, 'signup.html')

    def test_signup_page_contains_correct_html(self):
        response = self.client.get('/accounts/signup/')
        self.assertContains(response, '<h2>Sign up</h2>')

    def test_signup_page_does_not_contain_incorrect_html(self):
        response = self.client.get('/accounts/signup/')
        self.assertNotContains(
            response, 'Hi there! I should not be on the page.')

