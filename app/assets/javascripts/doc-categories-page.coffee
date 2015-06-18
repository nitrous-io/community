Community.DocCategoriesPage =
  init: ->
    $(window).on 'beforeunload', (evt) ->
      confirmationMessage = "You will lose unsaved changes if you close the page."
      (evt || window.event).returnValue = confirmationMessage # Gecko and Trident
      confirmationMessage # Gecko and WebKit
    
    updateOrder = ->
      $inputPositions = $("#doc_category_list input.position")
      $inputPositions.each (i) ->
        $(this).val(i + 1)
      
    categoryListForm = $("#doc_category_list")[0]
    Sortable.create categoryListForm, animation: 150, onUpdate: (e) -> 
      el = e.item
      updateOrder()
    
    $('#new_doc_category').on 'submit', (e) ->
      $('#doc_category_position').val($("#doc_category_list input.position").length)
      true
    