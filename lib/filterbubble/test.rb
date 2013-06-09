# -*- coding: utf-8 -*-
require 'crm114'

crm = Classifier::CRM114.new([:interesting, :boring])

crm.train! :interesting, 'The scripts below are set up to simply give a HAM/SPAM/FISH message instead of acting as a filter. If the script reports ‘FISH’, then that means that crm114 was uncertain about whether it was spam or not: the email smells fishy but may be ham after all. Every piece of email in the fish category needs to be fed back to crm114 to train it. You should also train crm114 on false positives and false negatives, but those should be rare with this system.'
crm.train! :boring, 'Pig latin, as in lorem ipsum dolor sit amet.'

print (crm.classify 'Lorem ipsum')
print "\n"
print (crm.interesting? 'Lorem ipsum')
print "\n"
print (crm.boring? 'Lorem ipsum')
print "\n"
