from django.contrib import admin

from testing.models import Item, Choice, Answer, Par

class ChoiceInline(admin.TabularInline):
    model = Choice
    extra = 0
class AnswerInline(admin.TabularInline):
    model = Answer
    extra = 0
class ParInline(admin.TabularInline):
    model = Par
    extra = 0
    
class ItemAdmin(admin.ModelAdmin):
    inlines = [ChoiceInline, AnswerInline, ParInline]


admin.site.register(Item, ItemAdmin)
