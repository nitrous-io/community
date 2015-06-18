Community.DocCategoriesPage =
  init: ->

    $(window).on 'beforeunload', (evt) ->
      confirmationMessage = "You will lose unsaved changes if you close the page."
      (evt || window.event).returnValue = confirmationMessage # Gecko and Trident
      confirmationMessage # Gecko and WebKit
    
    
    updateOrder = ->
      items = $("#doc_category_list .row")
      items.splice(-1,1)
      $.each items, (i, item) ->
        $(this).find('input.position').val i
      
    categoryListForm = $("#doc_category_list")[0]
    Sortable.create(categoryListForm, animation: 150, onUpdate: (e) -> 
                    el = e.item
                    updateOrder())