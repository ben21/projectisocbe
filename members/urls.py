from django.urls import path
from .views import MemberCreateView, SuccessView

urlpatterns = [
    path('new/', MemberCreateView.as_view(), name='signup'),
    path('success/', SuccessView.as_view(), name='success'),
]
