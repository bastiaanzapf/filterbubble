
require 'pg'

@db = PGconn.open(:dbname=>"filterbubble")
