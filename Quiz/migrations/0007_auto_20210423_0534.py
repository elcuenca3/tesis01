# Generated by Django 3.1.7 on 2021-04-23 10:34

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('Quiz', '0006_auto_20210422_0557'),
    ]

    operations = [
        migrations.AlterField(
            model_name='preguntasrespondidas',
            name='respuesta',
            field=models.ForeignKey(default=1, on_delete=django.db.models.deletion.CASCADE, related_name='intentos', to='Quiz.elegirrespuesta'),
            preserve_default=False,
        ),
    ]
