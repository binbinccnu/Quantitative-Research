from django.shortcuts import render, get_object_or_404
from django.http import HttpResponse, Http404, HttpResponseRedirect
from testing.models import Item, Choice, Answer
from django.template import RequestContext, loader
from django.core.urlresolvers import reverse
from rpy2 import robjects
import os

r=robjects.r
path=os.getcwd()
path +='/testing/'
os.chdir(path)

r.source('MLE.r')
r.source('FI.r')
first_item = 5   #initial item
test_length = 5  #test length


def index(request):
    return render(request, 'testing/index.html')

def items(request):
    item = Item.objects.get(pk = first_item)
    context = {'item': item}

    selected_items = first_item #selected items
    f = file('selected_items.txt','w')
    f.write(str())
    f.close()

    f = file('response.txt','w')
    f.write(str())
    f.close()

    return render(request, 'testing/items.html',context)

def detail(request, item_id):
    item = get_object_or_404(Item, pk = item_id)
    return render(request, 'testing/detail.html',{'item':item})

def votes(request, item_id):
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


def results(request, item_id):
    item = get_object_or_404(Item, pk=item_id)
    choice = item.choice_set.get(votes=1) #get the choice of this item
    key = item.answer_set.get()
    
    # generate response file, first open txt file, update and save
    f = open('response.txt','r') #only read from it
    response = f.readlines()
    f.close()
    
    if key.answer_text == choice.choice_text:
        response.append(str(1)+'\n')
    else:
        response.append(str(0)+'\n')
    f = open('response.txt','w')
    for response_index in response:
        f.write(str(response_index))
    f.close()

    # generate selected_items file
    f = open('selected_items.txt','r')
    selected_items= f.readlines()
    f.close()
    selected_items.append(str(item_id)+'\n')
    f = open('selected_items.txt','w')
    for item_index in selected_items:
        f.write(str(item_index))
    f.close()

    response=robjects.IntVector(response)
    selected_items = robjects.IntVector(selected_items)
    theta = r.MLE(response,selected_items,path)

    if len(selected_items) < test_length:
        ## get next item based on fisher information computation
        #first get MLE estimate
        #get next item
        next_id = r.FI(theta,selected_items,path)
        next_id = list(next_id)
        next_id = next_id.pop()
        next_item = get_object_or_404(Item, pk=next_id)
    else:
        next_item = get_object_or_404(Item, pk=item.id)
    theta = list(theta)
    return render(request, 'testing/results.html',
                  {'item':item,'next_item':next_item,'theta':theta,})


def score(request):
    f = open('response.txt','r') #only read from it
    response = f.readlines()
    f.close()
    f = open('selected_items.txt','r')
    selected_items= f.readlines()
    f.close()
    response=robjects.IntVector(response)
    selected_items = robjects.IntVector(selected_items)
    
    theta = r.MLE(response,selected_items,path)
    theta = list(theta)
    return render(request, 'testing/score.html',{
            'theta':theta,})

