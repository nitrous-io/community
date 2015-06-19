Community.DocCategoriesPage =
  init: ->
    $.attachConfirmClose("You will lose unsaved changes if you close the page.")

    $categoryListForm = $('#doc_category_list')

    updateOrder = ->
      $inputPositions = $categoryListForm.find('input.position')
      $inputPositions.each (i) ->
        $(this).val(i + 1)

    Sortable.create $categoryListForm[0], animation: 150, onUpdate: (e) ->
      el = e.item
      updateOrder()

    $(".row.table").on 'dragstart', (e) ->
      img = document.createElement("img")
      img.src = "data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7"
      e.originalEvent.dataTransfer.setDragImage(img, 0, 0)

    $('#new_doc_category').on 'submit', (e) ->
      $('#doc_category_position').val($("#doc_category_list input.position").length)
