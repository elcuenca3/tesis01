from .models import QuizUsuario, PreguntasRespondidas, ElegirRespuesta

from django.contrib.auth.decorators import login_required
from django.contrib.auth import logout


import string
import time
from tkinter.tix import INTEGER
from django.shortcuts import render, redirect, get_object_or_404
from django.urls import reverse

from django.views.generic import ListView
from Quiz.sistemafuzzy import sistemaFuzzy

from .forms import RegistroFormulario, UsuarioLoginFormulario

from django.core.exceptions import ValidationError, MultipleObjectsReturned

from .models import Carrera, QuizUsuario, Pregunta, PreguntasRespondidas, ElegirRespuesta, Materias, Cuestionarios

from django.http import Http404, HttpResponse, JsonResponse

from django.core.exceptions import ObjectDoesNotExist
from django.contrib.auth import authenticate, login


array = []
sec = 1800
t_pregunta = 0
ultima = 0
pregunta = None
getP = True
bandera = False
nombre_usuario = ''


def inicio(request):
    global sec
    sec = 1800
    global t_pregunta
    t_pregunta = 0
    global ultima
    ultima = 0
    global pregunta
    pregunta = None
    global getP
    getP = True
    global bandera
    bandera = False
    global array
    array = []
    global nombre_usuario

    nombre_usuario = request.POST.get('nombre_estudiante')

    if request.method == 'POST':
        if nombre_usuario != '' and nombre_usuario is not None:
            if len(nombre_usuario) > 10:
                context = {
                    'alerta': 'El nombre ingresado tiene más de 10 caracteres.'
                }
                return render(request, 'inicio.html', context)
            try:
                QuizUsuario.objects.get_or_create(
                    usuario=get_client_ip(request), nombre=nombre_usuario)
            except:
                context = {
                    'alerta': 'Ingrese otro nombre de usuario'
                }
                return render(request, 'inicio.html', context)
            return redirect('jugar')
    return render(request, 'inicio.html')


def tablero(request):
    global nombre_usuario
    try:
        QuizUser = QuizUsuario.objects.get(
            usuario=get_client_ip(request), nombre=nombre_usuario)
        n_preguntas = QuizUser.num_p
    except:
        n_preguntas = 0

    total_usaurios_quiz = QuizUsuario.objects.order_by('-puntaje_total')[:10]
    contador = total_usaurios_quiz.count()

    context = {
        'user': nombre_usuario,
        'usuario_quiz': total_usaurios_quiz,
        'contar_user': contador
    }

    if n_preguntas >= 20:
        codigo = get_client_ip(request) + '.' + nombre_usuario
        context = {
            'user': nombre_usuario,
            'usuario_quiz': total_usaurios_quiz,
            'contar_user': contador,
            'codigo': 'Su código es: ' + codigo
        }

    return render(request, 'play/tablero.html', context)


def get_client_ip(request):
    x_forwarded_for = request.META.get('HTTP_X_FORWARDED_FOR')
    if x_forwarded_for:
        ip = x_forwarded_for.split(',')[0]
    else:
        ip = request.META.get('REMOTE_ADDR')
    return ip


# def jugar(request):
    global array
    global sec
    global t_pregunta
    global ultima
    global pregunta
    global getP
    global bandera
    global nombre_usuario

    try:
        QuizUser = QuizUsuario.objects.get(
            usuario=get_client_ip(request), nombre=nombre_usuario)
    except:
        QuizUser = QuizUsuario.objects.filter(
            usuario=get_client_ip(request)).last()
        nombre_usuario = QuizUser.nombre

    context = {
        'pregunta': pregunta,
        'n_pregunta': QuizUser.num_p + 1,
        'array': len(array),
        'sec': sec,
    }
    if request.GET.get('bandera', False):
        bandera = True

    if request.method == 'POST':

        pregunta_pk = request.POST.get('pregunta_pk')

        respuesta_pk = request.POST.get('respuesta_pk')

        if respuesta_pk is None:
            return render(request, 'play/jugar.html', context)

        ultima = t_pregunta
        QuizUser.crear_intentos(pregunta)
        pregunta_respondida = QuizUser.intentos.select_related(
            'pregunta').filter(pregunta__pk=pregunta_pk).last()
        print(type(pregunta_respondida))
        opcion_selecionada = pregunta_respondida.pregunta.opciones.get(
            pk=respuesta_pk)
        array.append(pregunta_respondida)

        dificultad = pregunta.dificultad

        calificacion = QuizUser.validar_intento(
            pregunta_respondida, opcion_selecionada, dificultad, bandera, ultima)

        sistemaFuzzy(calificacion, ultima, bandera, dificultad)

        getP = True
        bandera = False

        return redirect('resultado', pregunta_respondida.pk)

    else:
        if len(array) <= 20 and getP == True:
            pregunta = QuizUser.obtener_nuevas_preguntas()
            if pregunta is None:
                return render(request, 'play/jugar.html', {'array': 20})

            getP = False
        else:
            context = {
                'n_pregunta': QuizUser.num_p + 1,
                'array': len(array),
                'sec': sec,

            }
    try:
        correcta = obtenerCorrecta(pregunta.id, ElegirRespuesta)
    except AttributeError:
        context = {
            'array': 20
        }
        return render(request, 'play/jugar.html', context)
    context = {
        'pregunta': pregunta,
        'n_pregunta': QuizUser.num_p + 1,
        'array': len(array),
        'sec': sec,
        'correcta': correcta,
    }

    sec = request.GET.get('sec', None)

    if sec != None:
        t_pregunta = 1800 - int(sec) - ultima

    return render(request, 'play/jugar.html', context)


def resultado(request, pregunta_respondida_pk):
    respondida = get_object_or_404(
        PreguntasRespondidas, pk=pregunta_respondida_pk)

    context = {
        'respondida': respondida
    }
    return render(request, 'play/resultado.html', context)


def sinTiempo(request):

    return render(request, 'play/sinTiempo.html')


def comentario(request):

    QuizUser = QuizUsuario.objects.get(
        usuario=get_client_ip(request), nombre=nombre_usuario)
    coment = request.POST.get('comentario')

    context = {
        'bandera': False
    }

    if request.method == 'POST':
        QuizUser.guardar_comentario(coment)
        context = {
            'bandera': True,
            'gracias': 'Gracias por tu comentario'
        }

    return render(request, 'comentario.html', context)


def registro(request):
    global sec
    sec = 1800
    global t_pregunta
    t_pregunta = 0
    global ultima
    ultima = 0
    global pregunta
    pregunta = None
    global getP
    getP = True
    global bandera
    bandera = False
    global array
    array = []
    global nombre_usuario

    nombre_usuario = request.POST.get('nombre_estudiante')

    if request.method == 'POST':
        if nombre_usuario != '' and nombre_usuario is not None:
            if len(nombre_usuario) > 10:
                context = {
                    'alerta': 'El nombre ingresado tiene más de 10 caracteres.'
                }
                return render(request, 'registro.html', context)
            try:
                QuizUsuario.objects.get_or_create(
                    usuario=get_client_ip(request), nombre=nombre_usuario)
            except:
                context = {
                    'alerta': 'Ingrese otro nombre de usuario'
                }
                return render(request, 'registro.html', context)
            return redirect('jugar')
    return render(request, 'registro.html')


def mostrar_cuestionarios(request):
    cuestionarios = Cuestionarios.objects.all()

    if request.method == 'POST':
        cuestionario_id = request.POST.get('cuestionario_id')
        if cuestionario_id:
            selected_cuestionario = get_object_or_404(
                Cuestionarios, pk=cuestionario_id)
            preguntas = Pregunta.objects.filter(
                cuestionario_id=selected_cuestionario)
        else:
            preguntas = Pregunta.objects.all()
    else:
        preguntas = Pregunta.objects.all()
        selected_cuestionario = None

    context = {
        'cuestionarios': cuestionarios,
        'preguntas': preguntas,
        'selected_cuestionario': selected_cuestionario,
    }

    return render(request, 'cuestionario.html', context)

# def materia(request):
#     materias = Materias.objects.all()

#     context = {
#         'materias': materias,
#     }
#     return render(request, 'materia.html', context)


def materia(request):
    materias = Materias.objects.all()
    return render(request, 'materia.html', {'materias': materias})


def filfer(request, idMateria):
    materia = get_object_or_404(Materias, pk=idMateria)

    return render(request, 'detalle_materia.html', {'materia': materia})


def obtenerCorrecta(pregunta_id, respuesta):

    correcta = respuesta.objects.filter(
        pregunta=pregunta_id, correcta=True).get()

    return correcta

# pruebas

@login_required
def lista_carreras(request):
    carreras = Carrera.objects.all()
    return render(request, 'lista_carreras.html', {'carreras': carreras})

@login_required

def lista_materias(request, id_carrera):
    carrera = get_object_or_404(Carrera, pk=id_carrera)
    materias = Materias.objects.filter(idCarrera=carrera)
    return render(request, 'lista_materias.html', {'materias': materias})

@login_required

def lista_cuestionarios(request, id_materia):
    materia = get_object_or_404(Materias, pk=id_materia)
    cuestionarios = Cuestionarios.objects.filter(idMateria=materia)
    return render(request, 'lista_cuestionarios.html', {'cuestionarios': cuestionarios})

@login_required

def lista_preguntas(request, id_cuestionario):
    cuestionario = get_object_or_404(Cuestionarios, pk=id_cuestionario)
    preguntas = Pregunta.objects.filter(cuestionario_id=cuestionario)
    return render(request, 'lista_preguntas.html', {'preguntas': preguntas})


# Importa los modelos y vistas necesarios al principio del archivo views.py

# ... (código existente)


def jugar(request):
    global array
    global sec
    global t_pregunta
    global ultima
    global getP
    global bandera
    global nombre_usuario
    global pregunta

    try:
        quiz_user = QuizUsuario.objects.get(
            usuario=get_client_ip(request), nombre=nombre_usuario)
    except QuizUsuario.DoesNotExist:
        quiz_user = QuizUsuario.objects.filter(
            usuario=get_client_ip(request)).last()
        nombre_usuario = quiz_user.nombre

    context = {
        'pregunta': pregunta,
        'n_pregunta': quiz_user.num_p + 1,
        'array': len(array),
        'sec': sec,
    }

    if request.GET.get('bandera', False):
        bandera = True

    if request.method == 'POST':
        pregunta_pk = request.POST.get('pregunta_pk')
        respuesta_pk = request.POST.get('respuesta_pk')

        if respuesta_pk is None:
            return render(request, 'play/jugar.html', context)

        ultima = t_pregunta
        quiz_user.crear_intentos(pregunta)
        pregunta_respondida = PreguntasRespondidas.objects.filter(
            quizUser=quiz_user, pregunta__pk=pregunta_pk).last()

        opcion_seleccionada = ElegirRespuesta.objects.get(pk=respuesta_pk)
        array.append(pregunta_respondida)

        dificultad = pregunta.dificultad

        calificacion = quiz_user.validar_intento(
            pregunta_respondida, opcion_seleccionada, dificultad, bandera, ultima)

        sistemaFuzzy(calificacion, ultima, bandera, dificultad)

        getP = True
        bandera = False

        return redirect('resultado', pregunta_respondida.pk)

    else:
        if len(array) <= 20 and getP:
            pregunta = quiz_user.obtener_nuevas_preguntas()
            if pregunta is None:
                return render(request, 'play/jugar.html', {'array': 20})

            getP = False
        else:
            context = {
                'n_pregunta': quiz_user.num_p + 1,
                'array': len(array),
                'sec': sec,
            }

    try:
        correcta = obtenerCorrecta(pregunta.id, ElegirRespuesta)
    except AttributeError:
        context = {
            'array': 20
        }
        return render(request, 'play/jugar.html', context)

    context = {
        'pregunta': pregunta,
        'n_pregunta': quiz_user.num_p + 1,
        'array': len(array),
        'sec': sec,
        'correcta': correcta,
    }

    sec = request.GET.get('sec', None)

    if sec is not None:
        t_pregunta = 1800 - int(sec) - ultima

    return render(request, 'play/jugar.html', context)

# login and register


def salir(request):
    logout(request)
    return redirect('inicio')

def register(request):
    data = {
        'form': RegistroFormulario()
    }

    if request.method == 'POST':
        user_creation_form = RegistroFormulario(data=request.POST)

        if user_creation_form.is_valid():
            user_creation_form.save()

            user = authenticate(username=user_creation_form.cleaned_data['username'], password=user_creation_form.cleaned_data['password1'])
            login(request, user)
            return redirect('inicio')
        else:
            data['form'] = user_creation_form

    return render(request, 'registration/register.html', data)