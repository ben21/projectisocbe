from django.views.generic.edit import CreateView
from django.views.generic import TemplateView
from .models import Member

class MemberCreateView(CreateView):
    model = Member
    template_name = 'members/registration.html'
    fields = '__all__'

class SuccessView(TemplateView):
    template_name = 'members/success.html'
