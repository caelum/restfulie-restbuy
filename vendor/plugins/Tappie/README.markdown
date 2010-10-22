= tappie

Tappie goes a "long" way in improving Ruby's tap method, which is similar to Rail's returning method.

It allows you to remove the syntax noise from that extra variable:

	puts "Guilherme Silveira".tap { puts size }
	# 18
	# Guilherme Silveira
	
## Benefits ##

	Less noise if you are not using @variables of the current scope.
	Less code.
	
## Compatibility issues ##

	Because tappie checks the Proc arity, it is fully compatible.
	
## How to use configure it? ##

Either copy tappie.rb code to your project or gem install it:

	gem install tappie

Have fun!

== Team

Guilherme Silveira - Caelum

== Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

== Copyright

Copyright (c) 2010 guilherme silveira. See LICENSE for details.
