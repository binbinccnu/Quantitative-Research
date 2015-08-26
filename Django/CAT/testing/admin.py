from django.contrib import admin
from testing.models import Item, Choice, Answer

class ItemAdmin(admin.ModelAdmin):
    fields = ['question']

class ChoiceInline(admin.TabularInline):
    model = Choice
    extra = 0

class AnswerInline(admin.TabularInline):
    model = Answer
    extra = 0

class ItemAdmin(admin.ModelAdmin):
    inlines = [ChoiceInline, AnswerInline]

admin.site.register(Item, ItemAdmin)