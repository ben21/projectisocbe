# Generated by Django 2.2.2 on 2019-06-17 19:12

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Member',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('prefix', models.CharField(max_length=255)),
                ('first_name', models.CharField(max_length=255)),
                ('last_name', models.CharField(max_length=255)),
                ('email_address', models.CharField(max_length=255)),
                ('country', models.CharField(max_length=255)),
                ('street_address', models.CharField(max_length=255)),
                ('locality', models.CharField(max_length=255)),
                ('post_address', models.CharField(max_length=255)),
                ('professional_phone', models.CharField(max_length=255)),
                ('private_phone', models.CharField(max_length=255)),
                ('fax_number', models.CharField(max_length=255)),
                ('title', models.CharField(max_length=255)),
                ('organization', models.CharField(max_length=255)),
            ],
        ),
    ]
