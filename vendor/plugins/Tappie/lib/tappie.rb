#
# Feel free to copy the following code and use it instead of gem installing it.
# Do not forget the MIT license attached.
#
# Copyright (c) 2010 guilherme silveira - caelum.com.br
# 
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
module Tappie
  
  # taps and returns the object itself.
  #
  # if the block has arity one, the object will be passed as an argument.
  # if the block has no arity, the object is the scope (old style).
  # if there is no block, just taps (why, why?).
  def tap(&block)
    if block_given?
      if block.arity==1
        yield self
      else
        self.instance_eval(&block)
      end
    end
    self
  end
end

class Object
  include Tappie
end