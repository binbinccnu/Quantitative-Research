from django.shortcuts import render
from django.http import HttpResponse, Http404, HttpResponseRedirect
from django.template import RequestContext, loader
from polls.models import Poll, Choice
from django.shortcuts import get_object_or_404, render
from django.core.urlresolvers import reverse

def index(request):
    return render(request,'polls/index.html')

def items(request):
    latest_poll_list = Poll.objects.order_by('pub_date')
    template = loader.get_template('polls/items.html')
    context = RequestContext(request, {
        'latest_poll_list': latest_poll_list,
        })
    return HttpResponse(template.render(context))

def detail(request, poll_id):
    try:
        poll = Poll.objects.get(pk=poll_id)
    except Poll.DoesNotExist:
        raise Http404
    return render(request, 'polls/detail.html', {'poll':poll})

def results(request, poll_id):
    poll = get_object_or_404(Poll, pk=poll_id)
    count = Poll.objects.count()
    last_poll = get_object_or_404(Poll, pk=count)
    if poll.id < count:
        next_poll = get_object_or_404(Poll, pk=poll.id+1)
    else:
        next_poll = get_object_or_404(Poll, pk=poll.id)
    if poll.id > 1:
        prev_poll = get_object_or_404(Poll, pk=poll.id-1)
    else:
        prev_poll = get_object_or_404(Poll, pk=poll.id)
    return render(request, 'polls/results.html',
                  {'last_poll':last_poll,'poll':poll,'next_poll':next_poll,'prev_poll':prev_poll})

def vote(request, poll_id):
    p = get_object_or_404(Poll, pk=poll_id)
    
    try:
        selected_choice = p.choice_set.get(pk=request.POST['choice'])
        other_choices = p.choice_set.exclude(pk=request.POST['choice'])
    except (KeyError, Choice.DoesNotExist):
        # Redisplay the poll voting form.
        return render(request, 'polls/detail.html', {
            'poll': p,
            'error_message': "You didn't select a choice.",
        })
    else:
        selected_choice.votes = 1
        for other in range(0,other_choices.count()):
            other_choice = other_choices[other]
            other_choice.votes=0
            other_choice.save()
            
        selected_choice.save()
        
        # Always return an HttpResponseRedirect after successfully dealing
        # with POST data. This prevents data from being posted twice if a
        # user hits the Back button.
        return HttpResponseRedirect(reverse('polls:results', args=(p.id,)))

def final(request):
    return render(request, 'polls/final.html')
