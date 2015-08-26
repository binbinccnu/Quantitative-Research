from django.db import models

class Item(models.Model):
    question = models.CharField(max_length=200)
    def __unicode__(self):
        return self.question
   
class Choice(models.Model):
    item = models.ForeignKey(Item)
    choice_text = models.CharField(max_length=200)
    votes = models.IntegerField(default=0)
    def __unicode__(self):
        return self.choice_text

class Answer(models.Model):
    item = models.ForeignKey(Item)
    answer_text = models.CharField(max_length=200)
    def __unicode__(self):
        return self.answer_text

class Stuent(models.Model):
    name = models.CharField(max_length=200)
    response =
    selected_items =