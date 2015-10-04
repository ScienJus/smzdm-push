jQuery ->
  $("a[rel~=popover], .has-popover").popover()
  $("a[rel~=tooltip], .has-tooltip").tooltip()
  $(".btn-key").click ->
    $("#input-keyword").val($(this).text())
  $("#submit-keyword").click ->
    $("#tr-tools").before("<tr><td>" + $("#input-keyword").val() + "</td><td><button type='button' class='btn btn-danger btn-remove'>删除</button></td></td>")
    $("#create-modal").modal("toggle")
  $(".btn-remove").click ->
    $(this).parents("tr").remove(); 
