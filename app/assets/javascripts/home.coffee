# timer = (block, speed) ->
#   milliSec = 0
#   timer = setInterval((->
#     milliSec += 1000
#     $('#' + block).html milliSec / 1000
#     if milliSec / 1000 == 60
#       clearInterval timer
#   ), speed)
#
# $(document).ready ->
#   $(".btn").click ->
#     time = $('#timer').html()
#     $("#review_seconds").val(time)
#
#   timer 'timer', '1000'
