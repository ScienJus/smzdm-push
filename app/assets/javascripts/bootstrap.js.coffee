jQuery ->
  $("a[rel~=popover], .has-popover").popover()
  $("a[rel~=tooltip], .has-tooltip").tooltip()

  $(".btn-key").click ->
    $("#input-keyword").val($(this).text())

  $("#submit-keyword").click ->
    keyword = $("#input-keyword").val()
    $.ajax
      url: "/keywords/#{keyword}/subscribe"
      method: "post"
      success: (data) ->
        if data['success']
          $("#tr-tools").before("<tr><td>#{keyword}</td><td><button type='button' class='btn btn-danger btn-remove'>删除</button></td></td>")
          $("#input-keyword").val("")
          $("#create-modal").modal("toggle")
        else
          alert data['message']
        end

  $(".btn-remove").click ->
    btn = $(this)
    keyword_id = btn.attr("keyword_id")
    $.ajax
      url: "/keywords/#{keyword_id}/subscribe"
      method: "delete"
      success: (data) ->
        if data['success']
          btn.parents("tr").remove(); 
        else
          alert data['message']
        end
  $(".btn-clear").click ->
    $.ajax
      url: "/users/account"
      method: "delete"
      success: (data) ->
        if data['success']
          location.href = "/"
        else
          alert data['message']
        end
  active = ->
    btn = $(this)
    $.ajax
      url: "/users/active"
      method: "post"
      success: (data) ->
        if data['success']
          btn.text '暂时不想收到订阅'
          btn.removeClass 'btn-active btn-info'
          btn.addClass 'btn-unactive btn-warning'
          btn.unbind "click"
          btn.click unactive
        else
          alert data['message']
        end
  unactive = ->
    btn = $(this)
    $.ajax
      url: "/users/active"
      method: "delete"
      success: (data) ->
        if data['success']
          btn.text '恢复订阅'
          btn.removeClass 'btn-unactive btn-warning'
          btn.addClass 'btn-active btn-info'
          btn.unbind "click"
          btn.click active
        else
          alert data['message']
        end
  $(".btn-active").click active
  $(".btn-unactive").click unactive