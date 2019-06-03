from selenium import webdriver
import unittest

class NewVisitorTest(unittest.TestCase):

    def setUp(self):
        self.browser = webdriver.Firefox()

    def tearDown(self):
        self.browser.quit()

    def test_home_in_home_page_title(self):
        # Edith has heard about a cool new online to-do app. She goes
        # to check out its homepage
        self.browser.get('http://localhost:8000')

        # She notices the page title and header mention to-do lists
        self.assertIn('Home', self.browser.title)


        # She is invited to enter a to-do item straight away

    def test_login_in_login_page(self):

        self.browser.get('http://localhost:8000/accounts/login/')
        self.assertIn('Login', self.browser.title)

        self.fail('Finish the test!')


if __name__ == '__main__':
     unittest.main(warnings='ignore')
