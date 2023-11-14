from django.urls import path

from .views import (
    inicio,
    jugar,
    sinTiempo,
    tablero,
    sinTiempo,
    resultado,
    comentario,
    registro,
    materia,
    filfer,
    mostrar_cuestionarios,
    lista_carreras,
    lista_cuestionarios, lista_materias, lista_preguntas,
    salir,register)

urlpatterns = [

    path('', inicio, name='inicio'),
    path('tablero/', tablero, name='tablero'),
    path('jugar/', jugar, name='jugar'),
    path('sinTiempo/', sinTiempo, name='sinTiempo'),
    path('resultado/<int:pregunta_respondida_pk>', resultado, name='resultado'),
    path('comentario/', comentario, name='comentario'),
    path('registro/', registro, name='registro'),
    # path('materia/', materia, name='materia'),
    # path('materia/<int:idMateria>', filfer, name='detalles_materia'),
    # path('cuestionario',mostrar_cuestionarios,name='Cuestionario')
    # prueba
    path('carreras/', lista_carreras, name='lista_carreras'),
    path('materias/<int:id_carrera>/', lista_materias, name='lista_materias'),
    path('cuestionarios/<int:id_materia>/',
         lista_cuestionarios, name='lista_cuestionarios'),
    path('preguntas/<int:id_cuestionario>/',
         lista_preguntas, name='lista_preguntas'),
    path('logout/', salir, name='exit'),
    path('register/', register, name='register'),


]
