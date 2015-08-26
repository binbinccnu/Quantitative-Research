from django.shortcuts import render, get_object_or_404
from django.http import HttpResponse, Http404, HttpResponseRedirect
from testing.models import Item, Choice, Answer, Par
from django.template import RequestContext, loader
from django.core.urlresolvers import reverse
from rpy2 import robjects
import os

r=robjects.r
path=os.getcwd()
path +='/testing/'

r.source('testing/MLE.r')

def index(request):
    return render(request, 'testing/index.html')
def items(request):
    item_list = Item.objects.all()
    context = {'item_list': item_list}
    return render(request, 'testing/items.html',context)
def detail(request, item_id):
    item = get_object_or_404(Item, pk = item_id)
    return render(request, 'testing/detail.html',{'item':item})
def results(request, item_id):
    item = get_object_or_404(Item, pk=item_id)
    count = Item.objects.count()
    last_item = get_object_or_404(Item, pk=count)
    if item.id < count:
        next_item = get_object_or_404(Item, pk=item.id+1)
    else:
        next_item = get_object_or_404(Item, pk=item.id)
    if item.id > 1:
        prev_item = get_object_or_404(Item, pk=item.id-1)
    else:
        prev_item = get_object_or_404(Item, pk=item.id)
    return render(request, 'testing/results.html',
                  {'last_item':last_item,'item':item,'next_item':next_item,'prev_item':prev_item})
def vote(request, item_id):
    p = get_object_or_404(Item, pk=item_id)
    try:
        selected_choice = p.choice_set.get(pk=request.POST['choice'])
    except (KeyError, Choice.DoesNotExist):
        return render(request, 'testing/detail.html', {
            'item':p,
            'error_message': "You didn't select a choice.",})
    else:
        others_choice = p.choice_set.exclude(pk=request.POST['choice'])
        selected_choice.votes = 1
        selected_choice.save()
        for other in range(0,others_choice.count()):
            other_choice = others_choice[other]
            other_choice.votes = 0
            other_choice.save()
    return HttpResponseRedirect(reverse('testing:results', args=(p.id,)))
def final(request):
    item_list = Item.objects.all()
    choice_list=[]
    for item in item_list:
        choice_list.append(item.choice_set.get(votes=1))
        zipped=zip(item_list,choice_list)
    return render(request, 'testing/final.html',{
            'zipped':zipped,})
def score(request):
    total = 0
    response = []
    item_list = Item.objects.all()
    for item in item_list:
        key = item.answer_set.get()
        choice = item.choice_set.get(votes=1)
        if key.answer_text == choice.choice_text:
            total += 1
            response.append(1)
        else:
            response.append(0)
    response=robjects.IntVector(response)
    theta = r.MLE(response,path)
    theta = list(theta)
    return render(request, 'testing/score.html',{
            'total':total,
            'theta':theta,})

