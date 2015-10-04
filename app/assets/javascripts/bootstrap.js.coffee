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
